//
//  CountryCell.swift
//  Learn Countries
//
//  Created by Kaushal on 18/02/21.
//

import UIKit
import Kingfisher

struct CountryCellRowViewModel {}

class CountryCell: UITableViewCell {
    // MARK: - Properties

    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    var flagImageView = UIImageView()
    let codeLabel = UILabel()
    let nameLabel = UILabel()

    // MARK: - Life Cycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    private func setupView() {
        contentView.addSubview(containerView) {
            $0.edges.pinToSuperview(insets: .init(top: 14, left: 10, bottom: 0, right: 10))
        }

        containerView.addSubview(codeLabel) {
            $0.leading.pinToSuperview(inset: 20)
            $0.trailing.pinToSuperview(inset: 20)
            $0.top.pinToSuperview(inset: 20)
        }

        containerView.addSubview(nameLabel) {
            $0.leading.pinToSuperview(inset: 20)
            $0.trailing.pinToSuperview(inset: 20)
            $0.top.align(with: codeLabel.al.bottom + 10)
            $0.bottom.pinToSuperview(inset: 20)
        }

        flagImageView.contentMode = .scaleAspectFit
        containerView.addSubview(flagImageView) {
            $0.trailing.pinToSuperview(inset: 20)
            $0.centerY.alignWithSuperview()
            
            $0.size.set(CGSize(width: 30, height: 40))
        }
        backgroundColor = .lightGray
    }
}

// MARK: - ViewConfigurable

extension CountryCell {
    func configure(with viewModel: CountryListRowViewModel) {
        codeLabel.text = viewModel.code
        nameLabel.text = viewModel.name
        
        if let flagCode = viewModel.code,
           let url = URL(string: "https://www.countryflags.io/\(flagCode)/flat/64.png") {
            flagImageView.kf.setImage(with: url)
        }
    }

    func configure(with viewModel: ProvinceRowViewModel) {
        flagImageView.isHidden = true
        codeLabel.text = viewModel.code
        nameLabel.text = viewModel.name
    }
}
