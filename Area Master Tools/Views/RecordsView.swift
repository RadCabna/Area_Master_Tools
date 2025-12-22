import SwiftUI

struct RecordsView: View {
    @ObservedObject private var recordsManager = RecordsManager.shared
    @ObservedObject private var projectsManager = ProjectsManager.shared
    @State private var selectedWork: Work?
    @State private var workToDelete: Work?
    @State private var showDeleteAlert = false
    @State private var workToAddToProject: Work?
    @State private var showProjectSelection = false
    
    var body: some View {
        if let work = selectedWork {
            EditRecordView(
                work: work,
                onBack: { selectedWork = nil },
                onSave: { updatedWork in
                    recordsManager.updateRecord(updatedWork)
                    selectedWork = nil
                }
            )
        } else {
            recordsListView
        }
    }
    
    private var recordsListView: some View {
        VStack(spacing: 0) {
            Text("Records")
                .font(.custom("Montserrat-Bold", size: screenWidth * 0.06))
                .foregroundColor(.white)
                .padding(.top, deviceHasSafeArea ? screenHeight * 0.015 : screenHeight * 0.02)
                .padding(.bottom, screenHeight * 0.015)
            
            Rectangle()
                .fill(.white)
                .frame(width: screenWidth, height: 1)
            
            ScrollView {
                VStack(spacing: screenHeight * 0.025) {
                    ForEach(recordsManager.records) { record in
                        VStack(spacing: screenHeight * 0.01) {
                            HStack {
                                Spacer()
                                RecordItemCard(work: record)
                                Spacer()
                            }
                            
                            HStack {
                                Spacer()
                                
                                Button(action: {
                                    selectedWork = record
                                }) {
                                    Text("Edit")
                                        .font(.custom("Montserrat-Medium", size: screenWidth * 0.035))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, screenWidth * 0.04)
                                        .padding(.vertical, screenHeight * 0.008)
                                        .background(Color.red.opacity(0.7))
                                        .cornerRadius(8)
                                }
                                
                                Button(action: {
                                    workToDelete = record
                                    showDeleteAlert = true
                                }) {
                                    Text("Delete")
                                        .font(.custom("Montserrat-Medium", size: screenWidth * 0.035))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, screenWidth * 0.04)
                                        .padding(.vertical, screenHeight * 0.008)
                                        .background(Color.red.opacity(0.7))
                                        .cornerRadius(8)
                                }
                                
                                Button(action: {
                                    workToAddToProject = record
                                    showProjectSelection = true
                                }) {
                                    Text("Add to Project")
                                        .font(.custom("Montserrat-Medium", size: screenWidth * 0.035))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, screenWidth * 0.04)
                                        .padding(.vertical, screenHeight * 0.008)
                                        .background(Color.red.opacity(0.7))
                                        .cornerRadius(8)
                                }
                                .padding(.trailing, screenWidth * 0.05)
                            }
                        }
                    }
                }
                .padding(.top, screenHeight * 0.03)
                .padding(.bottom, screenHeight * 0.12)
            }
            .alert("Delete Record", isPresented: $showDeleteAlert) {
                Button("Cancel", role: .cancel) {
                    workToDelete = nil
                }
                Button("Delete", role: .destructive) {
                    if let work = workToDelete {
                        recordsManager.deleteRecord(work)
                        workToDelete = nil
                    }
                }
            } message: {
                Text("Are you sure you want to delete this record?")
            }
            
            if showProjectSelection {
                ZStack {
                    Color.black.opacity(0.7)
                        .ignoresSafeArea()
                        .onTapGesture {
                            showProjectSelection = false
                            workToAddToProject = nil
                        }
                    
                    ProjectSelectionViewForRecords(
                        projects: projectsManager.projects,
                        onSelect: { project in
                            if let work = workToAddToProject,
                               let projectIndex = projectsManager.projects.firstIndex(where: { $0.id == project.id }) {
                                var updatedProject = projectsManager.projects[projectIndex]
                                updatedProject.works.append(work)
                                projectsManager.updateProject(updatedProject)
                            }
                            showProjectSelection = false
                            workToAddToProject = nil
                        },
                        onDismiss: {
                            showProjectSelection = false
                            workToAddToProject = nil
                        }
                    )
                }
            }
        }
    }
}

struct ProjectSelectionViewForRecords: View {
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

struct RecordItemCard: View {
    let work: Work
    
    var body: some View {
        ZStack {
            Image("workFrame")
                .resizable()
                .scaledToFit()
                .frame(width: screenWidth * 0.95)
            
            HStack {
                Text(work.name)
                    .font(.custom("Montserrat-Medium", size: screenWidth * 0.04))
                    .foregroundColor(.white)
                    .padding(.leading, screenWidth * 0.05)
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: screenHeight * 0.005) {
                    Text("$\(String(format: "%.2f", work.cost))")
                        .font(.custom("Montserrat-Bold", size: screenWidth * 0.04))
                        .foregroundColor(.red)
                    
                    Text(work.formattedDate)
                        .font(.custom("Montserrat-Medium", size: screenWidth * 0.035))
                        .foregroundColor(Color("textColor"))
                }
                .padding(.trailing, screenWidth * 0.05)
            }
            .frame(width: screenWidth * 0.95)
        }
    }
}

#Preview {
    RecordsView()
}

