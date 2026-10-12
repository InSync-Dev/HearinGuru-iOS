import SwiftUI

struct MainTabView: View {

    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {

            NavigationStack {
                ToolsView()
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar { logoToolbar() }
            }
            .tabItem { Label("Tools",  systemImage: "wrench.and.screwdriver") }
            .tag(0)

            NavigationStack {
                LearnView()
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar { logoToolbar() }
            }
            .tabItem { Label("Learn", systemImage: "book") }
            .tag(1)

            NavigationStack {
                HearingAidsView()
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar { logoToolbar() }
            }
            .tabItem { Label("Aids", systemImage: "ear.and.waveform") }
            .tag(2)

            NavigationStack {
                DoctorView()
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar { logoToolbar() }
            }
            .tabItem { Label("Doctor", systemImage: "stethoscope") }
            .tag(3)
        }
        .tint(AppTheme.primary)
    }

    @ToolbarContentBuilder
    private func logoToolbar() -> some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text("HearinGuru")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(AppTheme.primary)
        }
        ToolbarItem(placement: .topBarTrailing) {
            HStack(spacing: 4) {
                NavigationLink(destination: NotificationsView()) {
                    Image(systemName: "bell")
                        .foregroundStyle(AppTheme.primary)
                }
                NavigationLink(destination: ProfileView()) {
                    Image(systemName: "person.circle")
                        .foregroundStyle(AppTheme.primary)
                }
            }
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(AudioService())
        .environmentObject(AmplifierService())
        .environmentObject(NoiseMeterService())
}
