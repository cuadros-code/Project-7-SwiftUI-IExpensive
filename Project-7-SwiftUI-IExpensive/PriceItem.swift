//
//  PriceItem.swift
//  Project-7-SwiftUI-IExpensive
//
//  Created by Kevin Cuadros on 7/11/24.
//

import SwiftUI

struct PriceItem: View {
    var price: Double
    var currencyPreference = Locale.current.currency?.identifier ?? "USD"
    
    var body: some View {
        Text(price, format: .currency(code: currencyPreference))
            .fontWeight(.bold)
            .foregroundStyle(
                price < 50000 ? .green : price < 100000 ? .blue : .purple
            )
    }
}
#Preview {
    PriceItem(price: 3444.4, currencyPreference: "COP")
}
