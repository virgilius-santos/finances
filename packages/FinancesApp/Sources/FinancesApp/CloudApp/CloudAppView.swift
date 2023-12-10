import SwiftUI

public extension WindowGroup where Content == CloudAppView {
    static var cloudApp: some Scene {
        #if os(macOS)
        WindowGroup(content: { CloudAppView() })
            .windowsStyle(HiddenTitleBarWindowStyle())
        #else
        WindowGroup(content: { CloudAppView() })
        #endif
    }
}

public struct CloudAppView: View {
    public var body: some View {
        CloudAppHome()
    }
    
    public init() {}
}

struct CloudAppHome: View {
    @State private var currentTab = "Home"
    @State private var showMenu = false
    
    var body: some View {
        AdaptableStack(
            showMenu: $showMenu,
            content: { CloudAppMainContentView(showMenu: $showMenu) },
            menuView: { CloudAppSideMenuView(currentTab: $currentTab) },
            sideView: { CloudAppSideView() }
        )
    }
}

struct CloudAppSideView: View {
    var body: some View {
        VStack(alignment: isMacOS ? .leading : .center) {
            
            Text("Storage")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(Color.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical)
            
            
            // Storage space
            VStack {
                ZStack {
                    
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 24)
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(Color.blueApp, style: StrokeStyle(lineWidth: 24, lineCap: .round, lineJoin: .round))
                        .rotationEffect(.init(degrees: -90))
                    
                    VStack {
                        Text("70%")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.black)
                        
                        Text("Used")
                            .fontWeight(.bold)
                            .foregroundStyle(Color.black)
                    }
                }
                .frame(width: 130, height: 170)
                
                HStack(spacing: 16) {
                    VStack(alignment: .center, spacing: 8) {
                        Text("Total Space")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.gray)
                        
                        Text("256 GB")
                            .fontWeight(.bold)
                            .foregroundStyle(Color.black)
                    }
                    
                    VStack(alignment: .center, spacing: 8) {
                        Text("Used Space")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.gray)
                        
                        Text("128 GB")
                            .fontWeight(.bold)
                            .foregroundStyle(Color.black)
                    }
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(color: .black.opacity(0.05), radius: 8, x: 5, y: 5)
        }
        .frame(width: isMacOS ? 200 : nil)
        .frame(maxHeight: .infinity, alignment: .top)
        .background(Color.grayApp.ignoresSafeArea())
    }
}

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

struct CloudAppCustomSearchBarView: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            TextField("Search", text: $text)
                .textFieldStyle(PlainTextFieldStyle())
            
            Button(action: {}, label: {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(Color.white)
                    .padding(8)
                    .background(Color.blueApp)
            })
        }
        .padding(.leading)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)
    }
}

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

struct CloudAppBodyContent: View {
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack(spacing: 16) {
                    CloudAppStorage(
                        image: Image.dropbox,
                        title: "Dropbox",
                        capacity: "143 GB/ 150 GB",
                        percentage: 0.6)
                    
                    CloudAppStorage(
                        image: Image.drive,
                        title: "Google Drive",
                        capacity: "30 GB/ 120 GB",
                        percentage: 0.25)
                    
                    CloudAppStorage(
                        image: Image.icloud,
                        title: "iCloud",
                        capacity: "216 GB/ 240 GB",
                        percentage: 0.9)
                }
            }
            .scrollIndicators(.hidden)
            
            Text("Quick Access")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(Color.black)
                .padding(.top)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView(.horizontal) {
                HStack(spacing: 4) {
                    CloudAppAccessButton(
                        image: "photo",
                        title: "Pictures",
                        color: .yellow,
                        action: {}
                    )
                    CloudAppAccessButton(
                        image: "music.note.house.fill",
                        title: "Music",
                        color: .blue,
                        action: {}
                    )
                    CloudAppAccessButton(
                        image: "play.rectangle.fill",
                        title: "Videos",
                        color: .red,
                        action: {}
                    )
                    CloudAppAccessButton(
                        image: "square.grid.2x2.fill",
                        title: "Apps",
                        color: .yellow,
                        action: {}
                    )
                    CloudAppAccessButton(
                        image: "doc.fill",
                        title: "Documents",
                        color: .blue,
                        action: {}
                    )
                    CloudAppAccessButton(
                        image: "arrow.down.app.fill",
                        title: "Downloads",
                        color: .pink,
                        action: {}
                    )
                }
            }
            .scrollIndicators(.hidden)
            
            Text("Recent Files")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(Color.black)
                .padding(.top, 24)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView(.vertical) {
                HStack {
                    VStack(alignment: isMacOS ? .leading : .center) {
                        HStack {
                            Text("Name")
                                .font(.caption)
                                .foregroundStyle(Color.gray)
                            
                            Spacer(minLength: 0)
                            
                            Text("Size")
                                .font(.caption)
                                .foregroundStyle(Color.gray)
                        }
                        
                        Divider()
                        
                        VStack(spacing: 12) {
                            CloudAppFilesView(
                                size: "8 MB",
                                name: "iJustin.jpg",
                                date: "20 March 1984",
                                image: "photo"
                            )
                            CloudAppFilesView(
                                size: "18 MB",
                                name: "Apple.mp4",
                                date: "20 March 1984",
                                image: "play.rectangle.fill"
                            )
                            CloudAppFilesView(
                                size: "2 MB",
                                name: "WWDC.jpg",
                                date: "20 March 1984",
                                image: "photo"
                            )
                            CloudAppFilesView(
                                size: "38 MB",
                                name: "SwiftUI 3.0.mp4",
                                date: "20 March 1984",
                                image: "play.rectangle.fill"
                            )
                            
                            CloudAppFilesView(
                                size: "38 MB",
                                name: "SwiftUI 3.0.mp4",
                                date: "20 March 1984",
                                image: "play.rectangle.fill"
                            )
                            
                            CloudAppFilesView(
                                size: "38 MB",
                                name: "SwiftUI 3.0.mp4",
                                date: "20 March 1984",
                                image: "play.rectangle.fill"
                            )
                            
                            CloudAppFilesView(
                                size: "38 MB",
                                name: "SwiftUI 3.0.mp4",
                                date: "20 March 1984",
                                image: "play.rectangle.fill"
                            )
                        }
                    }
                    .padding()
                    .frame(width: isMacOS ? 256 : nil)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 5, y: 5)
                }
            }
            .scrollIndicators(.hidden)
            
                
        }
        .padding(isMacOS ? 16 : 0)
    }
}

struct CloudAppFilesView: View {
    let size: String
    let name: String
    let date: String
    let image: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: image)
                .foregroundStyle(image == "photo" ? Color.yellow : .pink)
                .padding(6)
                .background(RoundedRectangle(cornerRadius: 4).stroke(Color.gray.opacity(0.3)))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.system(size: 16))
                    .fontWeight(.bold)
                    .foregroundStyle(Color.black)
                
                Text(date)
                    .font(.caption)
                    .foregroundStyle(Color.gray)
            }
            
            Spacer(minLength: 12)
            
            Text(size)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(Color.black)
        }
    }
}

struct CloudAppAccessButton: View {
    let image: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action, label: {
            VStack(spacing: 12) {
                Image(systemName: image)
                    .font(.title)
                    .foregroundStyle(color)
                    .frame(width: 50, height: 50)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 5, y: 5)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.bold)
                    .kerning(1.3)
                    .foregroundStyle(Color.black)
                
            }
            .frame(minWidth: 80)
        })
    }
}

struct CloudAppStorage<I: View>: View {
    var image: I
    var title: String
    var capacity: String
    var percentage: CGFloat
    
    var body: some View {
        VStack(alignment: isMacOS ? .leading : .center, spacing: 8) {
            HStack {
                image // Image.dropbox
                
                Divider()
                    .frame(height: 45)
                    .padding(.horizontal)
                
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.4), lineWidth: 8)
                    
                    Circle()
                        .trim(from: 0, to: percentage)
                        .stroke(Color.blueApp, style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                        .rotationEffect(.init(degrees: -90))
                    
                    Text("\(Int(percentage * 100))%")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.black)
                }
                .frame(width: 50, height: 50)
            }
            
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(Color.black)
                .padding(.top)
            
            Text(capacity)
                .font(.caption)
                .foregroundStyle(Color.gray)
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 5, y: 5)
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

struct AdaptableStack<Content: View, MenuView: View, SideView: View>:View {
    var content: Content
    var menuView: MenuView
    var sideView: SideView
    
    @Binding var showMenu: Bool
    
    var body: some View {
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
    
    init(
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
