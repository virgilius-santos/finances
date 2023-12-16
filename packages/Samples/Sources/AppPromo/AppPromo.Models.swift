import Foundation
import SwiftData
import SwiftUI

extension AppPromo {
    enum Category: String, CaseIterable {
        case income = "Income"
        case expense = "Expense"
    }
    
    struct TintColor: Identifiable {
        let id = UUID()
        var color: String
        var value: Color
        
        init(color: String, value: Color) {
            self.color = color
            self.value = value
        }
        
        static func get(color: String) -> Self {
            tints.first(where: { $0.color == color }) ?? tints[0]
        }
        
        static var tints: [Self] = [
            .init(color: "Red", value: .red),
            .init(color: "Blue", value: .blue),
            .init(color: "Pink", value: .pink),
            .init(color: "Purple", value: .purple),
            .init(color: "Brown", value: .brown),
            .init(color: "Orange", value: .orange)
        ]
    }
    
    @Model
    class Transaction {
        var title: String
        var remarks: String
        var amount: Double
        var dateAdded: Date
        var category: String
        var tintColor: String
        
        init(title: String, remarks: String, amount: Double, dateAdded: Date, category: Category, tintColor: TintColor) {
            self.title = title
            self.remarks = remarks
            self.amount = amount
            self.dateAdded = dateAdded
            self.category = category.rawValue
            self.tintColor = tintColor.color
        }
    }
}

@MainActor
public let previewContainer: ModelContainer = {
    do {
        let container = try ModelContainer(
            for: AppPromo.Transaction.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        let modelContext = container.mainContext
        if try modelContext.fetch(FetchDescriptor<AppPromo.Transaction>()).isEmpty {
            AppPromo.Transaction.sample.forEach { container.mainContext.insert($0) }
        }
        return container
    } catch {
        fatalError("Failed to create container")
    }
}()

extension AppPromo.Transaction {
    static let sample: [AppPromo.Transaction] = {
        var transactions = [AppPromo.Transaction]()
        for i in 0...12 {
            transactions.append( .init(
                title: "Magic",
                remarks: "Apple",
                amount: Double.random(in: 0...2000),
                dateAdded: {
                    var d = Calendar.current.dateComponents([.year, .month, .day], from: .now)
                    d.month = Int.random(in: 1...12)
                    return Calendar.current.date(from: d) ?? .now
                }(),
                category: AppPromo.Category.allCases.randomElement() ?? .income,
                tintColor: AppPromo.TintColor.tints.randomElement() ?? AppPromo.TintColor.tints[0]
            )
            )
        }
        return transactions.sorted(by: { $1.dateAdded < $0.dateAdded })
    }()
}
