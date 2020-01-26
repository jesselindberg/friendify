class HomeViewModel {
    let bleService: BLEService
    
    init(bleService: BLEService) {
        self.bleService = bleService
    }
    
    func startButtonPressed() {
        bleService.start()
    }
    
    func helloWorldButtonPressed() {
        print("Hello world!")
    }
}
