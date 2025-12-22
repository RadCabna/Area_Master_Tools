import SwiftUI

enum TabItem {
    case calculate
    case projects
    case records
    case tools
}

struct MainView: View {
    @State private var selectedTab: TabItem = .calculate
    
    var body: some View {
        ZStack {
            Color("bgColor")
                .ignoresSafeArea()
            
            selectedTabView
            
            VStack {
                Spacer()
                BottomBar(selectedTab: $selectedTab)
            }
            .ignoresSafeArea(.keyboard)
        }
    }
    
    @ViewBuilder
    private var selectedTabView: some View {
        switch selectedTab {
        case .calculate:
            CalculateView()
        case .projects:
            ProjectsView()
        case .records:
            RecordsView()
        case .tools:
            ToolsView()
        }
    }
}

#Preview {
    MainView()
}

