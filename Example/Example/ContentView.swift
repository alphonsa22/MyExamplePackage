//
//  ContentView.swift
//  Example
//
//  Created by Alphonsa Varghese on 21/06/23.
//

import SwiftUI
import MyExamplePackage

struct ContentView: View {
    @State private var showToast: Bool = false
    @State private var toastMessage: String = ""

    var body: some View {
        VStack {
            Button("Show Log") {
                Logger.log("This is a debug message", level: .debug)
            }
        }
        .padding()
        .onAppear {
            Logger.logLevel = .debug
            NotificationCenter.default.addObserver(forName: NSNotification.Name("ShowToast"), object: nil, queue: nil) { notification in
                if let logMessage = notification.object as? String {
                    showToast = true
                    toastMessage = logMessage
                }
            }
            NotificationCenter.default.addObserver(forName: NSNotification.Name("DismissToast"), object: nil, queue: nil) { _ in
                showToast = false
                toastMessage = ""
            }
        }
        .overlay(
            Group {
                if showToast {
                    ToastView(message: toastMessage)
                        .transition(.opacity)
                        .animation(.easeInOut)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                NotificationCenter.default.post(name: NSNotification.Name("DismissToast"), object: nil)
                            }
                        }
                }
            }
        )
    }
}
