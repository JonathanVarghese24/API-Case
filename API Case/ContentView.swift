//
//  ContentView.swift
//  API Case
//
//  Created by Jonathan Varghese on 3/13/24.
//

import SwiftUI

struct ContentView: View {
    @State private var facts = [String]()
    @State private var showingAlert = false
    var body: some View {
        NavigationView {
            List(facts, id: \.self) { fact in
                Text(fact)
            }
            .navigationTitle("Random Cat Facts")
            .toolbar {
                Button(action: {
                    Task {
                        await loadData()
                    }
                    
                }, label: {
                    Image(systemName: "arrow.clockwise")
                })
            }
        }
        .task {
            await loadData()
        }
        .alert(isPresented: $showingAlert) {
             Alert(title: Text("Loading Error"),
             message: Text("There was a problem loading the API Categories"),
                   dismissButton: .default(Text("OK")))
         }
     }
    
    func loadData() async {
        if let url = URL(string: "https://meowfacts.herokuapp.com/?count=20") {
            if let (data,_) = try? await URLSession.shared.data(from: url) {
                if let decodedResponse = try? JSONDecoder().decode(Facts.self, from: data) {
                    facts = decodedResponse.facts
                    return
                }
            }
        }
        showingAlert = true
    }
}
#Preview {
    ContentView()
}

struct Facts: Identifiable, Codable {
    var id = UUID()
    var facts: [String]
    
    enum CodingKeys: String, CodingKey {
        case facts = "data"
    }
}
