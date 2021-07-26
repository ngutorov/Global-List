//
//  CountriesDetailViewModel.swift
//  Global-List
//
//  Created by Nikolay Gutorov on 7/20/21.
//

import RxSwift
import RxCocoa

// MARK: - CountriesDetail Protocol

protocol CountriesDetailViewModelType: CountriesDetailInputs, CountriesDetailOutputs {
    var inputs: CountriesDetailInputs { get }
    var outputs: CountriesDetailOutputs { get }
}

// MARK: - Input Protocol

protocol CountriesDetailInputs: AnyObject {
    var loadDetailSubject: BehaviorRelay<String?> { get } // Search Item Model
}

// MARK: - Output Protocol

protocol CountriesDetailOutputs: AnyObject {
    var isLoadingSubject: PublishSubject<Bool> { get }
    var dismissSubject: PublishSubject<Void?> { get }
    var errorSubject: PublishSubject<String> { get }
}

// MARK: - Implementation CountriesDetailViewModel

final class CountriesDetailViewModel: CountriesDetailViewModelType {
    
    var inputs: CountriesDetailInputs { self }
    var outputs: CountriesDetailOutputs { self }
    
    // MARK: Inputs
    
    let loadDetailSubject = BehaviorRelay<String?>.init(value: nil)
    
    // MARK: Outputs
    
    let isLoadingSubject = PublishSubject<Bool>()
    let dismissSubject = PublishSubject<Void?>()
    let errorSubject = PublishSubject<String>()
}
