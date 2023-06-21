//
//  ContentView.swift
//  Example
//
//  Created by Alphonsa Varghese on 21/06/23.
//

import SwiftUI
import MyExamplePackage

struct ContentView: View {
    var body: some View {
        VStack {
                  Button("Show Log") {
                      Logger.log("This is a debug message", level: .debug)
                  }
              }
              .padding()
              .onAppear {
                  Logger.logLevel = .debug
              }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
