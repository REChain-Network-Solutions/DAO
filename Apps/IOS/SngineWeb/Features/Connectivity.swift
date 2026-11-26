import Network

/// Reports whether the device has a working network path.
@MainActor
final class Connectivity {
    private let monitor = NWPathMonitor()
    private var onChange: ((Bool) -> Void)?
    private(set) var isOnline = true

    /// Calls `onChange` on the main actor whenever the connection goes up or down.
    func start(onChange: @escaping (Bool) -> Void) {
        self.onChange = onChange
        monitor.pathUpdateHandler = { [weak self] path in
            let online = path.status == .satisfied
            Task { @MainActor in self?.update(online) }
        }
        monitor.start(queue: DispatchQueue(label: "sngine.connectivity", qos: .utility))
    }

    private func update(_ online: Bool) {
        guard online != isOnline else { return }
        isOnline = online
        onChange?(online)
    }

    deinit {
        monitor.cancel()
    }
}
