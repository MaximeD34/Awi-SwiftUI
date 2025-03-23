import SwiftUI

struct SellerStatisticsView: View {
    let seller: Seller
    @State private var stats: SellerStats?
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    private let statisticsService = SellerStatisticsService()
    
    var body: some View {
        VStack {
            if isLoading {
                Spacer()
                ProgressView("Loading Statistics...")
                Spacer()
            } else if let errorMessage = errorMessage {
                Spacer()
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
                Button("Retry") {
                    loadStats()
                }
                Spacer()
            } else if let stats = stats {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // Seller Basic Information Card centered horizontally
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(stats.name)
                                    .font(.title)
                                    .bold()
                                if let email = stats.email {
                                    Text("Email: \(email)")
                                        .font(.subheadline)
                                }
                                if let tel = stats.tel {
                                    Text("Tel: \(tel)")
                                        .font(.subheadline)
                                }
                                if let billing = stats.billing_address {
                                    Text("Billing: \(billing)")
                                        .font(.subheadline)
                                }
                            }
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(10)
                        }
                        .frame(maxWidth: .infinity)
                        
                        // Aggregated Statistics Card centered horizontally
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Total Turnover:")
                                    Spacer()
                                    Text("$\(stats.total_turnover, specifier: "%.2f")")
                                }
                                HStack {
                                    Text("Total Commissions:")
                                    Spacer()
                                    Text("$\(stats.total_commissions, specifier: "%.2f")")
                                }
                                HStack {
                                    Text("Total Deposits:")
                                    Spacer()
                                    Text("$\(stats.total_deposits, specifier: "%.2f")")
                                }
                                HStack {
                                    Text("Sold Games Count:")
                                    Spacer()
                                    Text("\(stats.sold_games_count)")
                                }
                                HStack {
                                    Text("Unsold Games Count:")
                                    Spacer()
                                    Text("\(stats.unsold_games_count)")
                                }
                            }
                            .padding()
                            .background(Color(UIColor.systemBackground))
                            .cornerRadius(10)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding()
                }
            } else {
                Spacer()
                Text("No statistics available.")
                Spacer()
            }
        }
        .navigationTitle("Seller Statistics")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: loadStats)
    }
    
    private func loadStats() {
        isLoading = true
        errorMessage = nil
        statisticsService.fetchStats(for: seller) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let stats):
                    self.stats = stats
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}

struct SellerStatisticsView_Previews: PreviewProvider {
    static var sampleSeller = Seller(
        id: 1,
        idSellerPublic: "sample-public-id",
        name: "Sample Seller",
        email: "seller@example.com",
        tel: "1234567890",
        billingAddress: "123 Address St."
    )
    
    static var previews: some View {
        NavigationView {
            SellerStatisticsView(seller: sampleSeller)
        }
    }
}