import Foundation

protocol IStorage: AnyObject {

	var selectedCar: Car? { get set }
	var onReloadStorage: (() -> Void)? { get set }

	var storedCars: [Car] { get }

	func add(car: Car)
	func edit(car: Car)
	func remove(car: Car)

}

//final class CoreDataStorage: IStorage {
//	var selectedCar: Car?
//
//	var onReloadStorage: (() -> Void)?
//
//	var storedCars: [Car]
//
//	func add(car: Car) {
//
//	}
//
//	func edit(car: Car) {
//
//	}
//
//	func remove(car: Car) {
//
//	}
//
//}

final class UserDefaultsStorage: IStorage {

	static let shared: UserDefaultsStorage = UserDefaultsStorage(userDefaults: .standard)

	var selectedCar: Car?
	var onReloadStorage: (() -> Void)?

	private let userDefaults: UserDefaults
	private(set) var storedCars: [Car] = []

	init(userDefaults: UserDefaults) {
		self.userDefaults = userDefaults
		self.loadCars()

		// self.addDebugCars()
	}

	private func addDebugCars() {
		self.store(cars: [
			Car(uuid: UUID().uuidString, year: "1991", vendor: "Toyota", model: "Mark II", bodyType: "Sedan"),
			Car(uuid: UUID().uuidString, year: "1992", vendor: "Lexus", model: "RX350", bodyType: "SUV"),
			Car(uuid: UUID().uuidString, year: "2020", vendor: "Bugatti", model: "Chiron", bodyType: "Roadster"),
		])
	}

	func edit(car: Car) {
		if let index = self.storedCars.index(of: car) {
			self.storedCars.remove(at: index)
			self.storedCars.insert(car, at: index)
			self.store(cars: self.storedCars)
		}
	}

	func add(car: Car) {
		self.storedCars.append(car)
		self.store(cars: self.storedCars)
	}

	func remove(car: Car) {
		if let index = self.storedCars.index(of: car) {
			self.storedCars.remove(at: index)
			self.store(cars: self.storedCars)
			self.onReloadStorage?()
		}
	}

	private func store(cars: [Car]) {
		let encoder = JSONEncoder()
		if let encoded = try? encoder.encode(cars) {
			self.userDefaults.set(encoded, forKey: "storedCars")
		}

		self.onReloadStorage?()
	}

	private func loadCars() {
		if let savedPerson = self.userDefaults.object(forKey: "storedCars") as? Data {
			let decoder = JSONDecoder()
			if let loadedCars = try? decoder.decode([Car].self, from: savedPerson) {
				self.storedCars = loadedCars
			}
		}
	}

}
