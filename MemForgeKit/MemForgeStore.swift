import Foundation
import Combine

@MainActor
public final class MemForgeStore: ObservableObject {
    @Published public private(set) var values: [MemForgeValue]
    @Published public var status: String = "MemForgeKit ready"

    private let initialValues: [MemForgeValue]

    public init(values: [MemForgeValue]) {
        self.values = values
        self.initialValues = values
    }

    public func setValue(id: UUID, to newValue: Int) {
        guard let index = values.firstIndex(where: { $0.id == id }) else { return }
        values[index].value = newValue
        status = "Updated \(values[index].name) → \(newValue)"
    }

    public func setFrozen(id: UUID, frozen: Bool) {
        guard let index = values.firstIndex(where: { $0.id == id }) else { return }
        values[index].frozen = frozen
        status = frozen ? "Frozen \(values[index].name)" : "Unfrozen \(values[index].name)"
    }

    public func reset() {
        values = initialValues
        status = "Registered values reset"
    }

    public func mutateForDemo() {
        for index in values.indices where !values[index].frozen {
            switch values[index].name {
            case "Coins": values[index].value += 25
            case "Gems": values[index].value += 1
            case "Health": values[index].value = max(0, values[index].value - 5)
            case "Score": values[index].value += 100
            default: break
            }
        }
        status = "Game tick applied"
    }
}