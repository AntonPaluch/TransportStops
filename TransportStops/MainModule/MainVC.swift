import UIKit
import SnapKit

protocol MainViewProtocol: AnyObject {
    func setAllBusStops()
    func showAlert(with error: Error)
}

final class MainVC: UIViewController {
    
    // MARK: - Private Properties
    
    var presenter: MainPresenterProtocol!
    
    private let tableView = UITableView(frame: .zero, style: .plain)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9709939361, green: 0.9568827748, blue: 0.9220435023, alpha: 1)
        setupTableView()
        presenter.getAllBusStops()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        // Constraints
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - TableView data source

extension MainVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.busStops.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let busStop = presenter.busStops[indexPath.row]
        cell.textLabel?.text = busStop.name
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.textColor = #colorLiteral(red: 0.2823102176, green: 0.1690107286, blue: 0.146335572, alpha: 1)
        return cell
    }
}

// MARK: - TableView delegate

extension MainVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let busStop = presenter.busStops[indexPath.row]
        let secondVC = ModuleAssembler.createDetailModule(busStop: busStop)
        secondVC.modalPresentationStyle = .fullScreen
        present(secondVC, animated: true, completion: nil)
    }
}

// MARK: - MainView Protocol

extension MainVC: MainViewProtocol {
    
    func setAllBusStops() {
        tableView.reloadData()
    }
    
    func showAlert(with error: Error) {
        let alert = AlertFactory.showAlert(with: error)
        present(alert, animated: true, completion: nil)
    }
}
