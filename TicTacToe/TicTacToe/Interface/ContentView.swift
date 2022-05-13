import SwiftUI
import Carlo

extension ContentView {
    @MainActor final class ViewModel: ObservableObject {
        @Published var game: CarloTicTacToe
        
        init() {
            var game = CarloTicTacToe()
            game = try! game.after(0)
            game = try! game.after(1)
            game = try! game.after(4)
            self.game = game
        }
        
        var squares: [String] {
            game.board.map { $0?.rawValue ?? "" }
        }
    }
}

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(viewModel.squares, id: \.self) { square in
//                Text(square)
//                ZStack {
//
                    Rectangle()
                        .opacity(0.2)
//                }
                .frame(width: 50, height: 50)
                .padding(10)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
