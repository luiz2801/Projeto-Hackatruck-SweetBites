import SwiftUI

struct SaveRecipeButton: View {
    var titulo: String
    var cor: Color = .pink
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(titulo)
                .font(.headline)
                .bold()
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(cor)
                .cornerRadius(15)
                .shadow(color: cor.opacity(0.3), radius: 5, x: 0, y: 3)
        }
        .padding(.horizontal, 20)
        .padding(.top, 30)
        .padding(.bottom, 40)
    }
}
