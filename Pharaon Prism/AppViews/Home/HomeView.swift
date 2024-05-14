import SwiftUI

struct HomeView: View {
    
    @Binding var currentViewIndex: Int
    
    var body: some View {
        VStack {
            Image("pharaon_1")
            
            Button {
                currentViewIndex = 0
            } label: {
                Image("play_btn")
            }
            .offset(y: -10)

            Spacer()
            
            Button {
                exit(0)
            } label: {
                Image("exit_app_btn")
            }
            
            Spacer()
        }
    }
}

#Preview {
    HomeView(currentViewIndex: .constant(1))
        .background(
            Image("app_bg")
                .resizable()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .ignoresSafeArea()
        )
}
