import UIKit

final class WinesViewController: BaseViewController {
    
    // MARK: - Outlets
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.contentInset = UIEdgeInsets.init(top: -20, left: 0, bottom: 8, right: 0)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 64
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private lazy var countryLabel: UILabel = {
        let countryLabel = UILabel()
        countryLabel.font = AppFont.charterBold(ofSize: 17)
        countryLabel.textColor = AppTheme.unselected
        countryLabel.textAlignment = .center
        countryLabel.translatesAutoresizingMaskIntoConstraints = false
        return countryLabel
    }()
    
    private lazy var volumeLabel: UILabel = {
        let volumeLabel = UILabel()
        volumeLabel.font = AppFont.charterBold(ofSize: 14)
        volumeLabel.textColor = AppTheme.highlighted
        volumeLabel.textAlignment = .right
        volumeLabel.translatesAutoresizingMaskIntoConstraints = false
        return volumeLabel
    }()
    
    // MARK: - Instance Properties
    var viewModel: WinesViewModel! {
        didSet { bind() }
    }
    
    // MARK: - Instance Methods
    private func configureTableView() {
        tableView.tableHeaderView?.frame.size.height = 29
    }
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        view.addSubview(countryLabel)
        view.addSubview(volumeLabel)
        tableView.registerViewModel(WinesMainViewModel.self)
        configureTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let volumeWidth = view.bounds.width == 0.0 ? 0.0 : view.bounds.width - 20
        countryLabel.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 40)
        volumeLabel.frame = CGRect(x: 0, y: 0, width: volumeWidth, height: 40)
        tableView.frame = CGRect(x: 25, y: 50, width: view.bounds.width - 25, height: view.bounds.height - 50)
    }
    
    private func bind() {
        tableView.dataSource = viewModel
        viewModel.onWinesDidLoad = { [weak self] wines in
            guard let sself = self else { return }
            UI_THREAD {
                if (wines.count > 0) {
                    sself.countryLabel.text = sself.viewModel.productsTitle
                    if sself.viewModel.volumeTitle == 1.5 {
                        sself.volumeLabel.text = "1,5 л"
                    } else if sself.viewModel.volumeTitle == 0.375 {
                        sself.volumeLabel.text = "0,375 л"
                    } else {
                        sself.volumeLabel.text = "0,75 л"
                    }
                } else {
                    sself.countryLabel.text = ""
                    sself.volumeLabel.text = ""
                }
                if (wines.isEmpty) {
                    var title = ""
                    if sself.viewModel.productsTitle.contains("Поиск") {
                        title = "Нет продуктов, подходящих под критерии поиска."
                    } else {
                        title = "Данные для категории пока что не загружены."
                    }
                    let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: Localization.Common.OK, style: .default, handler: nil))
                    sself.present(alert, animated: true, completion: nil)
                }
                sself.tableView.reloadData()
                if !wines.isEmpty { sself.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true) }
            }
        }
        viewModel.onWinesDidFail = { [weak self] error in
            UI_THREAD {
                guard let sself = self else { return }
                let alert = UIAlertController(error: error)
                alert.addAction(UIAlertAction(title: Localization.Common.OK, style: .default, handler: nil))
                sself.present(alert, animated: true, completion: nil)
            }
        }
    }
}

// MARK: - UITableViewDelegate

extension WinesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.selectWine(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if viewModel.sortedGroupsTitles[section] == "" {
            return 0.0
        }
        return 55.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.backgroundColor = AppTheme.background
        label.text = viewModel.sortedGroupsTitles[section]
        label.font = AppFont.charterBold(ofSize: 17)
        label.textColor = AppTheme.unselected
        label.textAlignment = .left
        return label
    }
    
}

