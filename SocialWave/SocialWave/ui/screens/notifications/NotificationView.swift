import SwiftUI

//view that shows the screen of the notifications in the notification tab
struct NotificationsView: View {
    @ObservedObject var sharedViewModel: SharedViewModel
    @ObservedObject var notificationViewModel: NotificationViewModel
    
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                if sharedViewModel.showProgress {
                    SocialWaveCircularProgressBar()
                        .controlSize(.large)
                        .padding(.top, 300)
                }
                else {
                    LazyVStack(spacing: 10) {
                        ForEach(0..<sharedViewModel.notifications.count, id: \.self) { index in
                            Notification(sharedViewModel: sharedViewModel, index: index)
                        }
                    }
                    .padding(.top, 5)
                    .padding(.bottom, 5)
                }
            }
            .refreshable {
                if !sharedViewModel.showProgress {
                    notificationViewModel.getNotificationsTask()
                }
            }
        }
        .onAppear {
            UIRefreshControl.appearance().tintColor = UIColor.navyBlue
            notificationViewModel.getNotificationsTask()
        }
    }
}
