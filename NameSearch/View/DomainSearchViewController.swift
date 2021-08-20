import Foundation
import UIKit


protocol SearchViewType: AnyObject {
    func updateUI()
    func showError()
}

class DomainSearchViewController: UIViewController {

    @IBOutlet var searchTermsTextField: UITextField!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var cartButton: UIButton!

    var viewModel:Searchable!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel  = SearchViewModel(searchView: self)
        configureCartButton()
    }
   
    private func loadData() {
        viewModel.search(keyWord: searchTermsTextField.text)
    }

    private func configureCartButton() {
        cartButton.isEnabled = !ShoppingCart.shared.domains.isEmpty
        cartButton.backgroundColor = cartButton.isEnabled ? .black : .lightGray
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        searchTermsTextField.resignFirstResponder()
        loadData()
    }

    @IBAction func cartButtonTapped(_ sender: UIButton) {

    }
}

extension DomainSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)

        let domain = viewModel.domains[indexPath.row]
        cell.textLabel!.text = domain.name
        cell.detailTextLabel!.text = domain.price

        let selected = ShoppingCart.shared.domains.contains(where: { $0.name == domain.name })

        DispatchQueue.main.async {
            cell.setSelected(selected, animated: true)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.domains.count
    }

}

extension DomainSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let domain = viewModel.domains[indexPath.row]
        ShoppingCart.shared.domains.append(domain)

        configureCartButton()
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let domain = viewModel.domains[indexPath.row]
        ShoppingCart.shared.domains = ShoppingCart.shared.domains.filter { $0.name != domain.name }

        configureCartButton()
    }
}

extension DomainSearchViewController: SearchViewType {
    func updateUI() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func showError() {
        
    }
}
