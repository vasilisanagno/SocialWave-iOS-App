import SwiftUI

//component that shows the tab view with tab navigation in the bottom of the app
struct TabNavigation: View {
    @StateObject var searchViewModel = SearchViewModel()
    @StateObject var profileViewModel = ProfileViewModel()
    @StateObject var homeViewModel = HomeViewModel()
    @StateObject var notificationViewModel = NotificationViewModel()
    @StateObject var inboxViewModel = InboxViewModel()
    @StateObject var chatViewModel = ChatViewModel()
    @ObservedObject var socketViewModel: SocketViewModel
    @ObservedObject var sharedViewModel: SharedViewModel
    @State var navigationTitle = ""
    
    init(sharedViewModel: SharedViewModel = DIContainer.shared.container.resolve(SharedViewModel.self)!,
         socketViewModel: SocketViewModel = DIContainer.shared.container.resolve(SocketViewModel.self)!) {
        self.sharedViewModel = sharedViewModel
        self.socketViewModel = socketViewModel
        Design.designTabNavigation()
    }
    
    var body: some View {
        TabView(selection: $sharedViewModel.selectedTab) {
            
            HomeTab(sharedViewModel: sharedViewModel, socketViewModel: socketViewModel, profileViewModel: profileViewModel, homeViewModel: homeViewModel)
                .tabItem {
                    Image(systemName: "house")
                }
                .tag(1)
            
            SearchTab(searchViewModel: searchViewModel, sharedViewModel: sharedViewModel, socketViewModel: socketViewModel, profileViewModel: profileViewModel, homeViewModel: homeViewModel)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }
                .tag(2)
            
            ChatTab(sharedViewModel: sharedViewModel, socketViewModel: socketViewModel, inboxViewModel: inboxViewModel, chatViewModel: chatViewModel)
                .tabItem {
                    Image(systemName: "ellipsis.message")
                }
                .tag(3)
                .badge(sharedViewModel.numOfUnseenChats != 0 ? "\(sharedViewModel.numOfUnseenChats)" : nil)
            
            NotificationsTab(sharedViewModel: sharedViewModel, notificationViewModel: notificationViewModel)
                .tabItem {
                    Image(systemName: "bell")
                }
                .tag(4)
                .badge(sharedViewModel.numOfUnseenNotif != 0 ? "\(sharedViewModel.numOfUnseenNotif)" : nil)
            
            ProfileTab(sharedViewModel: sharedViewModel, socketViewModel: socketViewModel, searchViewModel: searchViewModel,profileViewModel: profileViewModel, homeViewModel: homeViewModel)
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                }
                .tag(5)
        }
        .onChange(of: sharedViewModel.selectedTab) {
            sharedViewModel.tabNavigationChange()
        }
        .accentColor(.navyBlue)
        .foregroundStyle(.navyBlue)
    }
}

#Preview {
    TabNavigation()
}
