
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
                        Text("Stage ID: \(splatoonStage.id)")
                        Text("Stage Name: \(splatoonStage.name)")
                        Text("Stage Image: \(splatoonStage.image)")
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
