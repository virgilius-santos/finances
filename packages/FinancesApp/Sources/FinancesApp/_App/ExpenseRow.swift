import SwiftUI

enum ExpenseRow {}

extension ExpenseRow {
    struct RowView: View {
        let viewModel: ViewModel
        var tapAction: () -> Void = {}
        var deleteAction: (ViewModel) -> Void = { _ in }
        
        var body: some View {
            CustomSwipeView(
                cornerRadius: 12,
                content: {
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
                    .frame(minWidth: 44, minHeight: 44)
                    .vSpacing()
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        tapAction()
                        print("ta[ ta[\(viewModel.id)")
                    }
                },
                actions: {
                    SwipeAction(tint: .red, icon: "trash", action: { })
                }
            )
            .background(Color.systemBackground)
            .clipShape(.rect(cornerRadius: 24))
            .shadow(color: .black.opacity(0.2), radius: 4, x: 2, y: 2)
            .padding(.horizontal, 16)
            .accessibilityElement(children: .combine)
        }
    }
}

extension ExpenseRow {
    struct ViewModel {
        var id = UUID()
        var title: String
        var category: Category
        var amount: Amount
    }
}

extension ExpenseRow.ViewModel {
    struct Category {
        var name: String
        var image: String
        var style: CategoryStyle
    }
}

#Preview("ExpenseRow.Row") {
        ScrollView(.vertical) {
            LazyVStack(spacing: 12) {
                ForEach(0...9, id: \.self) { _ in
                    ExpenseRow.RowView(viewModel: ExpenseRow.ViewModel(
                        title: "Versus Card",
                        category: .init(
                            name: "Mercado",
                            image: "cart.fill",
                            style: .market
                        ),
                        amount: .init(value: 234.88, style: .expense, code: "BRL")
                    ))
                }
            }
        }
//    }
}
