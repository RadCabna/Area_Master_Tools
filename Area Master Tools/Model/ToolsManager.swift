import Foundation

class ToolsManager: ObservableObject {
    static let shared = ToolsManager()
    
    @Published var tools: [Tool] = []
    
    private let toolsKey = "savedTools"
    
    init() {
        loadTools()
    }
    
    func addTool(_ tool: Tool) {
        tools.append(tool)
        saveTools()
    }
    
    func updateTool(_ tool: Tool) {
        if let index = tools.firstIndex(where: { $0.id == tool.id }) {
            tools[index] = tool
            saveTools()
        }
    }
    
    func deleteTool(_ tool: Tool) {
        tools.removeAll { $0.id == tool.id }
        saveTools()
    }
    
    private func saveTools() {
        if let encoded = try? JSONEncoder().encode(tools) {
            UserDefaults.standard.set(encoded, forKey: toolsKey)
        }
    }
    
    private func loadTools() {
        if let data = UserDefaults.standard.data(forKey: toolsKey),
           let decoded = try? JSONDecoder().decode([Tool].self, from: data) {
            tools = decoded
        }
    }
}




