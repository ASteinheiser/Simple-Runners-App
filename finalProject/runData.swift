import Foundation

class runData {
    private var runList: [run] = []
    
    init() {
    }
    
    internal func replace(r: run, i: Int) {
        runList[i] = r
    }
    
    internal func size() -> Int {
        return runList.count
    }
    
    internal func delete(i: Int) -> Void {
        runList.removeAtIndex(i)
    }
    
    internal func add(newRun: run) {
        runList.append(newRun)
    }
    
    internal func get(index: Int) -> run {
        return runList[index]
    }
    
    internal func loadSampleData() {
        var newRun = run(n:"Indian Steele Park", d:"This park is great for endurance training, as it features a long circular path and many hills for intense training.", a:"300 E Indian School Rd. Phoenix, AZ. 85012")
        runList.append(newRun)
        
        newRun = run(n:"Olympic Sculpture Park", d:"This run is a cold one for sure. If you travel to Seattle, you must run this trail for it's scenic value.", a:"2901 Western Ave. Seattle, WA. 98121")
        runList.append(newRun)
        
        newRun = run(n:"Granada Park", d:"This is a perfect park for beginner runners to start running at. Features a nice lake, a lot of trees, and crisp, clean air!", a:"6505 N 20th St. Phoenix, AZ. 85016")
        runList.append(newRun)
        
        newRun = run(n:"Highbridge Park", d:"This run will take you for some sprints down and back on the Highbridge. This is certainly an elevated place to run!", a:"2301 Amsterdam Ave. New York, NY. 10033")
        runList.append(newRun)
        
        newRun = run(n:"Camelback Mountain", d:"This is a difficult hike, and an even harded run. If you think you are up to a challenge, give it a shot!", a:"6131 E Cholla Ln. Paradise Valley, AZ. 85253")
        runList.append(newRun)
    }
    
    internal func getName(index: Int) -> String {
        return runList[index].name
    }
    
    internal func getDetail(index: Int) -> String {
        return runList[index].detail
    }
    
    internal func getAddress(index: Int) -> String {
        return runList[index].address
    }
    
    internal func saveRuns() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(runList, toFile: run.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save run...")
        }
    }
    
    internal func loadRuns() -> [run]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(run.ArchiveURL.path!) as? [run]
    }
}

class run: NSObject, NSCoding {
    private var name:String = ""
    private var detail:String = ""
    private var address:String = ""
    
    init (n: String, d: String, a: String) {
        name = n
        detail = d
        address = a
        
        super.init()
    }
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("runs")
    
    struct PropertyKey {
        static let nameKey = "name"
        static let detailKey = "detail"
        static let addressKey = "address"
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeObject(detail, forKey: PropertyKey.detailKey)
        aCoder.encodeObject(address, forKey: PropertyKey.addressKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        let detail = aDecoder.decodeObjectForKey(PropertyKey.detailKey) as! String
        let address = aDecoder.decodeObjectForKey(PropertyKey.addressKey) as! String
        
        self.init(n: name, d: detail, a: address)
    }
}
