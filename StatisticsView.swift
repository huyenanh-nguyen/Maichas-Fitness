import SwiftUI
import Charts

struct StatisticsView: View {
    var body: some View {
        VStack {
            Text("Workout Statistics")
                .font(.title)
            Chart {
                BarMark(
                    x: .value("Month", "Jan"),
                    y: .value("Sessions", 12)
                )
                BarMark(
                    x: .value("Month", "Feb"),
                    y: .value("Sessions", 8)
                )
            }
            .frame(height: 200)
        }
        .padding()
    }
}
