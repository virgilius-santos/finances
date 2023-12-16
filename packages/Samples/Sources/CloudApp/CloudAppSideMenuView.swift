import SwiftUI

struct CloudAppSideMenuView: View {
    @Binding var currentTab: String
    @Namespace var animation
    var body: some View {
        VStack {
            HStack {
                Text("Files")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.black)
                // letter spacing
                    .kerning(1.6)
                
                Text("Go")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.white)
                // letter spacing
                    .kerning(1.6)
                    .padding(8)
                    .background(Color.blueApp)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .padding(10)
            
            Divider()
                .background(Color.gray.opacity(0.4))
                .padding(.bottom)
            
            HStack(spacing: 12) {
                Image.pic
                    .clipShape(Circle())
                
                Text("Hi, iJustine")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.black)
            }
            
            VStack(spacing: 16) {
                CloudAppTabButton(
                    image: "house.fill",
                    title: "Home",
                    animation: animation,
                    currentTab: $currentTab
                )
                CloudAppTabButton(
                    image: "folder.fill.badge.person.crop",
                    title: "Shared Files",
                    animation: animation,
                    currentTab: $currentTab
                )
                CloudAppTabButton(
                    image: "star",
                    title: "Starred Files",
                    animation: animation,
                    currentTab: $currentTab
                )
                CloudAppTabButton(
                    image: "waveform.path.ecg.rectangle.fill",
                    title: "Statistics",
                    animation: animation,
                    currentTab: $currentTab
                )
                
                Spacer()
                
                CloudAppTabButton(
                    image: "gearshape",
                    title: "Settings",
                    animation: animation,
                    currentTab: $currentTab
                )
                CloudAppTabButton(
                    image: "rectangle.righthalf.inset.fill.arrow.right",
                    title: "Log out",
                    animation: animation,
                    currentTab: .constant("")
                )
            }
            .padding(.leading, 20)
            .offset(x: 16)
            .padding(.top, 20)
        }
        // to avoid spacers
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

struct CloudAppTabButton: View {
    var image: String
    var title: String
    var animation: Namespace.ID
    @Binding var currentTab: String
    
    var body: some View {
        Button(
            action: {
                withAnimation {
                    currentTab = title
                }
            },
            label: {
                HStack(spacing: 16) {
                    Image(systemName: image)
                        .font(.title2)
                        .foregroundStyle(currentTab == title ? Color.blueApp : Color.gray.opacity(0.8))
                    
                    Text(title)
                        .foregroundStyle(Color.black.opacity(0.8))
                }
                .padding(.vertical, 12)
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    ZStack {
                        if currentTab == title {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                                .matchedGeometryEffect(id: "TAB", in: animation)
                        } else {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.clear)
                        }
                    }
                )
                .contentShape(Rectangle())
            }
        )
    }
}
