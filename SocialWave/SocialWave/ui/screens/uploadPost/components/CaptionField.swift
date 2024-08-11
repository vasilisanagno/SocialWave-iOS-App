import SwiftUI

//component that shows the caption field to set something the user wants
struct CaptionField: View {
    @ObservedObject var uploadPostViewModel: UploadPostViewModel
    @ObservedObject var sharedViewModel: SharedViewModel
    
    var body: some View {
        SocialWaveTextField(placeholder: "Caption", sharedViewModel: sharedViewModel)
            .padding(.leading, 10)
            .padding(.trailing, 10)
            .padding(.bottom, 20)
            .disabled(sharedViewModel.showProgress)
        
        if sharedViewModel.showProgress {
            SocialWaveCircularProgressBar()
                .controlSize(.large)
                .padding(.top, 50)
        }
        Spacer()
    }
}
