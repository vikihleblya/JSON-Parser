import UIKit

class CategoryController: UITableViewController {

    
    var presenter: CategoryPresenterProtocol?
    var categories: [Category] = []{
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        
    }
}

extension CategoryController: CategoryViewProtocol{
    func showCategories(with categories: [Category]) {
        self.categories = categories
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func showError() {
        print("OOOPS, it's an error on ViewController")
    }
    
    
}


//  MARK: Work with tableView

extension CategoryController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
}

