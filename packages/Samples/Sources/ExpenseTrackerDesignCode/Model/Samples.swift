import Foundation
import SwiftUIComponents

extension Category {
    static let autoAndTransport = Self(id: 1, name: "Auto & Transport", icon: .car_alt)
    static let billsAndUtilities = Self(id: 2, name: "Bills & Utilities", icon: .file_invoice_dollar)
    static let entertainment = Self(id: 3, name: "Entertainment", icon: .film)
    static let feesAndCharges = Self(id: 4, name: "Fees & Charges", icon: .hand_holding_usd)
    static let foodAndDining = Self(id: 5, name: "Food & Dining", icon: .hamburger)
    static let home = Self(id: 6, name: "Home", icon: .home)
    static let income = Self(id: 7, name: "Income", icon: .dollar_sign)
    static let shopping = Self(id: 8, name: "Shopping", icon: .shopping_cart)
    static let transfer = Self(id: 9, name: "Transfer", icon: .exchange_alt)
    
    static let publicTransportation = Self(id: 101, name: "Public Transportation", icon: .bus, mainCategoryId: 1)
    static let taxi = Self(id: 102, name: "Taxi", icon: .taxi, mainCategoryId: 1)
    static let mobilePhone = Self(id: 201, name: "Mobile Phone", icon: .mobile_alt, mainCategoryId: 2)
    static let moviesAndDVDs = Self(id: 301, name: "Movies & DVDs", icon: .film, mainCategoryId: 3)
    static let bankFee = Self(id: 401, name: "Bank Fee", icon: .hand_holding_usd, mainCategoryId: 4)
    static let financeCharge = Self(id: 402, name: "Finance Charge", icon: .hand_holding_usd, mainCategoryId: 4)
    static let groceries = Self(id: 501, name: "Groceries", icon: .shopping_basket, mainCategoryId: 5)
    static let restaurants = Self(id: 502, name: "Restaurants", icon: .utensils, mainCategoryId: 5)
    static let rent = Self(id: 601, name: "Rent", icon: .house_user, mainCategoryId: 6)
    static let homeSupplies = Self(id: 602, name: "Home Supplies", icon: .lightbulb, mainCategoryId: 6)
    static let paycheque = Self(id: 701, name: "Paycheque", icon: .dollar_sign, mainCategoryId: 7)
    static let software = Self(id: 801, name: "Software", icon: .icons, mainCategoryId: 8)
    static let creditCardPayment = Self(id: 901, name: "Credit Card Payment", icon: .exchange_alt, mainCategoryId: 9)
}

extension Category {
    static let categories: [Category] = [
        .autoAndTransport,
        .billsAndUtilities,
        .entertainment,
        .feesAndCharges,
        .foodAndDining,
        .home,
        .income,
        .shopping,
        .transfer
    ]
    
    static let subCategories: [Category] = [
        .publicTransportation,
        .taxi,
        .mobilePhone,
        .moviesAndDVDs,
        .bankFee,
        .financeCharge,
        .groceries,
        .restaurants,
        .rent,
        .homeSupplies,
        .paycheque,
        .software,
        .creditCardPayment
    ]
    
    static let all: [Category] = categories + subCategories
}

extension Transaction {
    static let transactions: [Transaction] = {
        var transactions = [Transaction]()
        for i in 0...34 {
            transactions.append( .init(
                date: {
                    var d = Calendar.current.dateComponents([.year, .month, .day], from: .now)
                    d.month = Int.random(in: 1...12)
                    return Calendar.current.date(from: d) ?? .now
                }(),
                amount: Double.random(in: 0...20000),
                type: Bool.random() ? .debit : .credit)
            )
        }
        return transactions.sorted(by: { $1.date < $0.date })
    }()
}
