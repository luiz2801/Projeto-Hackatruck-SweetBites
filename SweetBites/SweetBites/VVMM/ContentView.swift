//
//  ContentView.swift
//  
//
//  Created by Turma01-9 on 01/04/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView{
            FeedUIView()
                .tabItem{
                    Text("Feed")
                    Image(systemName: "house")
                }
            AIChatUIView()
                .tabItem{
                    Text("IA CHAT")
                    Image(systemName: "bubble.circle.fill")
                }
            AddRecipeUIView()
                .tabItem{
                    Text("Novas Receitas")
                    Image(systemName: "receipt")
                }
            ProfileUIView()
                .tabItem{
                    Text("Perfil")
                    Image(systemName:  "person.crop.circle")
                }
        }
    }
}

#Preview {
    ContentView()
}
