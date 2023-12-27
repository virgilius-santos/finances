import SwiftUI
import SwiftUIComponents

public enum NumberPadAction {
    case number(Int)
    case delete
    case separator(String)
}

public final class NumberPadViewModel: ObservableObject {
    let accounts: [AccountCard]
    @Published var selectedIndex: Int = 0
    
    var selectedAccount: AccountCard {
        accounts[selectedIndex]
    }
    
    var isLastIndex: Bool {
        selectedIndex + 1 == accounts.count
    }
    
    var isValueEmpty: Bool {
        numbers.isEmpty && fractionals.isEmpty
    }
    
    var adjustedFractionals: [Int] {
        switch fractionals.count {
        case 1:
            return [0] + fractionals
        case 2:
            return fractionals
        default:
            return [0,0]
        }
    }
    
    var signal: String {
        guard !numbers.isEmpty || !fractionals.isEmpty else {
            return ""
        }
        return " \(positive ? "" : "-")"
    }
    
    var value: String {
        var result = "R$ "
        guard !isValueEmpty else {
            result += separator ? "0,00" : "0"
            return result
        }
        
        var value = ""
        let number = numbers.isEmpty ? "0" : numbers.map(String.init).joined()
        value += number
        guard separator else {
            return result + signal + value
        }
        value += ","
        value += adjustedFractionals.map(String.init).joined()
        return result + signal + value
    }
    
    @Published var numbers = [Int]()
    @Published var fractionals = [Int]()
    @Published var separator = false
    @Published var positive = true
    
    init() {
        accounts = [
            .init(name: "Nubank", color: .white, textColor: .purple, balance: 200),
            .init(name: "Itau", color: .white, textColor: .red, balance: -400),
            .init(name: "Inter", color: .white, textColor: .orange, balance: 234.12)
        ]
    }
    
    func updateAccount() {
        selectedIndex = isLastIndex ? 0 : selectedIndex + 1
    }
    
    func update(digit: Int) {
        guard separator else {
            numbers.append(digit)
            return
        }
        guard fractionals.count < 2 else {
            return
        }
        fractionals.append(digit)
    }
    
    func activeSeparator() {
        separator = true
    }
    
    func delete() {
        guard separator else {
            numbers.removeLast()
            return
        }
        if fractionals.isEmpty {
            separator = false
            return
        }
        fractionals.removeLast()
    }
    
    func changeSignal() {
        positive.toggle()
    }
}

public struct NumberPadView: View {
    @ObservedObject var viewModel = NumberPadViewModel()
    @State private var digits: [NumberPadAction] = []
    
    let actions: [NumberPadAction] = [
        .number(1), .number(2), .number(3),
        .number(4), .number(5), .number(6),
        .number(7), .number(8), .number(9),
        .separator(","), .number(0), .delete
    ]
    
    public var body: some View {
        GeometryReader { proxy in
            VStack {
                ZStack {
                    Rectangle()
                        .fill(.orange)
                        .ignoresSafeArea()
                    
                    VStack {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Conta")
                                Text(viewModel.selectedAccount.name)
                                    .font(.title2.bold())
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing) {
                                Text("Saldo")
                                Text(viewModel.selectedAccount.balance, format: .currency(code: "BRL"))
                                    .font(.title2.bold())
                                    .foregroundStyle(viewModel.selectedAccount.positive ? Color.blue : .red)
                            }
                        }
                        Divider()
                        
                        Text(viewModel.value)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(viewModel.positive ? Color.blue : .red)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    
                }
                Spacer(minLength: 0)
                
                ZStack(alignment: .top) {
                    VStack {
                        Grid {
                            GridRow {
                                Button(
                                    action: { viewModel.updateAccount() },
                                    label: {
                                        AccountCardView(card: viewModel.selectedAccount)
                                    }
                                )
                                .padding(.bottom, 8)
                                
                                Color.clear
                                    .gridCellUnsizedAxes([.horizontal, .vertical])
                                
                                Button(
                                    action: { viewModel.changeSignal() },
                                    label: {
                                        Image(systemName: "plusminus")
                                            .font(.title.bold())
                                            .tint(Color.white)
                                            .frame(minWidth: 44, minHeight: 44)
                                    }
                                )
                            }
                            GridRow {
                                ForEach(0..<3) { index in
                                    ButtonFor(index: index)
                                }
                            }
                            GridRow {
                                ForEach(3..<6) { index in
                                    ButtonFor(index: index)
                                }
                            }
                            GridRow {
                                ForEach(6..<9) { index in
                                    ButtonFor(index: index)
                                }
                            }
                            GridRow {
                                ForEach(9..<12) { index in
                                    ButtonFor(index: index)
                                }
                            }
                        }
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .padding()
                    }
                }
                .background(.black)
            }
            .environment(\.colorScheme, .dark)
        }
    }
    
    public init() {}
    
    @ViewBuilder
    func ButtonFor(index: Int) -> some View {
        switch actions[index] {
        case .delete:
            ButtonPad(
                action: { viewModel.delete() },
                label: { Image(systemName: "delete.backward") }
            )
            .border(.gray)
        case .separator(let sep):
            ButtonPad(
                action: { viewModel.activeSeparator() },
                label: { Text(sep) }
            )
            .border(.gray)
        case .number(let number):
            ButtonPad(
                action: { viewModel.update(digit: number) },
                label: { Text("\(number)") }
            )
            .border(.gray)
        }
    }
    
    @ViewBuilder
    func ButtonPad(action: @escaping () -> Void, @ViewBuilder label: () -> some View) -> some View {
        Button(action: action, label: {
            label()
                .font(.title)
                .frame(minWidth: 44, minHeight: 44)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .containerShape(.rect)
        })
        .tint(.white)
    }
}


struct AccountCard: Identifiable, Equatable, Hashable {
    var id: UUID = .init()
    var name: String
    var color: Color
    var textColor: Color
    var balance: Decimal
    var positive: Bool { balance >= .zero }
}

struct AccountCardView: View {
    var card: AccountCard
    
    var body: some View {
        Text(card.name)
            .fontWeight(.semibold)
            .foregroundStyle(card.textColor)
            .padding(16)
            .background(card.color)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}



#Preview {
    NumberPadView()
}
