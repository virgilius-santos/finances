import SwiftUI

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
