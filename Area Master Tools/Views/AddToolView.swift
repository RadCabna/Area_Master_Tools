import SwiftUI

struct AddToolView: View {
    let onBack: () -> Void
    let onSave: (Tool) -> Void
    
    @ObservedObject private var projectsManager = ProjectsManager.shared
    @State private var toolName: String = ""
    @State private var selectedStatus: ToolStatus = .notSelected
    @State private var selectedProject: Project?
    @State private var showProjectSelection = false
    
    private var isFormValid: Bool {
        !toolName.isEmpty
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
                    
                    Text("Add Tool")
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
                
                ScrollView {
                    VStack(spacing: screenHeight * 0.03) {
                        VStack(alignment: .leading, spacing: screenHeight * 0.01) {
                            Text("Tool name:")
                                .font(.custom("Montserrat-Bold", size: screenWidth * 0.05))
                                .foregroundColor(.white)
                            
                            TextField("", text: $toolName)
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
                        
                        VStack(alignment: .leading, spacing: screenHeight * 0.015) {
                            Text("Status:")
                                .font(.custom("Montserrat-Bold", size: screenWidth * 0.05))
                                .foregroundColor(.white)
                            
                            HStack(spacing: screenWidth * 0.04) {
                                ForEach([ToolStatus.onSite, ToolStatus.inRepair, ToolStatus.lost], id: \.self) { status in
                                    Button(action: {
                                        if selectedStatus == status {
                                            selectedStatus = .notSelected
                                        } else {
                                            selectedStatus = status
                                        }
                                    }) {
                                        HStack(spacing: screenWidth * 0.02) {
                                            Image(selectedStatus == status ? "statusOn" : "statusOff")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: screenWidth * 0.06)
                                            
                                            Text(status.rawValue)
                                                .font(.custom("Montserrat-Medium", size: screenWidth * 0.035))
                                                .foregroundColor(.white)
                                        }
                                    }
                                }
                                
                                Spacer()
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: screenHeight * 0.01) {
                            Text("Project:")
                                .font(.custom("Montserrat-Bold", size: screenWidth * 0.05))
                                .foregroundColor(.white)
                            
                            HStack {
                                Text(selectedProject?.name ?? "")
                                    .font(.custom("Montserrat-Medium", size: screenWidth * 0.04))
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Button(action: {
                                    showProjectSelection = true
                                }) {
                                    Text(selectedProject == nil ? "Select" : "Edit")
                                        .font(.custom("Montserrat-Medium", size: screenWidth * 0.04))
                                        .foregroundColor(.white)
                                }
                            }
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
                    .padding(.horizontal, screenWidth * 0.05)
                    .padding(.top, screenHeight * 0.03)
                    .padding(.bottom, screenHeight * 0.02)
                }
                
                Spacer()
                
                Button(action: {
                    if isFormValid {
                        let newTool = Tool(
                            name: toolName,
                            status: selectedStatus,
                            projectId: selectedProject?.id
                        )
                        onSave(newTool)
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
                BottomBar(selectedTab: .constant(.tools))
            }
            .ignoresSafeArea(.keyboard)
            
            if showProjectSelection {
                ProjectSelectionView(
                    projects: projectsManager.projects,
                    onSelect: { project in
                        selectedProject = project
                        showProjectSelection = false
                    },
                    onDismiss: {
                        showProjectSelection = false
                    }
                )
            }
        }
    }
}

struct ProjectSelectionView: View {
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
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
                .onTapGesture {
                    onDismiss()
                }
            
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
}

struct ProjectSelectionCard: View {
    let project: Project
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            ZStack(alignment: .center) {
                Image("projectsImage")
                    .resizable()
                    .scaledToFit()
                    .frame(width: screenWidth * 0.35)
                
                VStack(spacing: 0) {
                    Text(project.name)
                        .font(.custom("Montserrat-Bold", size: screenWidth * 0.03))
                        .foregroundColor(.red)
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, screenWidth * 0.02)
                        .padding(.top, screenHeight * 0.01)
                    
                    Spacer()
                    
                    VStack(alignment: .center, spacing: screenHeight * 0.003) {
                        Text("\(project.worksCount) works")
                            .font(.custom("Montserrat-Medium", size: screenWidth * 0.025))
                            .foregroundColor(.red)
                        
                        Text("$\(String(format: "%.2f", project.budget))")
                            .font(.custom("Montserrat-Bold", size: screenWidth * 0.028))
                            .foregroundColor(.red)
                    }
                    .padding(.bottom, screenHeight * 0.01)
                }
                .frame(width: screenWidth * 0.35)
            }
        }
    }
}

#Preview {
    AddToolView(onBack: {}, onSave: { _ in })
}

