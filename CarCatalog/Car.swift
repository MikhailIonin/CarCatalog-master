import Foundation

struct Car: Codable, Equatable {

    static func == (lhs: Self, rhs: Self) -> Bool { return lhs.uuid == rhs.uuid }

	let uuid: String
	let year: String
	let vendor: String
	let model: String
	let bodyType: String

    
}
