//
//  ContentView.swift
//  ComposeView
//
//  Created by Gabriel Rodrigues on 20/02/23.
//

import SwiftUI

let lorem = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries."

class SuggestionStore: ObservableObject {
    
    @Published var suggestions = [String]()
    
    init() {
        self.suggestions = [""]
    }
    
    func replace(_ newSuggestions: [String]) {
        DispatchQueue.main.async {
            self.suggestions = newSuggestions
        }
    }
}

class SuggestionsReceiver {
    
    let suggestionStore: SuggestionStore
    
    init(suggestionStore: SuggestionStore) {
        self.suggestionStore = suggestionStore
        startUpdate()
    }
    
    func startUpdate() {
        var allPrevious = ""
        var allSplit = lorem.split(separator: " ")
        var index = 0
        
        Timer.scheduledTimer(withTimeInterval: TimeInterval(0.05), repeats: true, block: {
            _ in
            index = (index % allSplit.count) + 1 //To avoid acessing unexisting address
            let filtered = allSplit[0..<index].map {String($0)}
            let appended = filtered.reduce(String(), { prev, cur in return prev + " " + cur })
            self.suggestionStore.replace([appended])
            print(appended)
        })
    }
}

class Coordinator {
    
    static func createView() -> ContentView {
        let suggestionStore = SuggestionStore()
        let suggestionReceiver = SuggestionsReceiver(suggestionStore: suggestionStore)
        return ContentView(suggestionsStore: suggestionStore)
    }
}

struct ContentView: View {
    
    @ObservedObject var suggestionsStore: SuggestionStore
    
    var body: some View {
        VStack {
            ComposeSuggestionButton(suggestion: suggestionsStore.suggestions.first!)
        }
    }
}

struct ComposeSuggestionButton: View {
    
    var suggestion: String
    
    var formattedSuggestion: String {
        return suggestion.replacingOccurrences(of: "\n", with: " ↵ ")
    }
    
    var body: some View {
        Button(action: {}) {
            ScrollView(.horizontal) {
                Text(formattedSuggestion)
                    .lineLimit(1)
                    .textSelection(.enabled)
                    .font(.callout)
            }.padding(6.0)
        }
        .frame(minHeight: 32)
        .foregroundColor(.black)
        .cornerRadius(8)
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView(suggestionsStore: SuggestionStore())
    }
}
