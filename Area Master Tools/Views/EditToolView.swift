import SwiftUI

struct EditToolView: View {
    let tool: Tool
    let onBack: () -> Void
    let onSave: (Tool) -> Void
    
    @ObservedObject private var projectsManager = ProjectsManager.shared
    @State private var toolName: String
    @State private var selectedStatus: ToolStatus
    @State private var selectedProject: Project?
    @State private var showProjectSelection = false
    
    init(tool: Tool, onBack: @escaping () -> Void, onSave: @escaping (Tool) -> Void) {
        self.tool = tool
        self.onBack = onBack
        self.onSave = onSave
        
        _toolName = State(initialValue: tool.name)
        _selectedStatus = State(initialValue: tool.status)
        
        if let projectId = tool.projectId {
            _selectedProject = State(initialValue: ProjectsManager.shared.projects.first(where: { $0.id == projectId }))
        }
    }
    
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
                    
                    Text("Edit tool")
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
                        let updatedTool = Tool(
                            id: tool.id,
                            name: toolName,
                            status: selectedStatus,
                            projectId: selectedProject?.id
                        )
                        onSave(updatedTool)
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

#Preview {
    EditToolView(tool: Tool(name: "Hammer", status: .onSite), onBack: {}, onSave: { _ in })
}

