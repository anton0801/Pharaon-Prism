import SwiftUI

struct SettingsView: View {
    
    @Binding var currentViewIndex: Int
    
    @State var musicInApp = UserDefaults.standard.bool(forKey: "musicInApp") {
        didSet {
            if vibrationInApp {
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
            }
            UserDefaults.standard.set(musicInApp, forKey: "musicInApp")
        }
    }
    @State var soundInApp = UserDefaults.standard.bool(forKey: "soundInApp") {
        didSet {
            if vibrationInApp {
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
            }
            UserDefaults.standard.set(soundInApp, forKey: "soundInApp")
        }
    }
    @State var vibrationInApp = UserDefaults.standard.bool(forKey: "vibrationInApp") {
        didSet {
            if vibrationInApp {
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
            }
            UserDefaults.standard.set(vibrationInApp, forKey: "vibrationInApp")
        }
    }
    
    var body: some View {
        VStack {
            Spacer().frame(height: 40)
            
            ZStack {
                Image("pharaon_2")
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            withAnimation(.linear(duration: 0.5)) {
                                musicInApp = !musicInApp
                            }
                        } label: {
                            Image("music_btn")
                                .opacity(musicInApp ? 1 : 0.6)
                        }
                        
                        Spacer()
                        Spacer()
                        
                        Button {
                            withAnimation(.linear(duration: 0.5)) {
                                soundInApp = !soundInApp
                            }
                        } label: {
                            Image("sound_btn")
                                .opacity(soundInApp ? 1 : 0.6)
                        }
                        
                        Spacer()
                    }
                    
                    Button {
                        withAnimation(.linear(duration: 0.5)) {
                            vibrationInApp = !vibrationInApp
                        }
                    } label: {
                        Image("vibration_btn")
                            .opacity(vibrationInApp ? 1 : 0.6)
                    }
                    .padding(.top, 24)
                }
                .offset(y: 180)
            }
            
            Spacer()
        }
    }
}

#Preview {
    SettingsView(currentViewIndex: .constant(1))
        .background(
            Image("app_bg")
                .resizable()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .ignoresSafeArea()
        )
}
