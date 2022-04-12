import UIKit

protocol MainViewProtocol: AnyObject {
    func setAllBusStops()
    func showAlert(with error: Error)
}

class FirstViewController: UIViewController {
    
    var presenter: MainPresenterProtocol!
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        setupTableView()
        presenter.getAllBusStops()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - TableView data source

extension FirstViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.busStops.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let busStop = presenter.busStops[indexPath.row]
        cell.textLabel?.text = busStop.name
        cell.textLabel?.numberOfLines = 0
        return cell
    }
}

// MARK: - TableView delegate

extension FirstViewController: UITableViewDelegate {
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        let busStop = presenter.busStops1[indexPath.row]
//        let secondVC = ModuleAssembler.createSecondModule(busStop1: busStop1)
//        secondVC.modalPresentationStyle = .fullScreen
//        present(secondVC, animated: true, completion: nil)
//    }
}

// MARK: - FirstView Protocol

extension FirstViewController: MainViewProtocol {
    
    func setAllBusStops() {
        tableView.reloadData()
    }
    
    func showAlert(with error: Error) {
        let alert = AlertFactory.showAlert(with: error)
        present(alert, animated: true, completion: nil)
    }
}
