//
//  FilterViewController.swift
//  iOS-30
//
//  Created by 김민재 on 2023/03/21.
//

import UIKit

final class FilterViewController: UIViewController {

    private let dummy = Filter.dummy()

    private let tableView = UITableView()

    var completion: ((Filter) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setStyle()
        setLayout()
    }

    private func setStyle() {
        view.backgroundColor = .black
        
        tableView.do {
            $0.backgroundColor = .black
            $0.dataSource = self
            $0.delegate = self
            $0.rowHeight = 120
            $0.register(
                FilterTableViewCell.self,
                forCellReuseIdentifier: FilterTableViewCell.className
            )
        }
    }

    private func setLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension FilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        makeVibrate(degree: .medium)
        let filter = dummy[indexPath.item]
        completion?(filter)
        dismiss(animated: true)
    }
}

extension FilterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FilterTableViewCell.className, for: indexPath) as? FilterTableViewCell else { return UITableViewCell() }

        cell.configureCell(filter: dummy[indexPath.item])
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummy.count
    }
}
