import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
                    .navigationTitle("Home")
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }
            
            NavigationStack {
                TrainingPlanView()
                    .navigationTitle("Notes")
            }
            .tabItem {
                Label("Notes", systemImage: "square.and.pencil")
            }
            
            NavigationStack {
                TemplateListView()
                    .navigationTitle("Templates")
            }
            .tabItem {
                Label("Templates", systemImage: "newspaper")
            }

            
            NavigationStack {
                StatisticsView()
                    .navigationTitle("Workout Statistics")
            }
            .tabItem {
                Label("Statistics", systemImage: "chart.pie")
            }
            
        }
    }
}
