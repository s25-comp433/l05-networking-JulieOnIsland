import SwiftUI

struct Score: Codable {
    var unc: Int
    var opponent: Int
}

struct Game: Codable, Identifiable {
    var team: String
    var id: Int
    var isHomeGame: Bool
    var score: Score
    var date: String
    var opponent: String
}

struct ContentView: View {
    @State private var games = [Game]()
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text("UNC Basketball")
                .font(.largeTitle)
                .bold()
                .padding(.leading)
            
            List(games) { game in
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(game.team) vs. \(game.opponent)")
                            .font(.title3)
                        Spacer()
                        Text("\(game.score.unc) - \(game.score.opponent)")
                            .font(.title3)
                    }
                    HStack {
                        Text("\(game.date)")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                        Spacer()
                        Text(game.isHomeGame ? "Home" : "Away")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                    }
                }
                .padding(.vertical, 5)
            }
        }
        .task {
            await loadData()
        }
  
 
           }
    
    func loadData() async {
        guard let url = URL(string: "https://api.samuelshi.com/uncbasketball") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            games = try decoder.decode([Game].self, from: data)
        } catch {
            print("Invalid data: \(error.localizedDescription)")
        }
    }
  
}
    

 


#Preview {
    ContentView()
}
