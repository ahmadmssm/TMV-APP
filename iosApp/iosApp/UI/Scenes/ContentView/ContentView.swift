import SwiftUI
import PulseUI
import Factory
import kmmSharedModule

struct ContentView: View {
    
    @InjectedObject(\.contentViewViewModel)
    private var viewModel: ContentViewViewModel
    @InjectedObject(\.globalBottomSheetController)
    private var globalBottomSheetController: GlobalBottomSheetController
    @InjectedObject(\.networkConnectivityObserver)
    private var networkConnectivityObserver: NetworkConnectivityObserver
    @State
    private var isHttpLoggerPresented = false
    
    var body: some View {
        ZStack {
            TabbarControllerView()
                .environmentObject(networkConnectivityObserver)
                .banner(params: $networkConnectivityObserver.banner)
                .onFirstAppear {
                    self.viewModel.onFirstAppear()
                }
            TeavaroConsentView.create(self.$viewModel.showTeavaroPopUp)
            UTIQConsentView.create(self.$viewModel.showUTIQPopUp)
        }
        .navigate(to: ConsoleView().closeButtonHidden(), when: $isHttpLoggerPresented)
        .sheet(isPresented: self.$globalBottomSheetController.isPresented) {
            VStack {
                Text(self.globalBottomSheetController.message)
                    .padding()
            }
            .presentationDetents([.height(300)])
        }
        .onShake {
            self.isHttpLoggerPresented = true && EnvironmentVariables.isDebugEnv
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        // .environment(\.colorScheme, .light)
    }
}

/// Known issues:
/// 1. dismiss issue.
/// 2. dismissToRootView issue.
/// 3. Netwrok errors to be more human redable errors
