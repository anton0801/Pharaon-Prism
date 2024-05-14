import Foundation

class LevelsData: ObservableObject {
    
    @Published var unlockedLevels: [LevelItem] = []
    
    init() {
        obtainAllUnlockedLevels()
    }
    
    func obtainAllUnlockedLevels() {
        let levelsUnlocked = UserDefaults.standard.string(forKey: "unlocked_levels") ?? "level_1,"
        let leveLs = levelsUnlocked.components(separatedBy: ",").filter { !$0.isEmpty }
        for levelId in leveLs {
            unlockedLevels.append(allLevels.filter { $0.id == levelId }[0])
        }
    }
    
    func unlockNextLevel(currentLevel: LevelItem) -> LevelItem? {
        let nextLevelNum = currentLevel.num + 1
        if nextLevelNum <= allLevels.count {
            let nextLevelItem = allLevels.filter { $0.id == "level_\(nextLevelNum)" }[0]
            unlockedLevels.append(nextLevelItem)
            UserDefaults.standard.set(unlockedLevels.map { $0.id }.joined(separator: ","), forKey: "unlocked_levels")
            return nextLevelItem
        }
        return nil
    }
    
}
