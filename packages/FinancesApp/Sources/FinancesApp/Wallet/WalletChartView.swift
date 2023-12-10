import SwiftUI
import Charts

struct WalletChartView: View {
    var viewModel: WalletChartViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Overview")
                    .font(.title3.bold())
                
                Spacer()
                
                Text("Last 4 Months")
                    .font(.caption)
                    .foregroundStyle(Color.gray)
            }
            
            Chart(viewModel.overview) { overview in
                ForEach(overview.values) { data in
                    BarMark(
                        x: .value("Month", data.month, unit: .month),
                        y: .value(overview.category.rawValue, data.amonut)
                    )
                }
                .foregroundStyle(by: .value("Type", overview.category.rawValue))
                .position(by: .value("Type", overview.category.rawValue))
            }
            .chartForegroundStyleScale(range: [Color.green.gradient, Color.red.gradient])
            .frame(height: 200)
            .padding(.top, 24)
        }
        .padding(.top, 16)
    }
}

final class WalletChartViewModel: ObservableObject {
    @Published var overview: [Overview]
    
    init(overview: Published<[Overview]>) {
        _overview = overview
    }
}
