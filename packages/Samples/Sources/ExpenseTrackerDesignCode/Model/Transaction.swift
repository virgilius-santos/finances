import Foundation
import SwiftUIFontIcon
import Collections
import SwiftUI

typealias TransactionGroup = OrderedDictionary<String, [Transaction]>

struct Transaction: Identifiable {
    let id: UUID = .init()
    var merchant = "Apple"
    var category = "Software"
    var date = Date()
    var amount = 2599.98
    var type = TransactionType.credit
    var categoryId: Int = Category.all.randomElement()?.id ?? 0
    
    var icon: FontAwesomeCode {
        if let category = Category.all.first(where: { $0.id == categoryId }) {
            return category.icon
        }
        
        return .question
    }
    
    var textColor: Color {
        switch type {
        case .debit:
            return .primary
        case .credit:
            return .text
        }
    }
    
    var signedAmount: Double {
        switch type {
        case .debit:
            return amount * -1
        case .credit:
            return amount
        }
    }
    
    var month: String {
        date.formatted(.dateTime.year().month(.wide))
    }
}

enum TransactionType {
    case debit, credit
}

struct Category: Identifiable {
    let id: Int
    let name: String
    let icon: FontAwesomeCode
    var mainCategoryId: Int?
    
    var subcategories: [Category]? {
        Category.subCategories.filter { $0.mainCategoryId == id }
    }
    }
