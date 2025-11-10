//
//  StatisticView.swift
//  Yuen Fitness
//
//  Created by Huyen Anh Nguyen on 10.11.25.
//

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
