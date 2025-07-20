import SwiftUI

struct ContentView: View {
    @StateObject private var gameState = GameState()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                Color(red: 0.97, green: 0.97, blue: 0.97)
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    // Game container
                    GameView()
                        .environmentObject(gameState)
                        .frame(
                            width: min(geometry.size.width * 0.9, geometry.size.height * 1.8),
                            height: min(geometry.size.width * 0.9, geometry.size.height * 1.8) / 2
                        )
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 0)
                                .stroke(Color(red: 0.88, green: 0.88, blue: 0.88), lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 2)
                    
                    Spacer()
                }
            }
        }
        #if os(iOS)
        .statusBarHidden()
        .persistentSystemOverlays(.hidden)
        #endif
    }
}

#Preview {
    ContentView()
}