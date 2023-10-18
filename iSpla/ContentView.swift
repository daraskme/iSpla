import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel = SplatoonViewModel()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return formatter
    }()


    var body: some View {
        VStack {
            Text("Splatoon Stages")
                .font(.title)

            if !viewModel.errorMessage.isEmpty {
                Text(viewModel.errorMessage)
                    .foregroundColor(.red)
            }

            List(viewModel.stages, id: \.start_time) { stage in
                VStack(alignment: .leading) {
                    Text("開始: \(formatDate(dateString: stage.start_time))から")
                    
                    Text("終了: \(formatDate(dateString:stage.end_time))まで")
                    Text("\(stage.rule.name)")

                    ForEach(stage.stages, id: \.id) { splatoonStage in
                        Text("ステージ: \(splatoonStage.name)")
                        if let imageURL = URL(string: splatoonStage.image) {
                                URLImage(url: imageURL)
                        }
                    }
                }
                .padding()
            }
        }
        .onAppear {
            viewModel.fetchData()
        }
    }
        
    func formatDate(dateString: String) -> String {
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"

        if let date = inputDateFormatter.date(from: dateString) {
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.dateFormat = "yyyy年 MM月dd日 HH時"
            return outputDateFormatter.string(from: date)
        }

        return "Invalid Date"
    }
}

#Preview {
    ContentView()
}
