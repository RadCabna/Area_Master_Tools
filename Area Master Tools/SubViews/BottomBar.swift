import SwiftUI

struct BottomBar: View {
    @Binding var selectedTab: TabItem
    
    var body: some View {
        ZStack {
            Image("bottomBarBG")
                .resizable()
                .scaledToFit()
                .frame(width: screenWidth*0.9)
            
            HStack(spacing: 0) {
                BottomBarButton(
                    icon: selectedTab == .calculate ? "calculateOn" : "calculateOff",
                    title: "Calculate",
                    isSelected: selectedTab == .calculate
                ) {
                    selectedTab = .calculate
                }
                
                BottomBarButton(
                    icon: selectedTab == .projects ? "projectsOn" : "projectsOff",
                    title: "Projects",
                    isSelected: selectedTab == .projects
                ) {
                    selectedTab = .projects
                }
                
                BottomBarButton(
                    icon: selectedTab == .records ? "recordsOn" : "recordsOff",
                    title: "Records",
                    isSelected: selectedTab == .records
                ) {
                    selectedTab = .records
                }
                
                BottomBarButton(
                    icon: selectedTab == .tools ? "toolsOn" : "toolsOff",
                    title: "Tools",
                    isSelected: selectedTab == .tools
                ) {
                    selectedTab = .tools
                }
            }
            .frame(width: screenWidth*0.85)
        }
    }
}

struct BottomBarButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: screenHeight * 0.005) {
                Image(icon)
                    .resizable()
                    .scaledToFit()
                    .frame(height: screenHeight * 0.06)
                
                Text(title)
                    .font(.system(size: screenWidth * 0.035, weight: .regular, design: .default))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
        }
    }
}


