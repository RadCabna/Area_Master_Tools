import SwiftUI

struct ToolsView: View {
    @ObservedObject private var toolsManager = ToolsManager.shared
    @ObservedObject private var projectsManager = ProjectsManager.shared
    @State private var showAddTool = false
    @State private var selectedTool: Tool?
    
    var body: some View {
        if let tool = selectedTool {
            EditToolView(
                tool: tool,
                onBack: { selectedTool = nil },
                onSave: { updatedTool in
                    let oldProjectId = tool.projectId
                    let newProjectId = updatedTool.projectId
                    
                    toolsManager.updateTool(updatedTool)
                    
                    if oldProjectId != newProjectId {
                        if let oldId = oldProjectId,
                           let oldProjectIndex = projectsManager.projects.firstIndex(where: { $0.id == oldId }) {
                            var oldProject = projectsManager.projects[oldProjectIndex]
                            oldProject.tools.removeAll { $0.id == updatedTool.id }
                            projectsManager.updateProject(oldProject)
                        }
                        
                        if let newId = newProjectId,
                           let newProjectIndex = projectsManager.projects.firstIndex(where: { $0.id == newId }) {
                            var newProject = projectsManager.projects[newProjectIndex]
                            newProject.tools.append(updatedTool)
                            projectsManager.updateProject(newProject)
                        }
                    } else if let projectId = newProjectId,
                              let projectIndex = projectsManager.projects.firstIndex(where: { $0.id == projectId }) {
                        var project = projectsManager.projects[projectIndex]
                        if let toolIndex = project.tools.firstIndex(where: { $0.id == updatedTool.id }) {
                            project.tools[toolIndex] = updatedTool
                            projectsManager.updateProject(project)
                        }
                    }
                    
                    selectedTool = nil
                }
            )
        } else if showAddTool {
            AddToolView(
                onBack: { showAddTool = false },
                onSave: { newTool in
                    toolsManager.addTool(newTool)
                    
                    if let projectId = newTool.projectId,
                       let projectIndex = projectsManager.projects.firstIndex(where: { $0.id == projectId }) {
                        var project = projectsManager.projects[projectIndex]
                        project.tools.append(newTool)
                        projectsManager.updateProject(project)
                    }
                    
                    showAddTool = false
                }
            )
        } else {
            toolsListView
        }
    }
    
    private var toolsListView: some View {
        VStack(spacing: 0) {
            ZStack {
                Text("Tools")
                    .font(.custom("Montserrat-Bold", size: screenWidth * 0.06))
                    .foregroundColor(.white)
                
              
                    Button(action: {
                        showAddTool = true
                    }) {
                        Text("+ Add tool")
                            .font(.custom("Montserrat-Medium", size: screenWidth * 0.04))
                            .foregroundColor(.white)
                    }
                    .offset(x: screenWidth*0.3)
            }
            .padding(.top, deviceHasSafeArea ? screenHeight * 0.015 : screenHeight * 0.02)
            .padding(.bottom, screenHeight * 0.015)
            
            Rectangle()
                .fill(.white)
                .frame(width: screenWidth, height: 1)
            
            ScrollView {
                VStack(spacing: screenHeight * 0.015) {
                    ForEach(toolsManager.tools) { tool in
                        HStack {
                            Spacer()
                        SwipeableToolItemCard(
                            tool: tool,
                            projectName: getProjectName(for: tool),
                            onTap: {
                                selectedTool = tool
                            },
                            onDelete: {
                                if let projectId = tool.projectId,
                                   let projectIndex = projectsManager.projects.firstIndex(where: { $0.id == projectId }) {
                                    var project = projectsManager.projects[projectIndex]
                                    project.tools.removeAll { $0.id == tool.id }
                                    projectsManager.updateProject(project)
                                }
                                
                                toolsManager.deleteTool(tool)
                            }
                        )
                            Spacer()
                        }
                    }
                }
                .padding(.top, screenHeight * 0.03)
                .padding(.bottom, screenHeight * 0.12)
            }
        }
    }
    
    private func getProjectName(for tool: Tool) -> String? {
        guard let projectId = tool.projectId else { return nil }
        return projectsManager.projects.first(where: { $0.id == projectId })?.name
    }
}

struct SwipeableToolItemCard: View {
    let tool: Tool
    let projectName: String?
    let onTap: () -> Void
    let onDelete: () -> Void
    
    @State private var offset: CGFloat = 0
    
    private let deleteButtonWidth: CGFloat = 100
    
    var body: some View {
        ZStack(alignment: .leading) {
            Button(action: onDelete) {
                ZStack {
                    Color.red
                    
                    Text("Delete")
                        .font(.custom("Montserrat-Bold", size: screenWidth * 0.04))
                        .foregroundColor(.white)
                }
            }
            .frame(width: deleteButtonWidth, height: screenHeight * 0.08)
            .offset(x: screenWidth * 0.98 + offset)
            
            ZStack {
                Image("workFrame")
                    .resizable()
                    .scaledToFit()
                    .frame(width: screenWidth * 0.95)
                
                HStack {
                    Text(tool.name)
                        .font(.custom("Montserrat-Medium", size: screenWidth * 0.04))
                        .foregroundColor(.white)
                        .padding(.leading, screenWidth * 0.05)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: screenHeight * 0.005) {
                        Text(tool.status.rawValue)
                            .font(.custom("Montserrat-Medium", size: screenWidth * 0.038))
                            .foregroundColor(.white)
                        
                        if let projectName = projectName {
                            Text(projectName)
                                .font(.custom("Montserrat-Medium", size: screenWidth * 0.035))
                                .foregroundColor(.red)
                        }
                    }
                    .padding(.trailing, screenWidth * 0.05)
                }
                .frame(width: screenWidth * 0.95)
            }
            .offset(x: offset)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        let newOffset = gesture.translation.width
                        if newOffset < 0 {
                            offset = max(newOffset, -deleteButtonWidth)
                        } else if offset < 0 {
                            offset = min(0, offset + newOffset)
                        }
                    }
                    .onEnded { gesture in
                        if gesture.translation.width < -50 {
                            withAnimation(.spring(response: 0.3)) {
                                offset = -deleteButtonWidth
                            }
                        } else {
                            withAnimation(.spring(response: 0.3)) {
                                offset = 0
                            }
                        }
                    }
            )
            .onTapGesture {
                if offset == 0 {
                    onTap()
                } else {
                    withAnimation(.spring(response: 0.3)) {
                        offset = 0
                    }
                }
            }
        }
        .frame(width: screenWidth * 0.95 + deleteButtonWidth)
        .clipped()
    }
}

#Preview {
    ToolsView()
}

