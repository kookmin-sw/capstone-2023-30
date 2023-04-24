//
//  FilterTableViewCell.swift
//  iOS-30
//
//  Created by 김민재 on 2023/04/24.
//

import UIKit
import SnapKit
import Then

final class FilterTableViewCell: UITableViewCell {

    private var selectedFilter = 0

    private lazy var filterImageView = UIImageView()

    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
        $0.textColor = .white
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
        setStyle()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            contentView.layer.borderWidth = 2
            contentView.layer.borderColor = UIColor.lightGray.cgColor
        } else {
            contentView.layer.borderWidth = 0
        }
    }

    private func setStyle() {
        filterImageView.layer.cornerRadius = 5
        filterImageView.clipsToBounds = true
        contentView.backgroundColor = .black
    }

    private func setLayout() {
        contentView.addSubViews([filterImageView, titleLabel])
        filterImageView.snp.makeConstraints {
            $0.size.equalTo(100)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(10)
        }

        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(filterImageView.snp.trailing).offset(14)
            $0.centerY.equalTo(filterImageView)
        }
    }

    func configureCell(filter: Filter) {
        filterImageView.image = filter.image
        titleLabel.text = filter.name
    }

}
