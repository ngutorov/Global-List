//
//  CountriesListViewModel.swift
//  Global-List
//
//  Created by Nikolay Gutorov on 7/12/21.
//

import RxSwift
import RxCocoa

// MARK: - CountriesList Protocol

protocol CountriesListViewModelType: CountriesListViewModelInputs, CountriesListViewModelOutputs {
    var inputs: CountriesListViewModelInputs { get }
    var outputs: CountriesListViewModelOutputs { get }
}

// MARK: - Input Protocol

protocol CountriesListViewModelInputs: AnyObject {
    var viewDidLoadSubject: PublishSubject<Void?> { get }
    var cellTapSubject: PublishSubject<Void> { get }
    var searchSubject: PublishSubject<String> { get }
}

// MARK: - Output Protocol

protocol CountriesListViewModelOutputs: AnyObject {
    var isLoadingSubject: PublishSubject<Bool> { get }
    var data: BehaviorRelay<[CountryModel]> { get }
    var sourceData: BehaviorRelay<[CountryModel]> { get }
    var searchData: BehaviorRelay<[CountryModel]> { get }
    var selectedSubject: PublishSubject<CountryModel?> { get }
    var errorSubject: PublishSubject<String?> { get }
}

// MARK: - Implementation CountriesListViewModel

final class CountriesListViewModel: CountriesListViewModelType {
    var inputs: CountriesListViewModelInputs { self }
    var outputs: CountriesListViewModelOutputs { self }
    
    // MARK: Inputs
    
    let viewDidLoadSubject = PublishSubject<Void?>()
    let selectedSubject = PublishSubject<CountryModel?>()
    let cellTapSubject = PublishSubject<Void>()
    let searchSubject = PublishSubject<String>()
    
    // MARK: Outputs
    
    let isLoadingSubject = PublishSubject<Bool>()
    let data = BehaviorRelay<[CountryModel]>.init(value: [])
    let sourceData = BehaviorRelay<[CountryModel]>.init(value: [])
    let searchData = BehaviorRelay<[CountryModel]>.init(value: [])
    let errorSubject = PublishSubject<String?>()
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    private let service: NetworkServiceProtocol
    var searchPersistentData: CountryModel?
    
    // MARK: Init
    
    init(_ service: NetworkServiceProtocol) {
        self.service = service
        
        setupRxBindings()
    }
    
    // MARK: Bindings
    private func setupRxBindings() {
        
        // Fetch countries list on viewDidLoad
        inputs.viewDidLoadSubject.subscribe(onNext: { [weak self] _ in
            self?.fetchCountriesList()
        }).disposed(by: disposeBag)
        
        searchSubject
            .asObservable()
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
            .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
            .flatMapLatest { [unowned self] item -> Observable<[CountryModel]> in
                return self.search(for: item)
                    .catch { [unowned self] error -> Observable<[CountryModel]> in
                        self.errorSubject.onNext("Search Error")
                        return Observable.empty()
                    }
            }
            .subscribe(onNext: { [unowned self] items in
                self.data.accept(items)
            }).disposed(by: disposeBag)
    }
    
    // MARK: Service Call
    
    private func fetchCountriesList() {
        
        // Start loading animation
        outputs.isLoadingSubject.onNext(true)
        
        service
            .load(ArrayResource<CountryModel>(action: .loadCountriesList))
            .flatMap(ignoreNil)
            .debug()
            .map({ [weak self] model -> [CountryModel] in
                guard let self = self else { return [] }
                
                // Stop loading animation
                self.outputs.isLoadingSubject.onNext(false)
                
                // Fetch and concatenate previous data to the list of countries
                let data = self.outputs.sourceData.value
                let countries = data + model.compactMap {$0}
                return countries
            })
            .subscribe(onNext: { [weak self] countries in
                guard let self = self else { return }
                
                // Add data to the main data object
                self.outputs.sourceData.accept(countries)
                self.outputs.data.accept(countries)
            }, onError: { [weak self] error in
                guard let self = self else { return }
                
                // Stop loading animation
                self.outputs.isLoadingSubject.onNext(false)
                
                // Show error alert
                self.outputs.errorSubject.onNext(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Search
    
    func search(for item: String) -> Observable<[CountryModel]> {
        let countries = item.isEmpty ? [] : sourceData.value
        let filtered = countries.filter {
            
            $0.name
                .range(of: item,
                       options: [.anchored, .caseInsensitive, .diacriticInsensitive]) != nil ||
                $0.capital?
                .range(of: item,
                       options: [.anchored, .caseInsensitive, .diacriticInsensitive]) != nil ||
                $0.region
                .range(of: item,
                       options: [.anchored, .caseInsensitive, .diacriticInsensitive]) != nil
        }
        
        return Observable.create({ observer -> Disposable in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if !filtered.isEmpty {
                    observer.onNext(filtered)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        })
    }
}
