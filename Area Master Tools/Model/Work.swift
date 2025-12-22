import Foundation

struct Work: Identifiable, Codable {
    let id: UUID
    var name: String
    var cost: Double
    var dateAdded: Date
    
    init(id: UUID = UUID(), name: String, cost: Double, dateAdded: Date = Date()) {
        self.id = id
        self.name = name
        self.cost = cost
        self.dateAdded = dateAdded
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: dateAdded)
    }
}

struct WorkType: Identifiable {
    let id: Int
    let title: String
    let imageName: String
}

let workTypes: [WorkType] = [
    WorkType(id: 1, title: "Plastering", imageName: "work_1"),
    WorkType(id: 2, title: "Puttying", imageName: "work_2"),
    WorkType(id: 3, title: "Primer", imageName: "work_3"),
    WorkType(id: 4, title: "Interior painting", imageName: "work_4"),
    WorkType(id: 5, title: "Facade painting", imageName: "work_5"),
    WorkType(id: 6, title: "Wallpapering", imageName: "work_6"),
    WorkType(id: 7, title: "Brickwork", imageName: "work_7"),
    WorkType(id: 8, title: "Tile laying", imageName: "work_8"),
    WorkType(id: 9, title: "Drywall", imageName: "work_9"),
    WorkType(id: 10, title: "Laminate flooring", imageName: "work_10"),
    WorkType(id: 11, title: "Screed", imageName: "work_11"),
    WorkType(id: 12, title: "Concrete", imageName: "work_12")
]

