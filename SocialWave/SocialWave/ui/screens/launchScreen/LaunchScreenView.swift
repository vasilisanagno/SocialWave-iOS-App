import SwiftUI

//view that shows the screen that the logo icon splash in the screen
//and load the login or makes autologin to the home view
struct LaunchScreenView: View {
    @StateObject var launchScreenViewModel = LaunchScreenViewModel()
    @ObservedObject var sharedViewModel: SharedViewModel
    @State private var isActive = false
    @State private var logoScale: CGFloat = 0.5
    @State private var animationStarted = false
    
    let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    
    init(sharedViewModel: SharedViewModel = DIContainer.shared.container.resolve(SharedViewModel.self)!) {
        self.sharedViewModel = sharedViewModel
    }
    var body: some View {
        if isActive {
            if sharedViewModel.autoLogin || sharedViewModel.loginSuccess {
                TabNavigation()
            }
            else {
                ContentView()
            }
        } else {
            ZStack {
                Color.background
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .scaleEffect(logoScale)
            }
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                Task {
                    try await launchScreenViewModel.verifyUserForAutoLogin()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    // Start the animation after the delay
                    withAnimation(.easeInOut(duration: 0.5)) {
                        logoScale = 1.0
                        animationStarted = true
                    }
                }
            }
            .onReceive(timer) { _ in
                if animationStarted {
                    if logoScale < 2.2 {
                        logoScale += 0.05
                    } else {
                        isActive = true // Stop the animation and transition to the main content view
                        timer.upstream.connect().cancel() // Stop the timer
                    }
                }
            }
        }
    }
}
