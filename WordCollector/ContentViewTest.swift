//
//  ContentView.swift
//  WordCollector
//
//  Created by ogulcan keskin on 16.10.2019.
//  Copyright © 2019 ogulcan keskin. All rights reserved.
//

import SwiftUI

struct ContentViewTest: View {
    
    @State private var newWord = ""
    
    
    var body: some View {
        NavigationView {
            HStack {
                List {
                      HStack {
                                    TextField("Add new word", text: $newWord)
                                   
                        HStack(spacing: 50) {
                                            ForEach (Level.allCases, id: \.self) { value in
                                                
                                                Text(value.rawValue)
                                                    .font(.system(size: 9))
                                                    .fontWeight(.black)
                                                    .frame(width: 15, height: 20)
                                                    .padding(4)
                                                    .background(Color.gray)
                                                    .clipShape(Circle())
                                                    .foregroundColor(.white)
                                                    .onTapGesture {
                                                        self.addAction(value)
                                                    }
                                                
                                                
                                        }
                                    }
                                }
                }
            }
        }
    }
    
    private func addAction(_ level: Level) {
            print(level)
        
    }
    
}



struct ContentView_Previews_Test: PreviewProvider {
    
    static var previews: some View {
        ContentViewTest()
    }
}



