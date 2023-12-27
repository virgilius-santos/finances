import Foundation
import FoundationUtils

public final class NumberPadViewModel: ObservableObject {
    @Published var accountManager: AccountManager = .init()
    @Published var numberManager: NumberManager = .init()
    
    var selected: AccountManager.Account {
        accountManager.selected
    }
    
    var value: String {
        numberManager.value
    }
    
    var positive: Bool {
        numberManager.positive
    }
    
    public init() {}
    
    func updateAccount() {
        accountManager.updateAccount()
    }
    
    func update(digit: Int) {
        numberManager.update(digit: digit)
    }
    
    func activeSeparator() {
        numberManager.activeSeparator()
    }
    
    func delete() {
        numberManager.delete()
    }
    
    func changeSignal() {
        numberManager.changeSignal()
    }
}

extension NumberPadViewModel {
    struct NumberManager {
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
        
        fileprivate var numbers = [Int]()
        fileprivate var fractionals = [Int]()
        fileprivate var separator = false
        fileprivate var positive = true
        
        mutating func update(digit: Int) {
            guard separator else {
                numbers.append(digit)
                return
            }
            guard fractionals.count < 2 else {
                return
            }
            fractionals.append(digit)
        }
        
        mutating func activeSeparator() {
            separator = true
        }
        
        mutating func delete() {
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
        
        mutating func changeSignal() {
            positive.toggle()
        }
    }
}

extension NumberPadViewModel {
    struct AccountManager {
        struct Account {
            var name: String {
                guard let child else {
                    return major.name
                }
                return "\(major.name) - \(child.name)"
            }
            
            var balance: Decimal {
                child?.balance ?? major.balance
            }
            
            var positive: Bool {
                child?.positive ?? major.positive
            }
            
            let major: AccountCard
            let child: AccountCard?
        }
        
        var selected: Account {
            .init(
                major: selectedAccount,
                child: selectedChildAccount
            )
        }
        
        mutating func updateAccount() {
            childIndex = 0
            let isLastIndex = index + 1 == accounts.count
            index = isLastIndex ? 0 : index + 1
        }
        
        mutating func updateChildAccount() {
            let isLastIndex = childIndex + 1 == childAccountList.count
            childIndex = isLastIndex ? 0 : childIndex + 1
        }
        
        private let accounts: [AccountCard]
        private var index: Int = 0
        private var selectedAccount: AccountCard { accounts[index] }
        
        private let childAccountDict: [UUID: [AccountCard]]
        private var childAccountList: [AccountCard] {
            childAccountDict[selectedAccount.id] ?? []
        }
        private var childIndex: Int = 0
        private var selectedChildAccount: AccountCard? {
            childAccountList[safe: childIndex]
        }
        
        init() {
            let accounts: [AccountCard] = [
                .init(name: "Nubank", color: .white, textColor: .purple, balance: 200),
                .init(name: "Itau", color: .white, textColor: .red, balance: -400),
                .init(name: "Inter", color: .white, textColor: .orange, balance: 234.12)
            ]
            let childAccounts: [UUID: [AccountCard]] = [
                accounts[0].id: [
                    .init(name: "debit", color: .white, textColor: .purple, balance: 200),
                    .init(name: "credit", color: .white, textColor: .purple, balance: -900),
                ],
                accounts[2].id: [
                    .init(name: "debit", color: .white, textColor: .orange, balance: 123),
                    .init(name: "credit", color: .white, textColor: .orange, balance: -45.5),
                ]
            ]
            self.accounts = accounts
            self.childAccountDict = childAccounts
        }
        
    }
}
