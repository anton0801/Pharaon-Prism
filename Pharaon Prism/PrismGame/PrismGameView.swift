import SwiftUI
import SpriteKit
import AVFoundation

struct PrismGameView: View {
    
    @Binding var goToGame: Bool
    @EnvironmentObject var levelsData: LevelsData
    
    var currentLevel: LevelItem
    @State var currentLevelInPresent: LevelItem!
    
    @State var showWin = false
    @State var showLose = false
    @State var setFirstLevel = false
    
    @State var backMusicPlayer: AVPlayer!
    
    @State var prismGameScene: PrismGameScene = PrismGameScene()
    
    var body: some View {
        VStack {
            if showWin {
                GameWinView(goToGame: $goToGame, restartAction: {
                    prismGameScene = PrismGameScene()
                    prismGameScene.level = currentLevelInPresent
                    withAnimation {
                        showWin = false
                        showLose = false
                    }
                }, nextLevelAction: {
                    let nextLevelItem = levelsData.unlockNextLevel(currentLevel: currentLevel)
                    prismGameScene = PrismGameScene()
                    prismGameScene.level = nextLevelItem
                    currentLevelInPresent = nextLevelItem
                    withAnimation {
                        showWin = false
                        showLose = false
                    }
                })
            } else if showLose {
                GameLoseVIew(goToGame: $goToGame, restartAction: {
                    prismGameScene = PrismGameScene()
                    prismGameScene.level = currentLevelInPresent
                    withAnimation {
                        showWin = false
                        showLose = false
                    }
                    withAnimation {
                        showWin = false
                        showLose = false
                    }
                })
            } else {
                SpriteView(scene: prismGameScene)
                    .ignoresSafeArea()
                    .onAppear {
                        if !setFirstLevel {
                            prismGameScene.level = currentLevel
                            currentLevelInPresent = currentLevel
                            setFirstLevel = true
                        }
                    }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .home)) { _ in
            withAnimation {
               goToGame = false
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .lose)) { _ in
            withAnimation {
               showLose = true
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .win)) { _ in
            withAnimation {
               showWin = true
            }
        }
        .onAppear {
            if UserDefaults.standard.bool(forKey: "musicInApp") {
                playBackMusic()
            }
        }
        .onDisappear {
            if UserDefaults.standard.bool(forKey: "musicInApp") {
                backMusicPlayer.pause()
                backMusicPlayer = nil
            }
        }
    }
    
    private func playBackMusic() {
        guard let url = Bundle.main.url(forResource: "back_music", withExtension: "mp3") else {
            return
        }
        backMusicPlayer = AVPlayer(url: url)
        backMusicPlayer.play()
    }
    
}

extension Notification.Name {
    static let home = Notification.Name("HOME")
    static let lose = Notification.Name("LOSE")
    static let win = Notification.Name("WIN")
}

#Preview {
    PrismGameView(goToGame: .constant(true), currentLevel: allLevels[0])
        .environmentObject(LevelsData())
}
