//
//  ContentView.swift
//  Slot Machine
//
//  Created by Nic Deane on 2/10/21.
//

import SwiftUI

struct ContentView: View {
  
  let symbols = ["gfx-bell", "gfx-cherry", "gfx-coin", "gfx-grape", "gfx-seven", "gfx-strawberry"]
  
  @State private var highscore: Int = 0
  @State private var coins: Int = 100
  @State private var betAmount: Int = 10
  @State private var reels: Array = [0,1,2]
  @State private var showingInfoView: Bool = false

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
  }
  
  func playerLoses() {
    coins -= betAmount
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
            self.spinReels() // why self?
            self.checkWinning()
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
              print("Bet 20 coins")
            }) {
              Text("20")
                .fontWeight(.heavy)
                .foregroundColor(Color.white)
                .modifier(BetNumberModifier())
            }
            .modifier(BetCapsuleModifier())
            
            
            Image("gfx-casino-chips")
              .resizable()
              .opacity(0)
              .modifier(CasinoChipsModifier())
          }
          
          HStack(alignment: .center, spacing: 10) {
            Image("gfx-casino-chips")
              .resizable()
              .opacity(1)
              .modifier(CasinoChipsModifier())
            
            Button(action: {
              print("Bet 10 coins")
            }) {
              Text("10")
                .fontWeight(.heavy)
                .foregroundColor(Color.yellow)
                .modifier(BetNumberModifier())
            }
            .modifier(BetCapsuleModifier())
          }
        }
        
      }
      // BUTTONS
      .overlay(
        Button(action: {
          print("Reset the game")
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
      
      // POPUP
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
