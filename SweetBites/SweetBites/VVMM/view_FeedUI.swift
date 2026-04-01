//
//  FeedUIView.swift
//  SweetBites
//
//  Created by Turma01-9 on 01/04/26.
//

import SwiftUI

struct FeedUIView: View {
    var body: some View {
        ZStack{
            Color.brancoFumaca
                .ignoresSafeArea()
            ScrollView{
                
                VStack{
                    Text("SweetBites")
                        .font(.title)
                        .bold()
                }
            }
        }
    }
}

#Preview {
    FeedUIView()
}
