//
//  ProfileUIView.swift
//  SweetBites
//
//  Created by Turma01-9 on 01/04/26.
//

import SwiftUI

struct ProfileUIView: View {
    
    @StateObject private var userViewModel = UserViewModel()
    @StateObject private var recipesViewModel = RecipesViewModel()
    
    
    // MARK: - Mock das receitas do Chef
    // Atualizado com os IDs e nomes das receitas que você enviou
    @State private var minhasReceitas: [Recipes] = []
    
    
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.brancoFumaca
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        // Título do Perfil
                        VStack(alignment: .center) {
                            Text("Meu Perfil")
                                .font(.headline)
                                .foregroundColor(.gray)
                            
                            Text("SweetBites")
                                .font(.title)
                                .bold()
                                .foregroundColor(.pink)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 10)
                        
                        // MARK: - Área do Usuário (Chef)
                        HStack(alignment: .top, spacing: 15) {
                            
                            // Imagem usando o seed do Chef para o DiceBear (ou uma local)
                            AsyncImage(url: URL(string: "https://api.dicebear.com/7.x/avataaars/svg?seed=Chef")) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 6) {
                                // Se o banco estiver vazio, mostramos o Chef como padrão para o teste
                                let nomeExibicao = userViewModel.users.first?.user_name ?? "Chef"
                                let bioExibicao = userViewModel.users.first?.user_description ?? "Criador das receitas brutais e clássicas do SweetBites."
                                
                                Text(nomeExibicao)
                                    .font(.title2)
                                    .bold()
                                
                                Text(bioExibicao)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.leading)
                            }
                            .padding(.top, 5)
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        Divider()
                            .padding(.vertical, 10)
                        
                        // MARK: - Listagem de Receitas
                        HStack {
                            Text("Minhas Receitas")
                                .font(.title3)
                                .bold()
                            
                            Spacer()
                            
                            NavigationLink(destination: Text("AddRecipeUIView")) { // Substituir pelo seu destino real
                                HStack {
                                    Image(systemName: "plus")
                                    Text("Nova")
                                }
                                .font(.subheadline)
                                .bold()
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.pink)
                                .cornerRadius(15)
                            }
                        }
                        .padding(.horizontal)
                        
                        if minhasReceitas.isEmpty {
                            VStack(alignment: .center, spacing: 10) {
                                Image(systemName: "text.book.closed")
                                    .font(.largeTitle)
                                    .foregroundColor(.gray.opacity(0.5))
                                
                                Text("Você ainda não adicionou nenhuma receita.")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            
                            .frame(maxWidth: .infinity)
                            .padding(.top, 20)
                            
                        } else {
                            ForEach(minhasReceitas) { receita in
                                // Ajuste para o nome da sua view de detalhes
                                NavigationLink(destination: Text("Detalhe da \(receita.recipe_name ?? "")")) {
                                    HStack(alignment: .top, spacing: 15) {
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(width: 80, height: 80)
                                            .cornerRadius(10)
                                            .overlay(
                                                Group {
                                                    if let urlStr = receita.recipe_image_url, let url = URL(string: urlStr) {
                                                        AsyncImage(url: url) { img in img.resizable().scaledToFill() } placeholder: { ProgressView() }
                                                    } else {
                                                        Image(systemName: "photo").foregroundColor(.gray)
                                                    }
                                                }
                                            )
                                            .clipped()
                                        
                                        VStack(alignment: .leading, spacing: 5) {
                                            Text(receita.recipe_name ?? "Sem nome")
                                                .font(.headline)
                                                .foregroundColor(.primary)
                                                .multilineTextAlignment(.leading)
                                            
                                            Text(receita.recipe_description ?? "Sem descrição")
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                                .lineLimit(2)
                                                .multilineTextAlignment(.leading)
                                        }
                                        Spacer()
                                    }
                                    .padding(.horizontal)
                                    .padding(.bottom, 10)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    .padding(.bottom, 30)
                }
            }
        }
        .onAppear {
                    userViewModel.fetch()
                    // Inicia a busca das receitas no Node-RED
                    recipesViewModel.fetch()
                }
                // Faz a atribuição correta sempre que o ViewModel for atualizado
                .onReceive(recipesViewModel.$recipes) { novasReceitas in
                    self.minhasReceitas = novasReceitas
                }
    }
}




#Preview {
    ProfileUIView()
}
