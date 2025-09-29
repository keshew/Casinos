import SwiftUI

class BrickGameViewModel: ObservableObject {

    func createBrickGameScene(gameData: BrickGameData, level: Int) -> BrickGameSpriteKit {
        let scene = BrickGameSpriteKit(levels: level)
        scene.game  = gameData
        return scene
    }
}
import SwiftUI
import SpriteKit

struct BrickGameView: View {
    @StateObject var brickGameModel =  BrickGameViewModel()
    @StateObject var gameModel =  BrickGameData()
    @EnvironmentObject private var game: GameState
    
    var level: Int
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        if gameModel.isWin {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 3/255, green: 19/255, blue: 41/255),
                        Color(red: 3/255, green: 19/255, blue: 41/255),
                        Color(red: 40/255, green: 10/255, blue: 70/255)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    Spacer()
                    
                    Text("You win!")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundStyle(.white)
                    
                   
                    
                    Button(action: {
                        game.balance += 100
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        ZStack {
                            Color(red: 255/255, green: 188/255, blue: 6/255)
                                .frame(width: 250,
                                       height: 50)
                                .cornerRadius(6)
                            
                            Text("Menu")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundStyle(.white)
                        }
                    }
                    
                    Spacer()
                }
            }
        } else {
            ZStack {
                SpriteView(scene: brickGameModel.createBrickGameScene(gameData: gameModel, level: level))
                    .ignoresSafeArea()
                    .navigationBarBackButtonHidden(true)
                    
                if gameModel.isPause {
                    GeometryReader { geometry in
                        ZStack {
                            Color(.black)
                                .opacity(0.5)
                                .ignoresSafeArea()
                            
                            VStack {
                                ZStack {
                                    Rectangle()
                                        .fill(Color(red: 56/255, green: 45/255, blue: 81/255))
                                        .frame(width: 295, height: 330)
                                        .cornerRadius(20)
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color(red: 135/255, green: 120/255, blue: 174/255),
                                                        lineWidth: 4)
                                        }
                                    VStack(spacing: 30) {
                                        Text("Pause")
                                            .font(.system(size: 30, weight: .bold))
                                            .foregroundStyle(.white)
                                        
                                        
                                        Button(action: {
                                            presentationMode.wrappedValue.dismiss()
                                        }) {
                                            ZStack {
                                                Color(red: 255/255, green: 188/255, blue: 6/255)
                                                    .frame(width: 250,
                                                           height: 50)
                                                    .cornerRadius(6)
                                                
                                                Text("Menu")
                                                    .font(.system(size: 22, weight: .bold))
                                                    .foregroundStyle(.white)
                                            }
                                        }
                                        
                                        Button(action: {
                                            gameModel.isPause.toggle()
                                            gameModel.scene.isPaused = false
                                        }) {
                                            ZStack {
                                                Color(red: 255/255, green: 188/255, blue: 6/255)
                                                    .frame(width: 250,
                                                           height: 50)
                                                    .cornerRadius(6)
                                                
                                                Text("Back")
                                                    .font(.system(size: 22, weight: .bold))
                                                    .foregroundStyle(.white)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .navigationBarBackButtonHidden(true)
                }
            }
        }
    }
}

#Preview {
    BrickGameView(level: 1)
}

