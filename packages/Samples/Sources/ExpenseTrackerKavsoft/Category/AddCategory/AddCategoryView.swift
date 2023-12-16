import SwiftUI

struct AddCategoryView: View {
    @Environment(\.dismiss) var dismiss
    @State private var categoryName = ""
    
    var action: (String) -> Void
    
    var body: some View {
        NavigationStack {
            List {
                Section("Title") {
                    TextField("General", text: $categoryName)
                }
            }
            .navigationTitle("Add Category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .tint(.red)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") {
                        dismiss()
                        action(categoryName)
                    }
                    .disabled(categoryName.isEmpty)
                }
            }
        }
        .presentationDetents([.medium])
        .presentationCornerRadius(20)
    }
}
