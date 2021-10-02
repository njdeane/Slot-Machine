//
//  ContentView.swift
//  Slot Machine
//
//  Created by Nic Deane on 2/10/21.
//

import SwiftUI

struct ContentView: View {
  
  
  
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
            
            Text("100")
              .scoreNumberStyle()
              .modifier(ScoreNumberModifier())
          }
          .modifier(ScoreContainerModifier())
          
          Spacer()
          
          HStack {
            Text("200")
              .scoreNumberStyle()
              .modifier(ScoreNumberModifier())
            
            Text("High\nScore".uppercased())
              .scoreLabelStyle()
              .multilineTextAlignment(.leading)
          }
          .modifier(ScoreContainerModifier())
        }
        
        // SLOT MACHINE
        
        // FOOTER
        Spacer()
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
          print("info")
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
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
