//
//  AddRecipeUIView.swift
//  SweetBites
//
//  Created by Turma01-9 on 01/04/26.
//

import SwiftUI
import PhotosUI

struct AddRecipeUIView: View {
    // Variáveis de ambiente para fechar a tela após salvar
    @Environment(\.dismiss) var dismiss
    
    @State private var nomeReceita: String = ""
    @State private var ingredientes: String = ""
    @State private var modoPreparo: String = ""
    @State private var recipeDescription: String = ""
    @State private var urlImagemReceita: String = "" // NOVO: Para receber a URL em texto
    @State private var categoriaDoce: Bool = false
    @State private var categoriaRefeicao: Bool = false
    @State private var categoriaLanche: Bool = false
    
    // Mantive o PhotosPicker caso decida implementar upload para nuvem no futuro
    @State private var fotoSelecionada: PhotosPickerItem? = nil
    @State private var imagemReceita: Image? = nil
    
    @StateObject private var recipesViewModel = RecipesViewModel()
    
    // Controle de Alerta
    @State private var mostrarAlerta: Bool = false
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGray6) // Usando cor do sistema para substituir Color.brancoFumaca
                .ignoresSafeArea()
            
            ScrollView {
                VStack {
                    Text("Novas Receitas")
                        .font(.title)
                        .bold()
                        .padding(.bottom, 20)
                    
                    // MARK: - Seção de Imagem
                    // Se você não for usar o PhotosPicker por agora, pode focar no TextField da URL abaixo.
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
                                            Text("Adicionar\nFoto Local")
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
                            .onChange(of: fotoSelecionada) { _, newValue in
                                Task {
                                    if let data = try? await newValue?.loadTransferable(type: Data.self) {
                                        if let uiImage = UIImage(data: data) {
                                            imagemReceita = Image(uiImage: uiImage)
                                            // IMPORTANTE: Aqui você precisaria chamar uma função para fazer upload dessa 'data'
                                            // para o Firebase/S3 e jogar a string resultante em 'urlImagemReceita'.
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
                    
                    // MARK: - URL da Imagem (Solução temporária para o seu banco)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("URL DA IMAGEM (Link da Internet)")
                            .font(.caption)
                            .bold()
                            .foregroundColor(.gray)
                        
                        TextField("Ex: https://site.com/imagem.jpg", text: $urlImagemReceita)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: .gray.opacity(0.1), radius: 3)
                            .keyboardType(.URL)
                            .autocapitalization(.none)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                }
                
                // MARK: - Ingredientes
                VStack(alignment: .leading, spacing: 8) {
                    Text("Ingredientes (um por linha)")
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
                .padding(.top, 10)
                
                // MARK: - Modo de Preparo
                VStack(alignment: .leading, spacing: 8) {
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
                .padding(.top, 10)
                
                // MARK: - Descrição
                VStack(alignment: .leading, spacing: 8) {
                    Text("Descrição")
                        .font(.caption)
                        .bold()
                        .foregroundStyle(.gray)
                    
                    TextEditor(text: $recipeDescription)
                        .frame(minHeight: 120)
                        .padding(10)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: .gray.opacity(0.1), radius: 3)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                // MARK: - Categorias e Salvar
                VStack(alignment: .center, spacing: 8) {
                    Text("Categoria")
                        .font(.caption)
                        .bold()
                        .foregroundStyle(.gray)
                    
                    HStack(spacing: 12) {
                        // Presumindo que CategoriaButton é um componente seu, substitui por Toggle visualmente simples se der erro
                        CategoriaButton(titulo: "Doce", isSelected: $categoriaDoce)
                        CategoriaButton(titulo: "Refeição", isSelected: $categoriaRefeicao)
                        CategoriaButton(titulo: "Lanche", isSelected: $categoriaLanche)
                    }
                    .padding(.bottom, 20)
                    
                    Button(action: salvarNovaReceita) {
                        Text("Salvar Receita")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.pink)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    // Adicionando disable caso os campos principais estejam vazios
                    .disabled(nomeReceita.isEmpty || ingredientes.isEmpty || modoPreparo.isEmpty)
                    .opacity((nomeReceita.isEmpty || ingredientes.isEmpty || modoPreparo.isEmpty) ? 0.5 : 1.0)
                }
                .padding(.horizontal, 20)
                .padding(.vertical)
            }
        }
        .alert("Sucesso!", isPresented: $mostrarAlerta) {
            Button("OK") {
                dismiss() // Fecha a view e volta para a tela anterior
            }
        } message: {
            Text("A receita '\(nomeReceita)' foi salva com sucesso.")
        }
    }
    
    private func salvarNovaReceita() {
        // Separa os ingredientes por quebra de linha
        let arrayIngredientes = ingredientes.components(separatedBy: "\n").filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
        
        // Categorias
        var categoriasEscolhidas: [Int] = []
        if categoriaDoce { categoriasEscolhidas.append(1) }
        if categoriaRefeicao { categoriasEscolhidas.append(2) }
        if categoriaLanche { categoriasEscolhidas.append(3) }
        
        // Garante que se a URL estiver vazia, passamos nil para o backend não quebrar
        let urlFinal: String? = urlImagemReceita.isEmpty ? nil : urlImagemReceita
        
        // Objeto Recipe
        let novaReceita = Recipes(
            id: UUID().uuidString,
            rev: nil,
            recipe_name: nomeReceita,
            user_name: "Chef",
            recipe_image_url: urlFinal, // <-- Inserindo a URL ou nil aqui
            recipe_description: recipeDescription,
            ingredients: arrayIngredientes,
            preparation_method: modoPreparo,
            preparation_time: 40,
            category: categoriasEscolhidas,
            upvote: 0,
            downvote: 0,
            comments: [],
            save_counter: 0
        )
        
        // Dispara o POST
        recipesViewModel.post(recipe: novaReceita)
        
        // Mostra o alerta de sucesso
        mostrarAlerta = true
    }
}

// Criei um mock do seu botão apenas para o Preview compilar, você pode remover se já tiver no seu projeto.
struct CategoriaButton: View {
    var titulo: String
    @Binding var isSelected: Bool
    var body: some View {
        Button(action: { isSelected.toggle() }) {
            Text(titulo)
                .font(.caption)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(isSelected ? Color.pink : Color.gray.opacity(0.2))
                .foregroundColor(isSelected ? .white : .black)
                .cornerRadius(8)
        }
    }
}

#Preview {
    AddRecipeUIView()
}
