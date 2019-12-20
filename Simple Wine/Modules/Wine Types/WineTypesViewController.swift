import UIKit

final class WineTypesViewController: BaseViewController {
    
    // MARK: - Outlets
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 64
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    // MARK: - Instance Properties
    var viewModel: WineTypesViewModel! {
        didSet { bind() }
    }
    
    private var isTouchFirst = false
    
    // MARK: - Instance Methods
    private func configureTableView() {
        tableView.tableHeaderView?.frame.size.height = 29
    }
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        isTouchFirst = false
        view.addSubview(tableView)
        tableView.registerViewModel(WineTypeCellViewModel.self)
        configureTableView()
        viewModel.didFirstSelected = touchFirst
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func bind() {
        tableView.dataSource = viewModel
        viewModel.didCategoriesLoad = { [weak self] _ in
            guard let sself = self else { return }
            UI_THREAD {
                if (sself.viewModel.categories.isEmpty) {
                    let alert = UIAlertController(title: "Данные для категории пока что не загружены.", message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: Localization.Common.OK, style: .default, handler: nil))
                    sself.present(alert, animated: true, completion: nil)
                }
                sself.tableView.reloadData()
                sself.viewModel.heightForView = 0.0
                for _ in 0..<sself.tableView.numberOfRows(inSection: 0) {
                    sself.viewModel.heightForView += 40
                }
                sself.viewModel.didResizeView?()
                if sself.isTouchFirst {
                    sself.setFirst()
                }
            }
        }
        viewModel.didCategoriesLoadFail = { [weak self] error in
            guard let sself = self else { return }
            UI_THREAD {
                let alert = UIAlertController(error: error)
                alert.addAction(UIAlertAction(title: Localization.Common.OK, style: .default, handler: nil))
                sself.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    private func touchFirst() {
        guard viewModel.categories.count > 0 else { return }
        
        let indexPath = IndexPath(row: 0, section: 0)
        isTouchFirst = true
        setFirst()
        viewModel.selectCategory(for: viewModel.categories[indexPath.row].name)
    }
    
    private func setFirst() {
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
    }
    
}

extension WineTypesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if tableView.indexPathForSelectedRow == indexPath {
            return nil
        } else {
            return indexPath
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectCategory(for: viewModel.categories[indexPath.row].name)
    }
    
}


