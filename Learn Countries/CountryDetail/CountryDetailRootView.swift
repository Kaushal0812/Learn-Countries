//
//  CountryDetailRootView.swift
//  Learn Countries
//
//  Created by Kaushal on 18/02/21.
//

import UIKit

protocol CountryDetailRootViewDelegate: AnyObject {
    func refreshData()
    func showAlert(alert: UIAlertController)
}

final class CountryDetailRootView: UIView {
    unowned var delegate: CountryDetailRootViewDelegate?

    var viewModel = ProvinceViewModel(province: nil)

    lazy var emptyView = self.makeEmptyView()
    let activityIndicator = UIActivityIndicatorView(style: .medium)

    func makeEmptyView() -> UIView {
        let view = UIView()
        let titleLabel = UILabel()
        titleLabel.text = "Visit me later."
        let imageView = UIImageView(image: #imageLiteral(resourceName: "noData"))
        imageView.al.size.set(.init(width: 200, height: 200))
        let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .equalSpacing

        view.addSubview(stackView) {
            $0.centerX.alignWithSuperview()
            $0.centerY.alignWithSuperview()
        }
        view.isHidden = true
        return view
    }

    lazy var tableView: UITableView = {
        var tableView = UITableView(frame: .zero)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(CountryCell.self, forCellReuseIdentifier: "CountryCell")
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 87
        tableView.rowHeight = UITableView.automaticDimension

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(needToRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        return tableView
    }()

    init() {
        super.init(frame: .zero)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        backgroundColor = .white
        activityIndicator.hidesWhenStopped = true
        addSubview(tableView) {
            $0.edges.pinToSuperview()
        }

        addSubview(emptyView) {
            $0.edges.pinToSuperview()
        }

        addSubview(activityIndicator) {
            $0.center.alignWithSuperview()
        }
        
        
       
    }
    
    func showError(error: String, retryClosure: @escaping ClosureEmptyParameter) {
        let showCancelButton = !(viewModel.sections.first?.rows.isEmpty ?? true)
        
        let alert = UIAlertController(title: "", message: error, preferredStyle: .alert)
               let ok = UIAlertAction(title: "Retry", style: .default, handler: { (action) -> Void in
                   retryClosure()
               })
               let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
               }
               
        alert.addAction(ok)
        if(showCancelButton){
          alert.addAction(cancel)
        }
        delegate?.showAlert(alert: alert)
    }

    @objc func needToRefresh() {
        tableView.refreshControl?.endRefreshing()
        delegate?.refreshData()
    }

    func showLoading() {
        activityIndicator.startAnimating()
    }

    func hideLoading() {
        activityIndicator.stopAnimating()
    }
    
}

// MARK: - ViewConfigurable

extension CountryDetailRootView {
    func configure(with viewModel: ProvinceViewModel) {
        self.viewModel = viewModel
        backgroundColor = .white
        emptyView.isHidden = !(viewModel.sections.first?.rows.isEmpty ?? false)
        tableView.isHidden = viewModel.sections.first?.rows.isEmpty ?? false
        tableView.reloadData()
    }
}

extension CountryDetailRootView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard !viewModel.sections.isEmpty else { return 0 }
        if section == viewModel.sections.count - 1 {
            return viewModel.sections[section].totalRows
        } else {
            return viewModel.sections[section].rows.count
        }
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let emptyCell = UITableViewCell()

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath) as? CountryCell else {  return emptyCell }
        if let rowViewModel = viewModel.sections.row(at: indexPath) {
            cell.configure(with: rowViewModel)
        } else {
            return emptyCell
        }
        return cell
    }

}
