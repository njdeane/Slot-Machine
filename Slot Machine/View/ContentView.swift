//
//  ContentView.swift
//  Slot Machine
//
//  Created by Nic Deane on 2/10/21.
//

import SwiftUI

struct ContentView: View {
  
  let symbols = ["gfx-bell", "gfx-cherry", "gfx-coin", "gfx-grape", "gfx-seven", "gfx-strawberry"]
  
  @State private var highscore: Int = UserDefaults.standard.integer(forKey: "HighScore")
  @State private var coins: Int = 100
  @State private var betAmount: Int = 10
  @State private var reels: Array = [0,1,2]
  @State private var showingInfoView: Bool = false
  @State private var isBet10: Bool = true
  @State private var isBet20: Bool = false
  @State private var showingModal: Bool = false

  func spinReels() {
    reels = reels.map({ _ in
      Int.random(in: 0...symbols.count - 1)
    })
  }
  
  func checkWinning() {
    if reels[0] == reels[1] && reels[1] == reels[2] {
      playerWins()
      if coins > highscore {
        newHighScore()
      }
    } else {
      playerLoses()
    }
  }
  
  func playerWins() {
    coins = coins + (betAmount * 10)
  }
  
  func newHighScore() {
    highscore = coins
    UserDefaults.standard.set(highscore, forKey: "HighScore")
  }
  
  func playerLoses() {
    coins -= betAmount
  }
  
  func activateBet20() {
    betAmount = 20
  }
  
  func activateBet10() {
    betAmount = 10
  }
  
  func isGameOver() {
    if coins <= 0 {
      showingModal = true
    }
  }
  
  func resetGame() {
    UserDefaults.standard.set(0, forKey: "HighScore")
    highscore = 0
    coins = 100
    activateBet10()
  }
  
  
  var body: some View {
    ZStack {
      // BACKGROUND
      LinearGradient(gradient: Gradient(colors: [Color("ColorPink"), Color("ColorPurple")]), startPoint: .top, endPoint: .bottom)
        .edgesIgnoringSafeArea(.all)
      
      // INTERFACE
      VStack(alignment: .center, spacing: 5) { 
        // HEADER
        LogoView()
        
        Spacer()
        
        // SCORE
        HStack {
          HStack {
            Text("Your\nCoins".uppercased())
              .scoreLabelStyle()
              .multilineTextAlignment(.trailing)
            
            Text("\(coins)")
              .scoreNumberStyle()
              .modifier(ScoreNumberModifier())
          }
          .modifier(ScoreContainerModifier())
          
          Spacer()
          
          HStack {
            Text("\(highscore)")
              .scoreNumberStyle()
              .modifier(ScoreNumberModifier())
            
            Text("High\nScore".uppercased())
              .scoreLabelStyle()
              .multilineTextAlignment(.leading)
          }
          .modifier(ScoreContainerModifier())
        }
        
        // SLOT MACHINE
        VStack(alignment: .center, spacing: 0) {
          // Reel 1
          ZStack {
            ReelView()
            Image(symbols[reels[0]])
              .resizable()
              .modifier(ImageModifier())
          }
          
          HStack(alignment: .center, spacing: 0) {
            // Reel 2
            ZStack {
              ReelView()
              Image(symbols[reels[1]])
                .resizable()
                .modifier(ImageModifier())
            }
            
            Spacer()
            
            // Reel 3
            ZStack {
              ReelView()
              Image(symbols[reels[2]])
                .resizable()
                .modifier(ImageModifier())
            }
          }
          .frame(maxWidth: 500)
          
         
          
          // Reel 4
          
          // Spin Button
          Button(action: {
            self.spinReels()
            self.checkWinning()
            self.isGameOver()
          }) {
            Image("gfx-spin")
              .renderingMode(.original)
              .resizable()
              .modifier(ImageModifier())
          }
          
        } //: Slot
        .layoutPriority(2)
        
        // FOOTER
        Spacer()
        
        HStack {
          HStack(alignment: .center, spacing: 10) {
            Button(action: {
              activateBet20()
              isBet20 = true
              isBet10 = false
            }) {
              Text("20")
                .fontWeight(.heavy)
                .foregroundColor(isBet20 ? Color("ColorYellow") : Color.white)
                .modifier(BetNumberModifier())
            }
            .modifier(BetCapsuleModifier())
            
            
            Image("gfx-casino-chips")
              .resizable()
              .opacity(isBet20 ? 1 : 0)
              .modifier(CasinoChipsModifier())
          }
          
          HStack(alignment: .center, spacing: 10) {
            Image("gfx-casino-chips")
              .resizable()
              .opacity(isBet10 ? 1 : 0)
              .modifier(CasinoChipsModifier())
            
            Button(action: {
              activateBet10()
              isBet10 = true
              isBet20 = false
            }) {
              Text("10")
                .fontWeight(.heavy)
                .foregroundColor(isBet10 ? Color("ColorYellow") : Color.white)
                .modifier(BetNumberModifier())
            }
            .modifier(BetCapsuleModifier())
          }
        }
        
      }
      // BUTTONS
      .overlay(
        Button(action: {
          self.resetGame()
        }) {
          Image(systemName: "arrow.2.circlepath.circle")
        }
          .modifier(ButtonModifier()),
        alignment: .topLeading
      )
      .overlay(
        Button(action: {
          self.showingInfoView = true
        }) {
          Image(systemName: "info.circle")
        }
          .modifier(ButtonModifier()),
        alignment: .topTrailing
      )
      .padding()
      .frame(maxWidth: 720)
      .blur(radius: $showingModal.wrappedValue ? 5 : 0, opaque: false)
      
      // POPUP
      if $showingModal.wrappedValue {
        ZStack {
          Color("ColorTransparentBlack").edgesIgnoringSafeArea(.all) // this view prevents user tappnig on the blurred area from working
          
          VStack(spacing: 0) {
            Text("GAME OVER")
              .font(.system(.title, design: .rounded))
              .fontWeight(.heavy)
              .padding()
              .frame(minWidth: 0, maxWidth: .infinity)
              .background(Color("ColorPink"))
              .foregroundColor(Color.white)
            
            Spacer()
            
            VStack(alignment: .center, spacing: 16) {
              Image("gfx-seven-reel")
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 72)
              
              Text("Bad luck! You lost all of the coins. \nLet's play again!")
                .font(.system(.body, design: .rounded))
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .foregroundColor(Color.gray)
                .layoutPriority(1)
              
              Button(action: {
                self.showingModal = false
                self.coins = 100
              }) {
                Text("New Game".uppercased())
                  .font(.system(.body, design: .rounded))
                  .fontWeight(.semibold)
                  .accentColor(Color("ColorPink"))
                  .padding(.horizontal, 12)
                  .padding(.vertical, 8)
                  .frame(minWidth: 128)
                  .background(
                    Capsule()
                      .stroke(lineWidth: 1.75)
                      .foregroundColor(Color("ColorPink"))
                  )
              }

            }
            
            Spacer()
          }
          .frame(minWidth: 280, idealWidth: 280, maxWidth: 320, minHeight: 260, idealHeight: 280, maxHeight: 320, alignment: .center)
          .background(Color.white)
          .cornerRadius(20)
          .shadow(color: Color("ColorTransparentBlack"), radius: 6, x: 0, y: 8)
        }
      }
      
      
    } //: Zstack
    .sheet(isPresented: $showingInfoView) {
      InfoView()
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
