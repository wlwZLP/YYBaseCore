import Foundation

public final class BMDelegate<Input, Output> {
    private var block: ((Input) -> Output?)?
    public init() {}

    public func delegate<Target: AnyObject>(on target: Target, action: @escaping (Target, Input) -> Output) {
        block = { [weak target] in
            guard let target = target else { return nil }
            return action(target, $0)
        }
    }

    public func callAsFunction(_ input: Input) -> Output? {
        block?(input)
    }
}

