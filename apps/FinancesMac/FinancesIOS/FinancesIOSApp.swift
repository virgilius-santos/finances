import SwiftUI
@testable import FinancesApp
import ExpenseTrackerKavsoft
import ExpenseTrackerDesignCode
import Wallet
import AppPromo

@main
struct FinancesIOSApp: App {
    var body: some Scene {
        WindowGroup {
            Content()
        }
    }
}

struct Content: View {
    enum ExibithionScene: String, CaseIterable {
        case menu
        case appPromo = "Expense tracker from Kavsoft"
        case cloudApp = "Cloud app from Kavsoft"
        case designCode = "Expense tracker from DesignCode"
        case expenseTracker = "Expense tracker"
        case wallet = "Wallet app from Kavsoft"
        case expenseList = "In develpment"
    }
    
    @State private var scene: ExibithionScene = .menu
    
    var body: some View {
        if scene == .menu {
            makeScene()
        } else {
            ZStack {
                makeScene()
                
                VStack(alignment: .trailing) {
                    HStack(alignment: .top) {
                        Spacer()
                        IconButton(imageName: "xmark.circle.fill", action: {
                            scene = .menu
                        })
                    }
                    .padding(16)
                    
                    Spacer()
                }
                .ignoresSafeArea(.all)
            }
        }
    }
    
    var scenes: [ExibithionScene] = {
        ExibithionScene.allCases
            .filter({ $0 != .menu })
            .sorted(by: { $0.rawValue < $1.rawValue})
    }()
    
    @ViewBuilder
    func makeScene() -> some View {
        switch scene {
        case .cloudApp:
            CloudAppView()
        case .expenseTracker:
            ExpenseTracker()
        case .wallet:
            WalletView()
        case .appPromo:
            AppPromo()
        case .menu:
            List {
                ForEach(scenes, id: \.rawValue) { scene in
                    Text(scene.rawValue)
                        .containerShape(.rect)
                        .onTapGesture {
                            self.scene = scene
                        }
                }
            }
        case .designCode:
            DesignCodeApp()
        case .expenseList:
            ExpenseList()
        }
    }
}

#Preview("light") {
    Content()
}
