import SwiftUI

@main
struct HearinGuruApp: App {

    @StateObject private var audioService      = AudioService()
    @StateObject private var amplifierService  = AmplifierService()
    @StateObject private var noiseMeterService = NoiseMeterService()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(audioService)
                .environmentObject(amplifierService)
                .environmentObject(noiseMeterService)
        }
    }
}
