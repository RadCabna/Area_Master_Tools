import SwiftUI

struct ProjectDetailView: View {
    let project: Project
    let onBack: () -> Void
    
    @ObservedObject private var projectsManager = ProjectsManager.shared
    
    private var currentProject: Project {
        projectsManager.projects.first(where: { $0.id == project.id }) ?? project
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
                    
                    Text(currentProject.name)
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
                    VStack(spacing: screenHeight * 0.02) {
                        Text("List of works")
                            .font(.custom("Montserrat-Bold", size: screenWidth * 0.05))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, screenWidth * 0.025)
                        
                        ForEach(currentProject.works) { work in
                            WorkItemView(work: work)
                        }
                        
                        DashedLine()
                            .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                            .frame(width: screenWidth * 0.95, height: 1)
                            .foregroundColor(.white)
                            .padding(.vertical, screenHeight * 0.01)
                        
                        Text("Tools on site")
                            .font(.custom("Montserrat-Bold", size: screenWidth * 0.05))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, screenWidth * 0.025)
                        
                        ForEach(currentProject.tools) { tool in
                            ToolItemView(tool: tool)
                        }
                    }
                    .padding(.top, screenHeight * 0.03)
                    .padding(.bottom, screenHeight * 0.12)
                }
            }
            
            VStack {
                Spacer()
                BottomBar(selectedTab: .constant(.projects))
            }
            .ignoresSafeArea(.keyboard)
        }
    }
}

struct WorkItemView: View {
    let work: Work
    
    var body: some View {
        ZStack {
            Image("workFrame")
                .resizable()
                .scaledToFit()
                .frame(width: screenWidth * 0.95)
            
            HStack {
                VStack(alignment: .leading, spacing: screenHeight * 0.005) {
                    Text("$\(String(format: "%.2f", work.cost))")
                        .font(.custom("Montserrat-Bold", size: screenWidth * 0.04))
                        .foregroundColor(.red)
                    
                    Text(work.formattedDate)
                        .font(.custom("Montserrat-Medium", size: screenWidth * 0.035))
                        .foregroundColor(Color("textColor"))
                }
                .padding(.leading, screenWidth * 0.05)
                
                Spacer()
                
                Text(work.name)
                    .font(.custom("Montserrat-Medium", size: screenWidth * 0.04))
                    .foregroundColor(.white)
                    .padding(.trailing, screenWidth * 0.05)
            }
            .frame(width: screenWidth * 0.95)
        }
    }
}

struct ToolItemView: View {
    let tool: Tool
    
    var body: some View {
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
                
                Text(tool.status.rawValue)
                    .font(.custom("Montserrat-Medium", size: screenWidth * 0.04))
                    .foregroundColor(.white)
                    .padding(.trailing, screenWidth * 0.05)
            }
            .frame(width: screenWidth * 0.95)
        }
    }
}

struct DashedLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}

#Preview {
    let sampleProject = Project(
        name: "Sample Project",
        works: [
            Work(name: "Plastering", cost: 1500.0),
            Work(name: "Painting", cost: 800.0)
        ],
        tools: [
            Tool(name: "Hammer", status: .onSite),
            Tool(name: "Drill", status: .inRepair),
            Tool(name: "Saw", status: .lost)
        ]
    )
    ProjectDetailView(project: sampleProject, onBack: {})
}

