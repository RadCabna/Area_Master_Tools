import Foundation

enum ToolStatus: String, Codable, CaseIterable {
    case notSelected = "not selected"
    case onSite = "On site"
    case inRepair = "in repair"
    case lost = "lost"
}

struct Tool: Identifiable, Codable {
    let id: UUID
    var name: String
    var status: ToolStatus
    var projectId: UUID?
    
    init(id: UUID = UUID(), name: String, status: ToolStatus = .notSelected, projectId: UUID? = nil) {
        self.id = id
        self.name = name
        self.status = status
        self.projectId = projectId
    }
}

