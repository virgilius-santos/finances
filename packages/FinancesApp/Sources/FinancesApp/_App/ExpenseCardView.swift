import SwiftUI

enum ExpenseRow {}

extension ExpenseRow {
    struct RowView: View {
        let viewModel: ViewModel
        var tapAction: () -> Void = {}
        var deleteAction: (ViewModel) -> Void = { _ in }
        
        var body: some View {
            DynamicStack(
                leadingContent: {
                    HStack(spacing: 12) {
                        Image(systemName: viewModel.category.image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 16, height: 16)
                            .padding(8)
                            .clipShape(Circle())
                            .foregroundStyle(viewModel.category.style.color)
                            .padding(.vertical, 4)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(viewModel.title)
                                .fontWeight(.bold)
                            
                            Text(viewModel.category.name)
                                .font(.caption)
                                .foregroundStyle(Color.primary)
                        }
                        .padding(.vertical, 8)
                    }
                },
                trailingContent: {
                    AmountLabelView(amount: viewModel.amount)
                        .padding(.vertical, 8)
                }
            )
            .contentShape(Rectangle())
            .onTapGesture {
                tapAction()
                print("ta[ ta[")
            }
            .cardBackground()
            .padding(.horizontal, 16)
            .accessibilityElement(children: .combine)
        }
    }
}

extension ExpenseRow {
    struct ViewModel {
        var title: String = "Versus Card"
        var category: Category = .init(name: "Mercado")
        var amount: Amount = .init(value: 234.88, style: .expense, code: "BRL")
    }
}

extension ExpenseRow.ViewModel {
    struct Category {
        var name: String = "Mercado"
        var image: String = "cart.fill"
        var style: CategoryStyle = .market
    }
}

#Preview("ExpenseRow.Row") {
//    Group {
//        List {
        ScrollView(.vertical) {
            LazyVStack(spacing: 12) {
                ForEach(0...9, id: \.self) { _ in
                    ExpenseRow.RowView(viewModel: ExpenseRow.ViewModel())
                }
            }
        }
//        }
//        .listStyle(.grouped)
//    }
}
