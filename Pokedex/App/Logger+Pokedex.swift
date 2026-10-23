import OSLog

extension Logger {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "com.seosh817.Pokedex"

    static let list = Logger(subsystem: subsystem, category: "List")
    static let detail = Logger(subsystem: subsystem, category: "Detail")
}
