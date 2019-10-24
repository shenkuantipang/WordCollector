//
//  ContentView.swift
//  WordCollector
//
//  Created by ogulcan keskin on 16.10.2019.
//  Copyright © 2019 ogulcan keskin. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State var words: [Word]
    @ObservedObject private var keyboard = KeyboardResponder()
    @State private var filterLayout = 0
    @State private var filterLevel = 3
    @State private var isEdit = false
    @State private var newWord = ""
    
    static var levels: [String] = {
        var temp = Level.allCases.map{ $0.rawValue }
        temp.append("A")
        return temp
    }()
    
    private var categorizedWord: [Word] {
        
        if filterLevel == Self.levels.endIndex - 1 {
            return words
        } else {
            return words.filter { (word) -> Bool in
                return word.level.rawValue == Self.levels[filterLevel]
            }
        }
    }
    
    private var layoutPicker: some View {
        HStack {
            Spacer(minLength: 100)
            Picker("", selection: $filterLayout) {
                Text("V").tag(0)
                Text("H").tag(1)
            }.pickerStyle(SegmentedPickerStyle())
            Spacer(minLength: 100)
        }
        
    }
    
    private var filterPicker: some View {
        HStack {
            Picker("", selection: $filterLevel) {
                ForEach(0 ..< Self.levels.count) { index in
                    Text(Self.levels[index])
                        .tag(index)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(10)
            
        }
    }
    var body: some View {
        NavigationView {
            VStack {
                
                HStack {
                    Spacer()
                    Toggle(isOn: $isEdit) {
                        Text("Add")
                        
                    }
                }.padding(10)
                
                
                layoutPicker
                filterPicker
                
                if filterLayout == 0 {
                    listLayout
                    
                } else {
                    gridLayout
                }
            }
        }
    }
    
    private var listLayout: some View {
        List {
            ForEach(categorizedWord) { word in
                WordRow(word: word)
            }
            if isEdit {
                HStack {
                    TextField("Add new word", text: $newWord)
                   
                        HStack{
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
        .padding(.bottom, keyboard.currentHeight + 60)
        .navigationBarTitle("Words")
    }
    
    private var gridLayout: some View {
        ScrollView {
            VStack {
                ForEach(categorizedWord.chunked(into: 2), id: \.self) { row in
                    HStack {
                        
                        ForEach(row) { temp in
                            
                            Spacer()
                            WordColumn(word: temp)
                            Spacer()
                            
                        }
                    }
                }
                .padding(20)
            }
        }
        .padding(20)
        .navigationBarTitle("Words")
    }
    
    
    
    private func addAction(_ level: Level) {
        if !newWord.isEmpty {
            words.append(Word(name: newWord, level: level))
            isEdit = false
            newWord = ""
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
                    Text(value.rawValue) .font(.system(size: 9)).fontWeight(.black).frame(width: self.calculateFont(value), height: 20).padding(4).background(value == self.word.level ? self.word.level.getColor() : Color.gray).clipShape(Circle()).foregroundColor(.white)
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
    
    static var previews: some View {
        ContentView(words: testWords)
    }
}


struct Word: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let level: Level
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
                         Word(name: "Culdesac", level: .neverHeard),
                         Word(name: "Medium", level: .hard)]
#endif


extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            
            return Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
