import UIKit

protocol CartItemTableViewCellDelegate: AnyObject {
    func didRemoveFromCart()
}

class CartItemTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var removeButton: UIButton!

    weak var delegate: CartItemTableViewCellDelegate!

    override func prepareForReuse() {
        nameLabel.text = ""
        priceLabel.text = ""
    }
    
    @IBAction func removeFromCartButtonTapped(_ sender: UIButton) {
        ShoppingCart.shared.domains = ShoppingCart.shared.domains.filter { $0.name != nameLabel.text! }

        delegate.didRemoveFromCart()
    }

}
