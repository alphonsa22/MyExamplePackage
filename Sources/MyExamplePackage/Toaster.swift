//
//  File.swift
//  
//
//  Created by Alphonsa Varghese on 21/06/23.
//

import SwiftUI

struct ToasterView: View {
    let message: String
       
       var body: some View {
           Text(message)
               .foregroundColor(.white)
               .padding()
               .background(Color.black.opacity(0.7))
               .cornerRadius(10)
               .onAppear {
                   DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                       // Remove the toast view after 2 seconds
                       NotificationCenter.default.post(name: NSNotification.Name("DismissToast"), object: nil)
                   }
               }
       }
}

