import SwiftUI
import SwiftUIComponents

struct CloudAppMainContentView: View {
    @State var text = ""
    @Binding var showMenu: Bool
    
    var body: some View {
        VStack {
            HStack {
                
                if !isMacOS {
                    IconButton(imageName: "line.horizontal.3", action: {
                        withAnimation {
                            showMenu.toggle()
                        }
                    })
                }
                
                Text("DashBoard")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.black)
                
                Spacer(minLength: 0)
                
                // Custom search bar
                if isMacOS {
                    CloudAppCustomSearchBarView(text: $text)
                        .frame(maxWidth: 300)
                }
            }
            .padding(isMacOS ? 16 : 0)
            
            if !isMacOS {
                CloudAppCustomSearchBarView(text: $text)
                    .padding(.bottom)
            }
            
            ZStack {
                if isMacOS {
                    ScrollView(.vertical) {
                        
                        CloudAppBodyContent()
                        
                    }
                    .scrollIndicators(.hidden)
                } else {
                    CloudAppBodyContent()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.grayApp)
            .clipShape(RoundedRectangle(cornerRadius: isMacOS ? 16 : 0, style: .continuous))
            .padding([.top, .horizontal], isMacOS ? 12 : 0)
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}
