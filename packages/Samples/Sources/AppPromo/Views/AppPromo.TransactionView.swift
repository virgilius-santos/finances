import SwiftUI

extension AppPromo {
    struct TransactionView: View {
        @Environment(\.dismiss) var dismiss
        @Environment(\.modelContext) var modelContext
        
        var editTransaction: Transaction?
        
        @State private var title = ""
        @State private var remarks = ""
        @State private var amount = Double.zero
        @State private var dateAdded = Date.now
        @State private var category = Category.expense
        @State private var tintColor = TintColor.tints.randomElement()!
        
        var body: some View {
            ScrollView(.vertical) {
                VStack(spacing: 16) {
                    Text("Preview")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .hSpacing(.leading)
                    
                    TransactionCardView(transaction: .init(
                        title: title.isEmpty ? "Title" : title,
                        remarks: remarks.isEmpty ? "Remarks" : remarks,
                        amount: amount,
                        dateAdded: dateAdded,
                        category: category,
                        tintColor: tintColor
                    ))
                    
                    CustomSection(title: "Title", hint: "Margic Keyboard", text: $title)
                    
                    CustomSection(title: "Remarks", hint: "Apple Products!", text: $remarks)
                    
                    VStack(spacing: 12) {
                        Text("Amount & Category")
                            .font(.caption)
                            .foregroundStyle(.gray)
                            .hSpacing(.leading)
                        
                        HStack(spacing: 16) {
                            TextField("0.0", value: $amount, formatter: NumberFormatter.twoFractionDigits)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(.background, in: .rect(cornerRadius: 12))
                                .frame(maxWidth: 130)
                                .keyboardType(.decimalPad)
                            
                            CategoryCheckBox(category: $category)
                        }
                    }
                    
                    VStack(spacing: 12) {
                        Text("Date")
                            .font(.caption)
                            .foregroundStyle(.gray)
                            .hSpacing(.leading)
                        
                        DatePicker("", selection: $dateAdded, displayedComponents: [.date])
                            .datePickerStyle(.graphical)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(.background, in: .rect(cornerRadius: 12))
                    }
                }
                .padding(16)
            }
            .navigationTitle("\(editTransaction == nil ? "Add" : "Edit") Transaction")
            .background(tintColor.value.opacity(0.16))
            .toolbar(content: {
                ToolbarItem {
                    Button("Save", action: save)
                }
            })
            .onAppear(perform: {
                if let editTransaction {
                    title = editTransaction.title
                    remarks = editTransaction.remarks
                    amount = editTransaction.amount
                    dateAdded = editTransaction.dateAdded
                    category = .init(rawValue: editTransaction.category) ?? .expense
                    tintColor = TintColor.get(color: editTransaction.tintColor)
                }
            })
        }
        
        func save() {
            if let editTransaction {
                editTransaction.title = title
                editTransaction.remarks = remarks
                editTransaction.amount = amount
                editTransaction.dateAdded = dateAdded
                editTransaction.category = category.rawValue
                editTransaction.tintColor = tintColor.color
            } else {
                let transaction = Transaction(
                    title: title,
                    remarks: remarks,
                    amount: amount,
                    dateAdded: dateAdded,
                    category: category,
                    tintColor: tintColor
                )
                modelContext.insert(transaction)
            }
            dismiss()
        }
    }
    
    struct CustomSection: View {
        var title: String
        var hint: String
        @Binding var text: String
        
        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .hSpacing(.leading)
                
                TextField(hint, text: $text)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(.background, in: .rect(cornerRadius: 12))
            }
        }
    }
    
    struct CategoryCheckBox: View {
        @Binding var category: Category
        
        var body: some View {
            HStack(spacing: 12) {
                ForEach(Category.allCases, id: \.rawValue) { category in
                    HStack(spacing: 4) {
                        ZStack {
                            Image(systemName: "circle")
                                .font(.title3)
                                .foregroundStyle(Color.appTint)
                            
                            if self.category == category {
                                Image(systemName: "circle.fill")
                                    .font(.caption)
                                    .foregroundStyle(Color.appTint)
                            }
                        }
                        
                        Text(category.rawValue)
                            .font(.caption)
                    }
                    .contentShape(.rect)
                    .onTapGesture {
                        self.category = category
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .hSpacing(.leading)
            .background(.background, in: .rect(cornerRadius: 8))
        }
    }
}
