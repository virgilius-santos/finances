import SwiftUI

extension AppPromo.IntroScreen {
    struct Home: View {
        @AppStorage("isFirstTime") var isFirstTime = true
        
        var body: some View {
            VStack(spacing: 16) {
                Text("What's New in the Expense Tracker")
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)
                    .padding(.top, 64)
                    .padding(.bottom, 36)
                
                VStack(alignment: .leading, spacing: 24) {
                    PointView(
                        symbol: "dollarsign",
                        title: "Transactions",
                        subtitle: "Keep track of your earnings and expenses."
                    )
                    PointView(
                        symbol: "chart.bar.fill",
                        title: "Virtual Charts",
                        subtitle: "View your transactions using eye-catching graphic representations."
                    )
                    PointView(
                        symbol: "magnifyingglass",
                        title: "Advance Filters",
                        subtitle: "Find the expenses you want by advance search and filtering."
                    )
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                
                Spacer(minLength: 12)
                
                Button(action: { isFirstTime = false }, label: {
                    Text("Continue")
                        .fontWeight(.bold)
                        .foregroundStyle(Color.white)
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .padding(.vertical, 16)
                        .background(Color.appTint, in: .rect(cornerRadius: 12))
                        .contentShape(.rect)
                    
                })
            }
            .padding(16)
        }
    }
    
    struct PointView: View {
        let symbol: String
        let title: String
        let subtitle: String
        
        var body: some View {
            HStack(spacing: 20) {
                Image(systemName: symbol)
                    .font(.largeTitle)
                    .foregroundStyle(Color.appTint.gradient)
                    .frame(width: 44)
                
                
                VStack(alignment: .leading, spacing: 24) {
                    Text(title)
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Text(subtitle)
                        .foregroundStyle(Color.gray)
                }
                
                
            }
        }
    }
}
