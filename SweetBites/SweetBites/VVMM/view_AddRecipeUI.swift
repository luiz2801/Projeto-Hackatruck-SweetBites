//
//  AddRecipeUIView.swift
//  SweetBites
//
//  Created by Turma01-9 on 01/04/26.
//

import SwiftUI
import PhotosUI

struct AddRecipeUIView: View {
    @State private var nomeReceita: String = ""
    @State private var ingredientes: String = ""
    @State private var modoPreparo: String = ""
    @State private var categoriaDoce: Bool = false
    @State private var categoriaRefeicao: Bool = false
    @State private var categoriaLanche: Bool = false
    @State private var fotoSelecionada: PhotosPickerItem? = nil
    @State private var imagemReceita: Image? = nil
    var body: some View {
        ZStack{
            Color.brancoFumaca
                .ignoresSafeArea()
            
            ScrollView{
                VStack{
                    Text("Novas Receitas")
                        .font(.title)
                        .bold()
                        .padding(.bottom, 20)
                    
                    HStack(spacing: 20) {
                        PhotosPicker(
                            selection: $fotoSelecionada,
                            matching: .images,
                            photoLibrary: .shared()) {
                                ZStack {
                                    if let imagemReceita {
                                        imagemReceita
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 120, height: 120)
                                            .clipShape(Circle())
                                    } else {
                                        VStack(spacing: 8) {
                                            Image(systemName: "camera.fill")
                                                .font(.title)
                                            Text("Adicionar\nFoto")
                                                .font(.caption)
                                                .bold()
                                                .multilineTextAlignment(.center)
                                        }
                                        .frame(width: 120, height: 120)
                                        .background(Color.white)
                                        .clipShape(Circle())
                                    }
                                }
                                .foregroundColor(.pink)
                                .shadow(color: .gray.opacity(0.15), radius: 5, x: 0, y: 5)
                                .overlay(Circle().strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [6]))
                                    .foregroundColor(.pink.opacity(0.5))
                                )
                            }
                            .onChange(of: fotoSelecionada) {
                                Task {
                                    if let data = try? await fotoSelecionada?.loadTransferable(type: Data.self) {
                                        if let uiImage = UIImage(data: data) {
                                            imagemReceita = Image(uiImage: uiImage)
                                        }
                                    }
                                }
                            }
                        VStack(alignment: .leading, spacing: 8) {
                            Text("NOME DA RECEITA")
                                .font(.caption)
                                .bold()
                                .foregroundColor(.gray)
                            
                            TextField("Ex: Bolo de Cenoura", text: $nomeReceita)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(color: .gray.opacity(0.1), radius: 3)
                        }
                    }
                    .padding(.horizontal, 20)
                }
                VStack(alignment: .center, spacing: 8){
                    Text("Ingredientes")
                        .font(.caption)
                        .bold()
                        .foregroundStyle(.gray)
                    
                    TextEditor(text: $ingredientes)
                        .frame(minHeight: 120)
                        .padding(10)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: .gray.opacity(0.1), radius: 3)
                }
                .padding(.horizontal, 20)
                
                VStack(alignment: .center, spacing: 8){
                    Text("Modo de Preparo")
                        .font(.caption)
                        .bold()
                        .foregroundStyle(.gray)
                    
                    TextEditor(text: $modoPreparo)
                        .frame(minHeight: 120)
                        .padding(10)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: .gray.opacity(0.1), radius: 3)
                }
                .padding(.horizontal, 20)
                
                VStack(alignment: .center, spacing: 8){
                    Text("Categoria")
                        .font(.caption)
                        .bold()
                        .foregroundStyle(.gray)
                    
                    HStack(spacing: 12){
                        
                        CategoriaButton(titulo: "Doce", isSelected: $categoriaDoce)
                        
                        CategoriaButton(titulo: "Refeicao", isSelected: $categoriaRefeicao)
                        
                        CategoriaButton(titulo: "Lanche", isSelected: $categoriaLanche)
                        
                    }
                    
                    SaveRecipeButton(titulo: "Salvar"){
                        print("Receita Salva")
                    }
                }
                
                .padding(.vertical)
            }
        }
    }
}

#Preview {
    AddRecipeUIView()
}
