import SwiftUI
import Charts

struct StatisticsView: View {
    @StateObject private var viewModel = StatisticsViewModel()
    
    var body: some View {
        VStack {
            Text("Session Statistics")
                .font(.title)
                .padding(.vertical)
            
            if viewModel.loading {
                Text("Loading...")
            } else if let error = viewModel.error {
                Text("Error: \(error)")
            } else if let stats = viewModel.statistics {
                // Statistics Box
                VStack(alignment: .leading, spacing: 8) {
                    Text("Total Game Sold: \(stats.totalGameSold)")
                    Text("Total Turnover: $\(stats.totalTurnover, specifier: "%.2f")")
                    Text("Total Owed to Sellers: $\(stats.totalOwedToSellers, specifier: "%.2f")")
                    Text("Total Margin: $\(stats.totalMargin, specifier: "%.2f")")
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .padding()
            }
            
            Button(action: {
                viewModel.refreshStatistics()
            }) {
                Text("Ask for a refresh")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
            
            Spacer()
        }
        .padding()
        .onAppear {
            viewModel.fetchStatistics()
        }
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
    }
}