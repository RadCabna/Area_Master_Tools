import SwiftUI

struct ResultView: View {
    let workType: WorkType
    let height: Double
    let length: Double
    let pricePerM2: Double
    let onBack: () -> Void
    
    @ObservedObject private var projectsManager = ProjectsManager.shared
    @ObservedObject private var recordsManager = RecordsManager.shared
    @State private var showProjectSelection = false
    
    private var area: Double {
        height * length
    }
    
    private var totalCost: Double {
        area * pricePerM2
    }
    
    private var materialConsumption: Double {
        switch workType.id {
        case 1:
            return area * 15
        case 2:
            return area * 18
        case 3:
            return area * 0.3
        case 4:
            return area * 20
        case 5:
            return area * 20
        case 6:
            return area * 0.25
        case 7:
            return area * 400
        case 8:
            return area * 0.5
        case 9:
            return area * 8
        case 10:
            return area * 9
        case 11:
            return area * 5
        case 12:
            return area * 350
        default:
            return 0
        }
    }
    
    var body: some View {
        ZStack {
            Color("bgColor")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Фиксированный header
                HStack {
                    Button(action: onBack) {
                        Image("backButton")
                            .resizable()
                            .scaledToFit()
                            .frame(width: screenWidth * 0.033)
                    }
                    .padding(.leading, screenWidth * 0.05)
                    
                    Text("Result")
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
                
                // Скроллируемый контент
                ScrollView {
                    VStack(spacing: screenHeight * 0.03) {
                        ResultField(title: "Area:", value: String(format: "%.2f m²", area))
                        ResultField(title: "Material Consumption:", value: String(format: "%.2f kg", materialConsumption))
                    }
                    .padding(.horizontal, screenWidth * 0.05)
                    .padding(.top, screenHeight * 0.03)
                    
                    Spacer()
                        .frame(height: screenHeight * 0.04)
                    
                    ZStack {
                        Image("whiteRect")
                            .resizable()
                            .scaledToFit()
                            .frame(width: screenWidth * 0.57)
                        
                        Text("Total: $\(String(format: "%.2f", totalCost))")
                            .font(.custom("Montserrat-Bold", size: screenWidth * 0.045))
                            .foregroundColor(.red)
                    }
                    
                    Spacer()
                        .frame(height: screenHeight * 0.04)
                    
                    VStack(spacing: screenHeight * 0.02) {
                        Button(action: {
                            let newWork = Work(
                                name: workType.title,
                                cost: totalCost
                            )
                            recordsManager.addRecord(newWork)
                            onBack()
                        }) {
                            ZStack {
                                Image("redRect")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: screenWidth * 0.85)
                                
                                Text("Save")
                                    .font(.custom("Montserrat-Bold", size: screenWidth * 0.05))
                                    .foregroundColor(.white)
                            }
                        }
                        
                        Button(action: {
                            showProjectSelection = true
                        }) {
                            ZStack {
                                Image("redRect")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: screenWidth * 0.85)
                                
                                Text("Save to Project")
                                    .font(.custom("Montserrat-Bold", size: screenWidth * 0.05))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .padding(.bottom, screenHeight * 0.15)
                }
            }
            
            VStack {
                Spacer()
                BottomBar(selectedTab: .constant(.calculate))
            }
            .ignoresSafeArea(.keyboard)
            
            if showProjectSelection {
                ZStack {
                    Color.black.opacity(0.7)
                        .ignoresSafeArea()
                        .onTapGesture {
                            showProjectSelection = false
                        }
                    
                    ProjectSelectionViewForResult(
                        projects: projectsManager.projects,
                        onSelect: { project in
                            let newWork = Work(
                                name: workType.title,
                                cost: totalCost
                            )
                            
                            if let projectIndex = projectsManager.projects.firstIndex(where: { $0.id == project.id }) {
                                var updatedProject = projectsManager.projects[projectIndex]
                                updatedProject.works.append(newWork)
                                projectsManager.updateProject(updatedProject)
                            }
                            
                            showProjectSelection = false
                            onBack()
                        },
                        onDismiss: {
                            showProjectSelection = false
                        }
                    )
                }
            }
        }
        .onAppear {
            // Принудительно закрываем клавиатуру при открытии экрана
            hideKeyboard()
        }
    }
}

struct ProjectSelectionViewForResult: View {
    let projects: [Project]
    let onSelect: (Project) -> Void
    let onDismiss: () -> Void
    
    var columns: [GridItem] {
        [
            GridItem(.flexible(), spacing: screenWidth * 0.03),
            GridItem(.flexible(), spacing: screenWidth * 0.03)
        ]
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Select Project")
                .font(.custom("Montserrat-Bold", size: screenWidth * 0.05))
                .foregroundColor(.white)
                .padding(.vertical, screenHeight * 0.02)
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: screenHeight * 0.02) {
                    ForEach(projects) { project in
                        ProjectSelectionCard(project: project) {
                            onSelect(project)
                        }
                    }
                }
                .padding(.horizontal, screenWidth * 0.05)
                .padding(.vertical, screenHeight * 0.02)
            }
            
            Button(action: onDismiss) {
                Text("Cancel")
                    .font(.custom("Montserrat-Bold", size: screenWidth * 0.045))
                    .foregroundColor(.white)
                    .padding(.vertical, screenHeight * 0.02)
            }
        }
        .frame(width: screenWidth * 0.9, height: screenHeight * 0.7)
        .background(Color("bgColor"))
        .cornerRadius(15)
    }
}

struct ResultField: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: screenHeight * 0.01) {
            Text(title)
                .font(.custom("Montserrat-Bold", size: screenWidth * 0.05))
                .foregroundColor(.white)
            
            Text(value)
                .font(.custom("Montserrat-Medium", size: screenWidth * 0.045))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, screenHeight * 0.008)
                .overlay(
                    Rectangle()
                        .fill(.white)
                        .frame(height: 1)
                        .padding(.top, screenHeight * 0.04),
                    alignment: .bottom
                )
        }
    }
}

#Preview {
    ResultView(workType: workTypes[0], height: 3.0, length: 4.0, pricePerM2: 50.0, onBack: {})
}

