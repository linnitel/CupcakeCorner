//
//  Order.swift
//  CupcakeCorner
//
//  Created by Julia Martcenko on 18/02/2025.
//

import Foundation

struct Customer: Codable {
	var name: String = ""
	var streetAddress: String = ""
	var city: String = ""
	var zip: String = ""
}

@Observable
class Order: Codable {
	enum CodingKeys: String, CodingKey {
		case _type = "type"
		case _quantity = "quantity"
		case _specialRequestEnabled = "specialRequestEnabled"
		case _extraFrosting = "extraFrosting"
		case _addSprinkles = "addSprinkles"
		case _customer = "customer"
	}

	static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
	private let saveKey = "SavedData"

	var type = 0
	var quantity = 3

	var specialRequestEnabled = false {
		didSet {
			if specialRequestEnabled == false {
				extraFrosting = false
				addSprinkles = false
			}
		}
	}
	var extraFrosting = false
	var addSprinkles = false

	var customer: Customer

	init(type: Int = 0, quantity: Int = 3, specialRequestEnabled: Bool = false, extraFrosting: Bool = false, addSprinkles: Bool = false) {
		self.type = type
		self.quantity = quantity
		self.specialRequestEnabled = specialRequestEnabled
		self.extraFrosting = extraFrosting
		self.addSprinkles = addSprinkles

		if let data = UserDefaults.standard.data(forKey: saveKey) {
			if let decoded = try? JSONDecoder().decode(Customer.self, from: data) {
				customer = decoded
				return
			}
		}

		customer = Customer()
	}

	var hasValidAddress: Bool {
		if customer.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || customer.streetAddress.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || customer.city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || customer.zip.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
			return false
		}

		return true
	}

	func save() {
		if let encoded = try? JSONEncoder().encode(customer) {
			UserDefaults.standard.set(encoded, forKey: saveKey)
		}
	}

	var cost: Decimal {
		// $2 per cake
		var cost = Decimal(quantity) * 2

		// complicated cakes cost more
		cost += Decimal(type) / 2

		// $1/cake for extra frosting
		if extraFrosting {
			cost += Decimal(quantity)
		}

		// $0.50/cake for sprinkles
		if addSprinkles {
			cost += Decimal(quantity) / 2
		}

		return cost
	}
}
