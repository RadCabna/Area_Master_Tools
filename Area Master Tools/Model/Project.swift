import Foundation

struct Project: Identifiable, Codable {
    let id: UUID
    var name: String
    var works: [Work]
    var tools: [Tool]
    
    var worksCount: Int {
        works.count
    }
    
    var budget: Double {
        works.reduce(0) { $0 + $1.cost }
    }
    
    init(id: UUID = UUID(), name: String, works: [Work] = [], tools: [Tool] = []) {
        self.id = id
        self.name = name
        self.works = works
        self.tools = tools
    }
}

