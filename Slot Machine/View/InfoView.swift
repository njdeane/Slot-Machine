//
//  InfoView.swift
//  Slot Machine
//
//  Created by Nic Deane on 3/10/21.
//

import SwiftUI

struct InfoView: View {
  
  @Environment(\.presentationMode) var presentationMode
  
    var body: some View {
      VStack(alignment: .center, spacing: 10) {
        LogoView()
        Spacer()
        Form{
          Section(header: Text("About Slot Machine")) {
            FormRowView(first: "Application", second: "Slot Machine")
            FormRowView(first: "Platforms", second: "iPhone, iPad, Mac")
            FormRowView(first: "Developer", second: "Pirates Inc")
            FormRowView(first: "Designer", second: "Captain Hook")
            FormRowView(first: "Music", second: "Dan Lebowitz")
            FormRowView(first: "Website", second: "getfucked.com")
            FormRowView(first: "Copyright", second: "© 2021 All rights reserved")
            FormRowView(first: "Version", second: "1.0.0")
          }
        }
        .font(.system(.body, design: .rounded))
      }
      .padding(.top, 40)
      .overlay(
        Button(action: {
          audioPlayer?.stop()
          self.presentationMode.wrappedValue.dismiss()
        }) {
          Image(systemName: "xmark.circle")
            .font(.title)
        }
          .padding(.top, 30)
          .padding(.trailing, 20)
          .accentColor(Color.secondary)
        ,alignment: .topTrailing
      )
      .onAppear {
        playSound(sound: "background-music", type: "mp3")
      }
    }
}

struct FormRowView: View {
  
  var first: String
  var second: String
  
  var body: some View {
    HStack {
      Text(first).foregroundColor(Color.gray)
      Spacer()
      Text(second)
    }
  }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}


