import Foundation

class RecordsManager: ObservableObject {
    static let shared = RecordsManager()
    
    @Published var records: [Work] = []
    
    private let recordsKey = "savedRecords"
    
    init() {
        loadRecords()
    }
    
    func addRecord(_ work: Work) {
        records.append(work)
        saveRecords()
    }
    
    func updateRecord(_ work: Work) {
        if let index = records.firstIndex(where: { $0.id == work.id }) {
            records[index] = work
            saveRecords()
        }
    }
    
    func deleteRecord(_ work: Work) {
        records.removeAll { $0.id == work.id }
        saveRecords()
    }
    
    private func saveRecords() {
        if let encoded = try? JSONEncoder().encode(records) {
            UserDefaults.standard.set(encoded, forKey: recordsKey)
        }
    }
    
    private func loadRecords() {
        if let data = UserDefaults.standard.data(forKey: recordsKey),
           let decoded = try? JSONDecoder().decode([Work].self, from: data) {
            records = decoded
        }
    }
}

