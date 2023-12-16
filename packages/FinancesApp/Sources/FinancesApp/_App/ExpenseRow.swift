import SwiftUI
import SwiftUIComponents

struct ExpenseRow: View {
    let viewModel: ViewModel
    var isSwipeEnabled = false
    var tapAction: () -> Void = {}
    var deleteAction: () -> Void = {}
    
    var body: some View {
        CardView(
            viewModel: viewModel,
            isSwipeEnabled: isSwipeEnabled,
            tapAction: tapAction,
            deleteAction: deleteAction
        )
    }
}

extension ExpenseRow {
    struct CardView: View {
        let viewModel: ViewModel
        var isSwipeEnabled = false
        var tapAction: () -> Void = {}
        var deleteAction: () -> Void = {}
        
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
                    .contentShape(.rect)
                    .onTapGesture { tapAction() }
                    .vSpacing()
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                },
                actions: {
                    SwipeAction(
                        tint: .red,
                        icon: "trash",
                        isEnabled: isSwipeEnabled,
                        action: { deleteAction() }
                    )
                }
            )
            .background(Color.systemBackground)
            .clipShape(.rect(cornerRadius: 24))
            .shadow(color: .black.opacity(0.2), radius: 4, x: 2, y: 2)
            .accessibilityElement(children: .combine)
        }
    }
}

extension ExpenseRow {
    struct ViewModel: Equatable, Identifiable {
        var id = UUID()
        var title: String
        var category: Category
        var amount: Amount
    }
}

extension ExpenseRow {
    struct Category: Equatable, Hashable, Identifiable {
        static let undefined = Self.init(
            name: "categoria",
            image: "bag",
            style: .init(color: .blueApp)
        )
        var id = UUID()
        var name: String
        var image: String
        var style: CategoryStyle
    }
}
