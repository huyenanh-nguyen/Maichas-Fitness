import SwiftUI

struct ContentView: View {
    @State private var selection: String? = "Home"
    
    var body: some View {
        NavigationSplitView {
            List {
                NavigationLink(destination: HomeView()) {
                    Label("Home", systemImage: "house")
                }
                NavigationLink(destination: TrainingPlanView()) {
                    Label("Training Notes", systemImage: "list.bullet")
                }
                NavigationLink(destination: StatisticsView()) {
                    Label("Workout Statistics", systemImage: "chart.bar")
                }
                NavigationLink(destination: NewExerciseView()) {
                    Label("New Exercise", systemImage: "plus.circle")
                }
                NavigationLink(destination: CalendarView()) {
                    Label("Calendar", systemImage: "calendar")
                }
            }
            .listStyle(SidebarListStyle())
            .navigationTitle("Dashboard")
        } detail: {
//            if open up the app, the contentview will show first (HomeView())
            HomeView()
        }
    }
}
