import Combine

class DeviceListViewModel: ObservableObject {
    private let bleService: BLEService
    private var subscriptions = Set<AnyCancellable>()
    
    init(bleService: BLEService) {
        self.bleService = bleService
        
        bleService.$devices.assign(to: \.devices, on: self).store(in: &subscriptions)
    }
    
    @Published var devices = [Device]()
}
