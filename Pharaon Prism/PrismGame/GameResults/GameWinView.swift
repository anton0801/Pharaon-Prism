import SwiftUI

struct GameWinView: View {
    
    @Binding var goToGame: Bool
    
    var restartAction: (() -> Void)
    var nextLevelAction: (() -> Void)
    
    var body: some View {
        VStack {
            Spacer().frame(height: 100)
            Text("YOU WIN!")
                .font(.custom("KumarOne-Regular", size: 42))
                .foregroundColor(.white)
            Image("game_result_icon")
            
            Spacer()
            
            HStack {
                Spacer()
                Button {
                    withAnimation {
                        goToGame = false
                    }
                } label: {
                    Image("home_btn")
                }
                Spacer()
                
                Button {
                    restartAction()
                } label: {
                    Image("restart_btn")
                }
                Spacer()
                
                Button {
                    nextLevelAction()
                } label: {
                    Image("next_level_btn")
                }
                
                Spacer()
            }
            
            Image("pharaon_1")
                .offset(y: 40)
        }
        .preferredColorScheme(.dark)
        .background(
          Image("app_bg")
              .resizable()
              .opacity(0.3)
              .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
              .ignoresSafeArea()
        )
    }
}

#Preview {
    GameWinView(goToGame: .constant(true), restartAction: { }, nextLevelAction: { })
}
