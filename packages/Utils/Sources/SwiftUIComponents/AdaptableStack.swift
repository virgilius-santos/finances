import SwiftUI

public struct AdaptableStack<Content: View, MenuView: View, SideView: View>:View {
    var content: Content
    var menuView: MenuView
    var sideView: SideView
    
    @Binding var showMenu: Bool
    
    public var body: some View {
        ZStack {
            #if os(iOS)
            
            ScrollView(.vertical) {
                VStack {
                    content
                    
                    sideView
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
            }
            .scrollIndicators(.hidden)
            .background(Color.grayApp.ignoresSafeArea())
            .overlay {
                menuView
                    .clipped()
                    .frame(width: mainRect.width / 1.8)
                    .background(Color.grayApp.ignoresSafeArea())
                    .offset(x: showMenu ? 0 : mainRect.width * -1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        Color.black
                            .opacity(showMenu ? 0.35 : 0)
                            .ignoresSafeArea()
                            .onTapGesture {
                                withAnimation {
                                    showMenu.toggle()
                                }
                            }
                    )
            }
            
            #else
            HStack {
                menuView
                // max width
                    .frame(width: 210)
                    .background(Color.grayApp.ignoresSafeArea())
                
                content
                
                sideView
            }
            .frame(width: mainRect.width / 1.3, height: mainRect.height - 100, alignment: .leading)
            .background(Color.white.ignoresSafeArea())
            .buttonStyle(PlainButtonStyle())
            #endif
        }
        .preferredColorScheme(.light)
    }
    
    public init(
        showMenu: Binding<Bool>,
        @ViewBuilder content: () -> Content,
        @ViewBuilder menuView: () -> MenuView,
        @ViewBuilder sideView: () -> SideView
    ) {
        self.content = content()
        self.menuView = menuView()
        self.sideView = sideView()
        _showMenu = showMenu
    }
}
