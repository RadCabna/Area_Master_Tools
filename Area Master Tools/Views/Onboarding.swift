import SwiftUI

struct OnboardingScreen {
    let image: String
    let title: String
    let description: String
}

struct Onboarding: View {
    @State private var currentPage = 0
    @ObservedObject private var nav: NavGuard = NavGuard.shared
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    
    private let screens = [
        OnboardingScreen(
            image: "onboardingImage_1",
            title: "Quick and accurate work calculations.",
            description: "Measure your task, set the price, and get the total instantly."
        ),
        OnboardingScreen(
            image: "onboardingImage_2",
            title: "Keep all your projects perfectly organized.",
            description: "Apartments, houses, offices - everything in one place."
        ),
        OnboardingScreen(
            image: "onboardingImage_3",
            title: "Track all your tools easily.",
            description: "Know what's on site, in repair, or missing."
        )
    ]
    
    var body: some View {
        ZStack {
            Color("bgColor")
                .ignoresSafeArea()
            
            Image("background")
                .resizable()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Фиксированная высота для изображения, вплотную к верху
                Image(screens[currentPage].image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: screenWidth, height: screenHeight * 0.5)
                    .clipped()
                    .ignoresSafeArea(edges: .top)
                
                Spacer()
                    .frame(height: screenHeight * 0.05)
                
                // Фиксированная область для текста чтобы элементы не прыгали
                VStack(spacing: screenHeight * 0.02) {
                    Text(screens[currentPage].title)
                        .font(.custom("Montserrat-Bold", size: screenWidth * 0.06))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, screenWidth * 0.1)
                        .frame(height: screenWidth * 0.15, alignment: .top)
                    
                    Text(screens[currentPage].description)
                        .font(.custom("Montserrat-Medium", size: screenWidth * 0.045))
                        .foregroundColor(Color("textColor"))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, screenWidth * 0.1)
                        .frame(height: screenWidth * 0.12, alignment: .top)
                }
                .frame(height: screenHeight * 0.15)
                
                Spacer()
                    .frame(height: screenHeight * 0.04)
                
                HStack(spacing: screenWidth * 0.02) {
                    ForEach(0..<3) { index in
                        Image(index == currentPage ? "activeOnboarding" : "unactiveOnboarding")
                            .resizable()
                            .scaledToFit()
                            .frame(height: screenHeight * 0.01)
                    }
                }
                
                Spacer()
                
                Button(action: {
                    if currentPage < 2 {
                        withAnimation {
                            currentPage += 1
                        }
                    } else {
                        hasCompletedOnboarding = true
                        nav.currentScreen = .MAIN
                    }
                }) {
                    ZStack {
                        Image("redRect")
                            .resizable()
                            .scaledToFit()
                            .frame(width: screenWidth * 0.85)
                        
                        Text(currentPage < 2 ? "Next" : "GetStarted")
                            .font(.custom("Montserrat-Bold", size: screenWidth * 0.05))
                            .foregroundColor(.white)
                    }
                }
                .padding(.bottom, deviceHasSafeArea ? 40 : 20)
            }
        }
    }
}

#Preview {
    Onboarding()
}

