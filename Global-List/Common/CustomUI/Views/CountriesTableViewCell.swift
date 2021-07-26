//
//  CountriesTableViewCell.swift
//  Global-List
//
//  Created by Nikolay Gutorov on 7/12/21.
//

import UIKit
import Kingfisher

final class CountriesTableViewCell: UITableViewCell {
    
    // MARK: - Cell Identifier
    
    static let identifier = "CountryCell"
    
    // MARK: - Properties
    
    private let countryNameLabel = UILabel()
    private let countryCapitalLabel = UILabel()
    private let countryRegion = UILabel()
    private let countryFlagImageView = UIImageView()
    
    // Containers
    private let containerStackView = UIStackView()
    private let contentStackView = UIStackView()
    private let countryInfoContainer = UIStackView()
    private let countryRegionContainer = UIStackView()
    
    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard contentView.subviews.isEmpty else { return }
        
        setupUI()
        setupLayout()
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        
        // countryFlagImageView
        countryFlagImageView.contentMode = .scaleToFill
        
        // countryNameLabel
        countryNameLabel.font = .boldSystemFont(ofSize: 16)
        countryNameLabel.textAlignment = .left
        countryNameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        // countryCapitalLabel
        countryCapitalLabel.font = .systemFont(ofSize: 13)
        countryCapitalLabel.textAlignment = .right
        
        // countryRegion
        countryRegion.font = .systemFont(ofSize: 13)
        countryRegion.textAlignment = .left
        countryRegion.textColor = .lightGray
        
        // StackViews:
        
        containerStackView.axis = .vertical
        containerStackView.spacing = 10
        
        contentStackView.axis = .horizontal
        contentStackView.spacing = 20
        
        countryInfoContainer.axis = .horizontal
        countryInfoContainer.spacing = 8
        
        countryRegionContainer.axis = .horizontal
        countryRegionContainer.spacing = 8
    }
    
    // MARK: - Layout
    
    private func setupLayout() {
        
        // countryInfoRegionContainer
        countryInfoContainer.addArrangedSubview(countryNameLabel)
        countryInfoContainer.addArrangedSubview(countryCapitalLabel)
        
        // countryCodingContainer
        countryRegionContainer.addArrangedSubview(countryRegion)
        
        // containerStackView
        containerStackView.addArrangedSubview(countryInfoContainer)
        containerStackView.addArrangedSubview(countryRegionContainer)
        
        // contentStackView
        contentStackView.addArrangedSubview(countryFlagImageView)
        contentStackView.addArrangedSubview(containerStackView)
        
        // contentView
        contentView.addSubview(contentStackView)
        
        // MARK: Constraints
        
        // countryFlagImageView
        countryFlagImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.width.equalTo(90)
        }
        
        // contentStackView
        contentStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-15)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
        }
    }
    
    // MARK: - Configure
    
    func configureWith(_ viewModel: CountryModel) {
        countryNameLabel.text = viewModel.name
        countryRegion.text = viewModel.region
        countryCapitalLabel.text = viewModel.capital ?? ""
        
        // TODO: Remove this check when SVGKit bug is fixed. SVGKit can crash the app on bad SVG file.
        if viewModel.flag ?? "" == "https://restcountries.eu/data/shn.svg" { return }
        
        countryFlagImageView.kf.setImage(with: URL(string: viewModel.flag ?? ""),
                                         options: [.processor(SVGImgProcessor())])
    }
}


