import SwiftUI

extension AppPromo {
    struct SettingsView: View {
        @AppStorage("userName") var userName = ""
        @AppStorage("isAppLockEnabled") var isAppLockEnabled = false
        @AppStorage("lockWhenApppGoesBackground") var lockWhenApppGoesBackground = false
        
        var body: some View {
            NavigationStack {
                List {
                    Section("User Name") {
                        TextField("iJustine", text: $userName)
                    }
                    
                    Section("App Lock") {
                        Toggle("Enable App Lock", isOn: $isAppLockEnabled)
                        
                        if isAppLockEnabled {
                            Toggle("Lock When App Goes Background", isOn: $lockWhenApppGoesBackground)
                        }
                    }
                }
            }
        }
    }
}
