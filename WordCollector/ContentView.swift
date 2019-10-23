//
//  ContentView.swift
//  WordCollector
//
//  Created by ogulcan keskin on 16.10.2019.
//  Copyright © 2019 ogulcan keskin. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var mobileSession: Session

    @State private var filterLayout = 0
    @State private var filterLevel = 3
    @State private var isEdit = false
    @State private var newWord = ""
    @Environment(\.editMode) var mode
    static var levels: [String] = {
        var temp = Level.allCases.map{ $0.rawValue }
        temp.append("A")
        return temp
    }()
    
    var gridData: [[Word]]!
    
    var body: some View {
        NavigationView {
            VStack {
                
                HStack {
                    Spacer()
                    Spacer()
                    Picker("", selection: $filterLayout) {
                        Text("V").tag(0)
                        Text("H").tag(1)
                    }.pickerStyle(SegmentedPickerStyle())
                    Spacer()
                    Spacer()
                }
                
                HStack {
                    Picker("", selection: $filterLevel) {
                        ForEach(0 ..< Self.levels.count) { index in
                            Text(Self.levels[index])
                                .tag(index)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(10)
                    
                    Spacer()
                }
                
                
                if filterLayout == 0 {
                    List {
                        ForEach(mobileSession.words) { word in
                            WordRow(word: word)
                        }.onDelete(perform: deleteWord)
                        if isEdit {
                            TextField("Beni editle", text: $newWord)
                        }
                    }
                    .navigationBarTitle("Words")
                    .navigationBarItems(trailing: EditButton())
                }
//                else {
//                    ScrollView {
//                        VStack {
//                            ForEach(0 ..< gridData) { index in
//                                HStack {
//                                    Spacer()
//                                    WordColumn(word: gridData[index][0])
//                                    Spacer()
//                                    Spacer()
//                                    Spacer()
//                                    WordColumn(word: gridData[index][1])
//                                    Spacer()
//                                }
//                            }.onDelete(perform: deleteWord)
//                                .padding(20)
//                        }
//                    }
//                    .padding(20)
//                    .navigationBarTitle("Words")
//                    .navigationBarItems(trailing: EditButton())
//
//                }
            }
        }
    }
    
    func deleteWord(at offSets: IndexSet) {
        print("hello")
    }
}

struct WordColumn: View {
    
    let word: Word
    let enumList = Level.allCases
    
    var body: some View {
        
        VStack {
            Text(word.name)
            HStack {
                ForEach (enumList, id: \.self) { value in
                    Text(value.rawValue)
                        .font(.system(size: 9))
                        .fontWeight(.black)
                        .frame(width: self.calculateFont(value), height: 20)
                        .padding(4)
                        .background(value == self.word.level ? self.word.level.getColor() : Color.gray)
                        .clipShape(Circle())
                        .foregroundColor(.white)
                }
            }
        }
    }
    
    private func calculateFont(_ level: Level) -> CGFloat {
        switch level {
        case word.level:
            return 15
        default:
            return 9
        }
    }
}

struct WordRow: View {
    
    let word: Word
    let enumList = Level.allCases
    
    var body: some View {
        HStack {
            Text(word.name)
            Spacer()
            ForEach (enumList, id: \.self) { value in
                Text(value.rawValue)
                    .font(.system(size: 9))
                    .fontWeight(.black)
                    .frame(width: self.calculateFont(value), height: 20)
                    .padding(4)
                    .background(value == self.word.level ? self.word.level.getColor() : Color.gray)
                    .clipShape(Circle())
                    .foregroundColor(.white)
                
                
            }
        }
    }
    
    private func calculateFont(_ level: Level) -> CGFloat {
        switch level {
        case word.level:
            return 15
        default:
            return 9
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static let userSession = Session()
    static var previews: some View {
       
        ContentView().environmentObject(userSession)
    }
}


struct Word: Identifiable {
    let id = UUID()
    let name: String
    let level: Level
    
//    init(name: String, level: Level) {
//        self.name = name
//        self.level = level
//    }
}

enum Level: String, CaseIterable {
    case easy = "E"
    case medium = "M"
    case hard = "H"
    case neverHeard = "X"
}

extension Level {
    func getColor() -> Color {
        switch self {
        case .easy:
            return .blue
        case .medium:
            return .purple
        case .hard:
            return .black
        case .neverHeard:
            return .red
        }
    }
}


#if DEBUG
let testWords: [Word] = [Word(name: "Abbrivate", level: .medium),
                        Word(name: "Segue", level: .easy),
                        Word(name: "Man", level: .neverHeard),
                        Word(name: "Medium", level: .hard)]
#endif


extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            
            return Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
