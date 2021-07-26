//
//  CountiesDetailViewController.swift
//  Global-List
//
//  Created by Nikolay Gutorov on 7/20/21.
//

import UIKit
import RxSwift
import WebKit
import SnapKit

final class CountriesDetailViewController: BaseViewController {
    
    // MARK: - Outlets
    
    private let webView = WKWebView()
    private let activityIndicator = UIActivityIndicatorView()
    
    // MARK: - Properties
    
    private let viewModel: CountriesDetailViewModelType
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    
    init(_ viewModel: CountriesDetailViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
        setupLayout()
        setupUI()
        loadWebView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isBeingDismissed || isMovingFromParent {
            viewModel.dismissSubject.onNext(nil)
        }
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        
        // Setup Web View
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = false
        webView.allowsLinkPreview = false
        
        // Setup Activity Indicator
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
    }
    
    // MARK: - Setup Layout
    
    private func setupLayout() {
        
        // Web View
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        // Activity Indicator
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(40)
        }
    }
    
    // MARK: - Setup Bindings
    
    private func setupBindings() {
        
        viewModel.isLoadingSubject
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        // Show Alert on Error
        viewModel.outputs.errorSubject
            .subscribe(onNext: { [weak self] errorString in
                self?.showAlert(title: "Error", message: errorString)
            }).disposed(by: disposeBag)
    }
    
    // MARK: - Helpers
    
    private func loadWebView() {
        
        // Load Web View
        let countryName = viewModel.loadDetailSubject.value
        let url = CountriesDetailUrlBuilder.shared.makeUrl(for: countryName ?? "")
        let request = URLRequest(url: url)
        webView.load(request)
        
        viewModel.isLoadingSubject.onNext(true)
    }
}

// MARK: - WKNavigationDelegate

extension CountriesDetailViewController: WKNavigationDelegate {
    
    // Disabling links interaction
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated {
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        viewModel.isLoadingSubject.onNext(false)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        viewModel.isLoadingSubject.onNext(false)
        viewModel.errorSubject.onNext(error.localizedDescription)
    }
}
