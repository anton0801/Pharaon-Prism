import SwiftUI

struct LevelsView: View {
    
    @Binding var hideNavigation: Bool
    
    @State var levelsData = LevelsData()
    
    @State var goToGame = false
    @State var currentLevel: LevelItem? = nil
    
    var body: some View {
        if goToGame {
            PrismGameView(goToGame: $goToGame, currentLevel: currentLevel!)
                .ignoresSafeArea()
                .environmentObject(levelsData)
        } else {
            VStack {
                LazyVGrid(columns: [
                    GridItem(.flexible(minimum: 70), spacing: 0),
                    GridItem(.flexible(minimum: 70), spacing: 0),
                    GridItem(.flexible(minimum: 70), spacing: 0),
                    GridItem(.flexible(minimum: 70), spacing: 0)
                ], spacing: 0) {
                    ForEach(allLevels, id: \.id) { levelItem in
                        ZStack {
                            Image("level_bg")
                            if levelsData.unlockedLevels.contains(where: { $0.id == levelItem.id }) {
                                Button {
                                    hideNavigation = true
                                    self.currentLevel = levelItem
                                    withAnimation {
                                        goToGame = true
                                    }
                                } label: {
                                    Text("\(levelItem.num)")
                                        .font(.custom("KumarOne-Regular", size: 42))
                                        .foregroundColor(.white)
                                        .padding(.top, 12)
                                }
                            } else {
                                Image("ic_lock")
                            }
                        }
                        .frame(width: 70, height: 70)
                        .padding(.top, 12)
                    }
                }
                .padding()
            }
            .onAppear {
                hideNavigation = false
            }
        }
    }
}

#Preview {
    VStack {
        LevelsView(hideNavigation: .constant(false))
    }
    .background(
        Image("app_bg")
            .resizable()
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .ignoresSafeArea()
    )
        
}
