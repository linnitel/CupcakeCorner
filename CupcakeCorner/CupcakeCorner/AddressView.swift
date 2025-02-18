//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Julia Martcenko on 18/02/2025.
//

import SwiftUI

struct AddressView: View {
	@Bindable var order: Order

    var body: some View {
		Form {
			Section {
				TextField("Name", text: $order.name)
				TextField("Street Address", text: $order.streetAddress)
				TextField("City", text: $order.city)
				TextField("Zip", text: $order.zip)
			}

			Section {
				NavigationLink("Check out") {
					CheckoutView(order: order)
				}
			}
			.disabled(order.hasValidAddress == false)
		}
		.navigationTitle("Delivery details")
		.navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
	AddressView(order: Order())
}
