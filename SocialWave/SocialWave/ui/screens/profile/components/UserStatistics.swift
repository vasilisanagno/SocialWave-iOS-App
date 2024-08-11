import SwiftUI

//component that shows the user statistics num of friends/posts/requests
struct UserStatistics: View{
    let value: Int
    let title: String

    var body: some View {
        VStack {
            Text("\(value)")
                .font(.subheadline)
                .fontWeight(.semibold)

            Text(title)
                .font(.footnote)

        }
        .frame(width: 60)
    }
}
