import SwiftUI

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
