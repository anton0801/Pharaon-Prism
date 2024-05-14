import SwiftUI

struct AppNavigationView: View {
    
    @State var currentViewIndex = 1
    @State var indicatorOffset: CGFloat = 0
    
    @State var hideNavigation = false
    
    var body: some View {
        VStack {
            Spacer()
            
            switch currentViewIndex {
            case 0:
                LevelsView(hideNavigation: $hideNavigation)
                    .transition(.slide)
                    .ignoresSafeArea()
            case 1:
                HomeView(currentViewIndex: $currentViewIndex)
                    .transition(.slide)
                    .padding(.top, 20)
            case 2:
                SettingsView(currentViewIndex: $currentViewIndex)
                    .transition(.slide)
                    .padding(.top, 20)
            default:
                EmptyView()
            }
            
            Spacer()
            
            if !hideNavigation {
                VStack {
                    HStack {
                        Spacer()
                        
                        Button {
                            withAnimation(.linear(duration: 0.3)) {
                                currentViewIndex = 0
                                indicatorOffset = -((UIScreen.main.bounds.width - 50) / 3)
                            }
                        } label: {
                            Image("levels_btn")
                                .resizable()
                                .frame(width: 70, height: 70)
                                .scaleEffect(currentViewIndex == 0 ? 1.2 : 1.0)
                        }
                        
                        Spacer()
                        
                        Button {
                            withAnimation(.linear(duration: 0.3)) {
                                currentViewIndex = 1
                                indicatorOffset = 0
                            }
                        } label: {
                            Image("home_btn")
                                .resizable()
                                .frame(width: 70, height: 70)
                                .scaleEffect(currentViewIndex == 1 ? 1.2 : 1.0)
                        }
                        
                        Spacer()
                        
                        Button {
                            withAnimation(.linear(duration: 0.3)) {
                                currentViewIndex = 2
                                indicatorOffset = (UIScreen.main.bounds.width - 50) / 3
                            }
                        } label: {
                            Image("settings_btn")
                                .resizable()
                                .frame(width: 70, height: 70)
                                .scaleEffect(currentViewIndex == 2 ? 1.2 : 1.0)
                        }
                        
                        Spacer()
                    }
                    
                    Image("indicator")
                        .padding(.top, 8)
                        .offset(x: indicatorOffset)
                }
                .padding(.bottom)
            }
        }
        .ignoresSafeArea()
        .background(
            Image("app_bg")
                .resizable()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .ignoresSafeArea()
        )
    }
}

#Preview {
    AppNavigationView()
}
