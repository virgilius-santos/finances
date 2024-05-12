import SwiftUI

extension AppPromo {
    struct CardView: View {
        let income: Double
        let expense: Double
        
        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.background)
                
                VStack(spacing: 0) {
                    HStack(spacing: 12) {
                        Text("\((expense - income).currencyString)")
                            .font(.title.bold())
                            .foregroundStyle(Color.primary)
                        
                        Image(systemName: expense > income ? "chart.line.downtrend.xyaxis" : "chart.line.uptrend.xyaxis")
                            .font(.title3)
                            .foregroundStyle(expense > income ? .red : .green)
                    }
                    .padding(.bottom, 24)
                    
                    HStack(spacing: 0) {
                        CategoryIndicator(image: "arrow.down", tint: .green, category: .income, value: income)
                        
                        Spacer(minLength: 12)
                        
                        CategoryIndicator(image: "arrow.up", tint: .red, category: .expense, value: expense)
                    }
                }
                .padding([.horizontal, .bottom], 24)
                .padding(.top, 16)
            }
        }
        
        func CategoryIndicator(image: String, tint: Color, category: Category, value: Double) -> some View {
            HStack(spacing: 12) {
                Image(systemName: image)
                    .font(.callout.bold())
                    .foregroundStyle(tint)
                    .frame(width: 36, height: 36)
                    .background {
                        Circle()
                            .fill(tint.opacity(0.24).gradient)
                    }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(category.rawValue)
                        .font(.caption2)
                        .foregroundStyle(.gray)
                    
                    Text(value.shortCurrencyString)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.primary)
                }
            }
        }
    }
}
