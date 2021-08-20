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
    }
}

extension PaymentMethodsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfPaymentMethods
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)

        if let method = viewModel.paymentMethod(for: indexPath.row) {
            cell.textLabel!.text = method.title
            cell.detailTextLabel!.text = method.details
        }
        return cell
    }
}

extension PaymentMethodsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectPayment(for: indexPath.row)
        dismiss(animated: true) {
            self.delegate?.didSelectPaymentMethod()
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
