import SwiftUI

//component that shows the back button in the search view
struct SearchBackButton: View {
    @ObservedObject var searchViewModel: SearchViewModel
    
    var body: some View {
        Image(systemName: "chevron.left")
            .imageScale(.large)
            .onTapGesture {
                searchViewModel.getBackButtonDetails()
            }
            .foregroundStyle(Color.navyBlue)
    }
}
