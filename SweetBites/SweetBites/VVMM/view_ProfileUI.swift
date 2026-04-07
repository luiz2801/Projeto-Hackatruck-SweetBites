//
//  ProfileUIView.swift
//  SweetBites
//
//  Created by Turma01-9 on 01/04/26.
//

import SwiftUI

struct ProfileUIView: View {
    @StateObject private var viewModel = UserViewModel()
    var body: some View {
        NavigationStack{
            ZStack{
                Color.brancoFumaca
                    .ignoresSafeArea()
                ScrollView{
                    VStack(){
                        Text("teste")
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileUIView()
}
