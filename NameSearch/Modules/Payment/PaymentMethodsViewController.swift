import UIKit

protocol PaymentMethodsViewControllerDelegate {
    func didSelectPaymentMethod()
}

protocol PaymentMethodsViewType: AnyObject {
    func updateUI()
    func showError()
}

class PaymentMethodsViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    var delegate: PaymentMethodsViewControllerDelegate?
    var paymentMethods: [PaymentMethod]?

    var viewModel:PaymentType!
    
  
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel  = PaymentMethodViewModel(paymentMethodsView:self)

        viewModel.fetchPaymentMethods()
//        let request = URLRequest(url: URL(string: "https://gd.proxied.io/user/payment-methods")!)
//        let session = URLSession(configuration: .default)
//        let task = session.dataTask(with: request) { (data, response, error) in
//            guard error == nil else { return }
//
//            self.paymentMethods = try!
//                JSONDecoder().decode([PaymentMethod].self, from: data!)
//
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        }
//
//        task.resume()
    }
}

extension PaymentMethodsViewController: UITableViewDataSource, UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfPaymentMethods
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)

        if let method = viewModel.paymentMethod(for: indexPath.row) {
            cell.textLabel!.text = method.name
            if let lastFour = method.lastFour {
                cell.detailTextLabel!.text = "Ending in \(lastFour)"
            } else {
                cell.detailTextLabel!.text = method.displayFormattedEmail!
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let method = viewModel.paymentMethod(for: indexPath.row) {
            PaymentsManager.shared.selectedPaymentMethod = method
            dismiss(animated: true) {
                self.delegate?.didSelectPaymentMethod()
            }
        }
    }
}

extension PaymentMethodsViewController: PaymentMethodsViewType {
    func updateUI() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    func showError() {
        
    }
}
