import SwiftUI

//component that shows the toolbar of the new chat/new message to some of the current user's friends
struct NewMessageToolbar: View {
    let dismiss: DismissAction
    
    var body: some View {
        //toolbar
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .padding(.top, 10)
                }
                .padding(.horizontal)
                
                Spacer()
                Text("New Message")
                    .bold()
                    .font(.system(size: 20))
                    .padding(.top, 10)
                    .padding(.trailing, 135)
            }
        }
    }
}
