//
//  CountriesListViewController.swift
//  Global-List
//
//  Created by Nikolay Gutorov on 7/12/21.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class CountriesListViewController: BaseViewController {
    
    // MARK: - Outlets
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let activityIndicator = UIActivityIndicatorView()
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchBar: UISearchBar { return searchController.searchBar }
    
    // MARK: - Properties
    
    private let viewModel: CountriesListViewModelType
    private var isBindingUpdated: Bool = false
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    
    init(_ viewModel: CountriesListViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupLayout()
        
        viewModel.inputs.viewDidLoadSubject.onNext(nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !isBindingUpdated {
            isBindingUpdated.toggle()
            setupBindings()
        }
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        
        // Search Bar
        searchBar.barStyle = .default
        searchBar.placeholder = "Search by name, capital or region"
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        // Table View
        tableView.register(CountriesTableViewCell.self, forCellReuseIdentifier: CountriesTableViewCell.identifier)
        tableView.rowHeight = 90
        tableView.delegate = nil
        tableView.dataSource = nil
        view.addSubview(tableView)
        
        // Title View - Naviagtion Item
        view.backgroundColor = .white
        let titleStackView = UIStackView()
        let label = UILabel()
        label.text = "Global List - Countries Catalog"
        label.textColor = .systemBlue
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(systemName: "globe")
        titleStackView.addArrangedSubview(logoImageView)
        titleStackView.addArrangedSubview(label)
        titleStackView.axis = .horizontal
        titleStackView.spacing = 8
        navigationItem.titleView = titleStackView
        
        // Back Bar Button
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "",
                                                           style: .plain,
                                                           target: nil,
                                                           action: nil)
        
        // Setup Activity Indicator
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
    }
    
    // MARK: - Setup Layout
    
    private func setupLayout() {
        
        // Table View
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        // Activity Indicator
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(40)
        }
    }
    
    // MARK: - Setup Bindings
    
    private func setupBindings() {
        
        // Load Table View Data
        viewModel.outputs.data
            .bind(to: self.tableView
                    .rx.items(cellIdentifier: CountriesTableViewCell.identifier)) { _, model, cell in
                let cell = cell as? CountriesTableViewCell
                cell?.configureWith(model)
            }.disposed(by: disposeBag)
        
        // Search Bar
        searchBar.rx.text
            .map { $0 ?? "" }
            .bind(to: viewModel.searchSubject)
            .disposed(by: disposeBag)
        
        searchBar.rx.cancelButtonClicked
            .subscribe(onNext: { [unowned self] in
                self.viewModel.data.accept(viewModel.sourceData.value)
            })
            .disposed(by: disposeBag)
        
        // Show Alert on Error
        viewModel.outputs.errorSubject
            .subscribe(onNext: { [weak self] errorString in
                self?.showAlert(title: "Error", message: errorString)
            }).disposed(by: disposeBag)
        
        // Activity Indicator
        viewModel.outputs.isLoadingSubject
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        // Notify ViewModel if TableView cell tapped - pass CountryModel
        Observable
            .zip(tableView.rx.itemSelected, tableView.rx.modelSelected(CountryModel.self))
            .bind { [unowned self] indexPath, model in
                self.tableView.deselectRow(at: indexPath, animated: true)
                viewModel.outputs.selectedSubject.onNext(model)
            }.disposed(by: disposeBag)
        
    }
}
