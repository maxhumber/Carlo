import SwiftUI
import Carlo

extension ContentView {
    @MainActor final class ViewModel: ObservableObject {
        @Published var game = CarloTicTacToe()
    }
}

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    let columns = Array.init(repeating: GridItem(.flexible()), count: 3)
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 0) {
            ForEach(0..<9) { _ in
                Rectangle()
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
