import UIKit



protocol CartViewType: AnyObject {
    func updateUI()
    func showError(error:String)
}

class CartViewController: UIViewController {

    @IBOutlet var payButton: UIButton!
    @IBOutlet var tableView: UITableView!

    
    var viewModel:CartType!
  
    @IBAction func payButtonTapped(_ sender: UIButton) {
        if !viewModel.isPaymentMethodSelected {
            self.performSegue(withIdentifier: "showPaymentMethods", sender: self)
        } else {
            performPayment()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel  = CartViewModel(cartView:self)

        tableView.register(UINib(nibName: "CartItemTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "CartItemCell")
        updatePayButton()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! PaymentMethodsViewController
        vc.delegate = self
    }
    
    private func updatePayButton() {
        payButton.setTitle(viewModel.getPayButtonTitle(), for: .normal)
    }

    private func performPayment() {
        payButton.isEnabled = false
        viewModel.performPayment()
    }    
}

extension CartViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfDomains
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartItemCell", for: indexPath) as? CartItemTableViewCell else {
            return UITableViewCell()
        }

        cell.delegate = self

        if let domain = viewModel.getDomain(for: indexPath.row) {
            cell.nameLabel.text = domain.name
            cell.priceLabel.text = domain.price
        }

        return cell
    }
}

extension CartViewController: CartItemTableViewCellDelegate {
    func didRemoveFromCart() {
        updatePayButton()
        tableView.reloadData()
    }
}

extension CartViewController: PaymentMethodsViewControllerDelegate {
    func didSelectPaymentMethod() {
        updatePayButton()
    }
}

extension CartViewController: CartViewType {
    func updateUI() {
        let controller = UIAlertController(title: "All done!", message: "Your purchase is complete!", preferredStyle: .alert)

        let action = UIAlertAction(title: "Ok", style: .default) { _ in }

        controller.addAction(action)

        DispatchQueue.main.async {
            self.present(controller, animated: true)
        }
    }
    
    func showError(error:String) {
        let controller = UIAlertController(title: "Oops!", message:error, preferredStyle: .alert)

        let action = UIAlertAction(title: "Ok", style: .cancel) { _ in
            self.payButton.isEnabled = true
        }

        controller.addAction(action)

        DispatchQueue.main.async {
            self.present(controller, animated: true)
        }
    }
}
