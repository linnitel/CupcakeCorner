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
				TextField("Name", text: $order.customer.name)
				TextField("Street Address", text: $order.customer.streetAddress)
				TextField("City", text: $order.customer.city)
				TextField("Zip", text: $order.customer.zip)
			}

			Section {
				NavigationLink(destination: {
					CheckoutView(order: order)
				}, label: {
					Text("Check out")
				})
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
