import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = SplatoonViewModel()

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
                    Text("Start Time: \(stage.start_time)")
                    Text("End Time: \(stage.end_time)")
                    Text("Rule: \(stage.rule.name)")
                    Text("Is Fest: \(stage.is_fest ? "Yes" : "No")")

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
}

#Preview {
    ContentView()
}
