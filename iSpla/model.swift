import Foundation

struct SplatoonData: Codable {
    let result: SplatoonResult
}

struct SplatoonResult: Codable {
    let regular: [Stage]
    let bankara_challenge: [Stage]
    let bankara_open: [Stage]
    let x: [Stage]
    let event: [EventStage]
    let fest: [FestStage]
    let fest_challenge: [FestStage]
}

struct Stage: Codable {
    let start_time: String
    let end_time: String
    let rule: Rule
    let stages: [SplatoonStage]
    let is_fest: Bool
}

struct Rule: Codable {
    let key: String
    let name: String
}

struct SplatoonStage: Codable {
    let id: Int
    let name: String
    let image: String
}

struct EventStage: Codable {
    let start_time: String
    let end_time: String
    let rule: Rule
    let stages: [SplatoonStage]
    let event: Event
    let is_fest: Bool
}

struct Event: Codable {
    let id: String
    let name: String
    let desc: String
}

struct FestStage: Codable {
    let start_time: String
    let end_time: String
    let rule: Rule?
    let stages: [SplatoonStage]?
    let is_fest: Bool
    let is_tricolor: Bool
    let tricolor_stage: [String]?
}

class SplatoonViewModel: ObservableObject {
    @Published var stages: [Stage] = []
    @Published var errorMessage: String = ""

    func fetchData() {
        guard let url = URL(string: "https://spla3.yuu26.com/api/schedule") else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Error: \(error.localizedDescription)"
                }
                return
            }

            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(SplatoonData.self, from: data)
                    DispatchQueue.main.async {
                        // ここで必要なデータにアクセスします
                        self.stages = decodedData.result.regular
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.errorMessage = "Error decoding JSON: \(error.localizedDescription)"
                    }
                }
            }
        }.resume()
    }
}
