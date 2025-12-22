import SwiftUI

struct CreateProjectView: View {
    let onBack: () -> Void
    let onSave: (Project) -> Void
    
    @State private var projectName: String = ""
    
    private var isFormValid: Bool {
        !projectName.isEmpty
    }
    
    var body: some View {
        ZStack {
            Color("bgColor")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Button(action: onBack) {
                        Image("backButton")
                            .resizable()
                            .scaledToFit()
                            .frame(width: screenWidth * 0.033)
                    }
                    .padding(.leading, screenWidth * 0.05)
                    
                    Text("New Project")
                        .font(.custom("Montserrat-Bold", size: screenWidth * 0.06))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                    
                    Color.clear
                        .frame(width: screenWidth * 0.033)
                        .padding(.trailing, screenWidth * 0.05)
                }
                .frame(height: screenHeight*0.06)
                .padding(.top, deviceHasSafeArea ? screenHeight * 0.015 : screenHeight * 0.02)
                .padding(.bottom, screenHeight * 0.015)
                
                Rectangle()
                    .fill(.white)
                    .frame(width: screenWidth, height: 1)
                
                VStack(alignment: .leading, spacing: screenHeight * 0.01) {
                    Text("Enter project name:")
                        .font(.custom("Montserrat-Bold", size: screenWidth * 0.05))
                        .foregroundColor(.white)
                    
                    TextField("", text: $projectName)
                        .font(.custom("Montserrat-Medium", size: screenWidth * 0.04))
                        .foregroundColor(.white)
                        .autocorrectionDisabled()
                        .padding(.bottom, screenHeight * 0.008)
                        .overlay(
                            Rectangle()
                                .fill(.white)
                                .frame(height: 1)
                                .padding(.top, screenHeight * 0.04),
                            alignment: .bottom
                        )
                }
                .padding(.horizontal, screenWidth * 0.05)
                .padding(.top, screenHeight * 0.03)
                
                Spacer()
                
                Button(action: {
                    if isFormValid {
                        let newProject = Project(name: projectName)
                        onSave(newProject)
                    }
                }) {
                    ZStack {
                        Image(isFormValid ? "redRect" : "grayRect")
                            .resizable()
                            .scaledToFit()
                            .frame(width: screenWidth * 0.85)
                        
                        Text("Save")
                            .font(.custom("Montserrat-Bold", size: screenWidth * 0.05))
                            .foregroundColor(.white)
                    }
                }
                .disabled(!isFormValid)
                .padding(.bottom, screenHeight * 0.15)
            }
            
            VStack {
                Spacer()
                BottomBar(selectedTab: .constant(.projects))
            }
            .ignoresSafeArea(.keyboard)
        }
    }
}

#Preview {
    CreateProjectView(onBack: {}, onSave: { _ in })
}




