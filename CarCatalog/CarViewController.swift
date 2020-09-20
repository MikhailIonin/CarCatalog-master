import UIKit

class CarViewController: UITableViewController {

	private let storage: IStorage = UserDefaultsStorage.shared

    override func viewDidLoad() {
        super.viewDidLoad()

		self.navigationItem.rightBarButtonItem = UIBarButtonItem(
			title: "Add",
			style: .plain,
			target: self,
			action: #selector(self.didTapAddButton)
		)

		self.tableView.register(CarInfoCell.self, forCellReuseIdentifier: "CarInfoCell")

		self.storage.onReloadStorage = {
			DispatchQueue.main.async { [weak self] in
				self?.tableView.reloadData()
			}
		}
    }

	@objc private func didTapAddButton() {
		let newCar = Car(
			uuid: UUID().uuidString,
			year: "Undefined",
			vendor: "Undefined",
			model: "Undefined",
			bodyType: "Undefined"
		)
		self.storage.selectedCar = newCar
		self.storage.add(car: newCar)
		self.performSegue(withIdentifier: "showCarDetail", sender: self)
	}

// Tableview datasource methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.storage.storedCars.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "CarInfoCell", for: indexPath) as? CarInfoCell else { return UITableViewCell() }
		guard indexPath.row < self.storage.storedCars.count else { return cell }

		let car = self.storage.storedCars[indexPath.row]
		cell.textLabel?.text = String(format:"%@, %@ (%@)", car.vendor, car.model, car.year)
    
        return cell
    }

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)

		guard indexPath.row < self.storage.storedCars.count else { return }

		let car = self.storage.storedCars[indexPath.row]
		self.storage.selectedCar = car
		self.performSegue(withIdentifier: "showCarDetail", sender: self)
	}

	override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
		return .delete
	}

	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		guard indexPath.row < self.storage.storedCars.count else { return }

		let car = self.storage.storedCars[indexPath.row]
		self.storage.remove(car: car)
	}

 }
