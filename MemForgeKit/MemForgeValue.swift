import Foundation

public struct MemForgeValue: Identifiable, Equatable {
    public let id: UUID
    public var name: String
    public var value: Int
    public var frozen: Bool

    public init(id: UUID = UUID(), name: String, value: Int, frozen: Bool = false) {
        self.id = id
        self.name = name
        self.value = value
        self.frozen = frozen
    }
}