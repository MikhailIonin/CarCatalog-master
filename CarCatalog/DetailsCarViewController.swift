import UIKit

final class DetailsCarViewController: UIViewController {

	@IBOutlet weak var id: UILabel!
	@IBOutlet weak var year: UITextField!
	@IBOutlet weak var vendor: UITextField!
	@IBOutlet weak var model: UITextField!
	@IBOutlet weak var bodyType: UITextField!

	private let storage: IStorage = UserDefaultsStorage.shared

	override func viewDidLoad() {
		super.viewDidLoad()

		self.year.keyboardType = .decimalPad

		self.navigationItem.rightBarButtonItem = UIBarButtonItem(
			title: "Save",
			style: .plain,
			target: self,
			action: #selector(self.didTapSaveButton)
		)

		if let car = self.storage.selectedCar {
			self.id.text = car.uuid
			self.year.text = car.year
			self.vendor.text = car.vendor
			self.model.text = car.model
			self.bodyType.text = car.bodyType
		}
	}

	@objc private func didTapSaveButton() {
		guard let selectedCar = self.storage.selectedCar else { return }
		let newCar = Car(
			uuid: selectedCar.uuid,
			year: self.year.text ?? selectedCar.year,
			vendor: self.vendor.text ?? selectedCar.vendor,
			model: self.model.text ?? selectedCar.model,
			bodyType: self.bodyType.text ?? selectedCar.bodyType
		)

		self.storage.edit(car: newCar)
	}

}
