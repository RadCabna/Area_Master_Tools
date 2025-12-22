import SwiftUI

struct ProjectsView: View {
    @ObservedObject private var projectsManager = ProjectsManager.shared
    @State private var showCreateProject = false
    @State private var selectedProject: Project?
    
    var body: some View {
        if let project = selectedProject {
            ProjectDetailView(project: project) {
                selectedProject = nil
            }
        } else if showCreateProject {
            CreateProjectView(
                onBack: { showCreateProject = false },
                onSave: { newProject in
                    projectsManager.addProject(newProject)
                    showCreateProject = false
                }
            )
        } else {
            projectsListView
        }
    }
    
    var columns: [GridItem] {
        [
            GridItem(.flexible(), spacing: screenWidth * 0.03),
            GridItem(.flexible(), spacing: screenWidth * 0.03)
        ]
    }
    
    private var projectsListView: some View {
        VStack(spacing: 0) {
            ZStack {
                Spacer()
                
                Text("Projects")
                    .font(.custom("Montserrat-Bold", size: screenWidth * 0.06))
                    .foregroundColor(.white)
                
                
                Button(action: {
                    showCreateProject = true
                }) {
                    Text("New Project")
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
                LazyVGrid(columns: columns, spacing: screenHeight * 0.02) {
                    ForEach(projectsManager.projects) { project in
                        ProjectCard(project: project) {
                            selectedProject = project
                        }
                    }
                }
                .padding(.horizontal, screenWidth * 0.05)
                .padding(.top, screenHeight * 0.03)
                .padding(.bottom, screenHeight * 0.12)
            }
        }
    }
}

struct ProjectCard: View {
    let project: Project
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            ZStack(alignment: .center) {
                Image("projectsImage")
                    .resizable()
                    .scaledToFit()
                    .frame(width: screenWidth * 0.43)
                
                VStack(spacing: 0) {
                Text(project.name)
                    .font(.custom("Montserrat-Bold", size: screenWidth * 0.035))
                    .foregroundColor(.red)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, screenWidth * 0.02)
                    .padding(.top, screenHeight * 0.01)
                
                Spacer()
                
                VStack(alignment: .center, spacing: screenHeight * 0.003) {
                    Text("\(project.worksCount) works")
                        .font(.custom("Montserrat-Medium", size: screenWidth * 0.028))
                        .foregroundColor(.red)
                    
                    Text("$\(String(format: "%.2f", project.budget))")
                        .font(.custom("Montserrat-Bold", size: screenWidth * 0.032))
                        .foregroundColor(.red)
                }
                .padding(.bottom, screenHeight * 0.01)
                }
                .frame(width: screenWidth * 0.43)
            }
        }
    }
}

#Preview {
    ProjectsView()
}

