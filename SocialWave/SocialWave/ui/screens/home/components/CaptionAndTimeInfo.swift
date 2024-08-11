import SwiftUI

//component that shows the description and the time that is created the post
struct CaptionAndTimeInfo: View {
    let username: String
    let caption: String
    let createdAt: String
    
    var body: some View {
        //caption label
        HStack(spacing: 3) {
            Text(username).fontWeight(.semibold) + //we need the plus to keep the username the descpription as one text
            Text(" "+caption)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.footnote)
        .padding(.leading, 15)
        .padding(.trailing, 15)
        .padding(.top, 1)

        //timestamp label
        Text(createdAt)
            .font(.footnote)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 15)
            .padding(.top, 1)
            .padding(.bottom, 10)
            .foregroundStyle(.navyBlue)
    }
}
