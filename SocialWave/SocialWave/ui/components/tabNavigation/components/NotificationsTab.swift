import SwiftUI

//component for the tab of tab view that shows the notifications view
struct NotificationsTab: View {
    @ObservedObject var sharedViewModel: SharedViewModel
    @ObservedObject var notificationViewModel: NotificationViewModel
    @State private var showAlert = false
    
    var body: some View {
        NavigationStack(path: $sharedViewModel.tabPath[3]) {
            VStack {
                Divider()
                    .frame(width: 400, height: 1.2)
                    .background(.navyBlue)
                NotificationsView(sharedViewModel: sharedViewModel, notificationViewModel: notificationViewModel)
                    .padding(.top, -8)
            }
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAlert = true
                    } label: {
                        Text("Clear All")
                            .foregroundStyle(.red)
                            .font(.subheadline)
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Delete Notifications"),
                            message: Text("Are you sure you want to delete your notifications?"),
                            primaryButton: .destructive(Text("Yes")) {
                                notificationViewModel.deleteNotificationsTask()
                        },
                        secondaryButton: .cancel(Text("No")))
                    }
                }
            }
        }
    }
}
