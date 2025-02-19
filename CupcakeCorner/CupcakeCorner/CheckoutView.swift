//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Julia Martcenko on 18/02/2025.
//

import SwiftUI

struct CheckoutView: View {
	var order: Order

	@State private var confirmationMessage = ""
	@State private var alertMassage = ""
	@State private var showAlert = false
	@State private var activeAlert: ActiveAlert = .first

    var body: some View {
		ScrollView {
			VStack {
				AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { image in
						image
							.resizable()
							.scaledToFit()
				} placeholder: {
					ProgressView()
				}
				.frame(height: 233)

				Text("Your total is \(order.cost, format: .currency(code: "USD"))")
					.font(.title)

				Button("Place Order", action: {
					Task {
						await placeOrder()
					}
					})
					.padding()
			}
		}
		.navigationTitle("Check out")
		.navigationBarTitleDisplayMode(.inline)
		.scrollBounceBehavior(.basedOnSize)
		.alert(isPresented: $showAlert) {
			switch activeAlert {
				case .first:
					return Alert(title: Text("Thank you!"), message: Text(confirmationMessage))
				case .second:
					return Alert(title: Text("Network error"), message: Text(alertMassage))
			}
		}
    }

	func placeOrder() async {
		guard let encoded = try? JSONEncoder().encode(order) else {
			print("Failed to encode order")
			return
		}

		let url = URL(string: "https://reqres.in/api/cupcakes")!
		var request = URLRequest(url: url)
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.httpMethod = "POST"

		do {
			let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)

			let decodedQuantity = try JSONDecoder().decode(Order.self, from: data)
			confirmationMessage = "Your order for \(decodedQuantity.quantity)x \(Order.types[decodedQuantity.type].lowercased()) cupcakes is on the way. Thank you!"
			showAlert = true
			self.activeAlert = .first
		} catch {
			alertMassage = "Checkout failed: \(error.localizedDescription)"
			showAlert = true
			self.activeAlert = .second
		}
	}
}

enum ActiveAlert {
	case first, second
}

#Preview {
	CheckoutView(order: Order())
}
