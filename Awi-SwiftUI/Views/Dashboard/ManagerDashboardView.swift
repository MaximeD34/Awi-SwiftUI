import SwiftUI

enum DashboardTab: String, CaseIterable {
    case newSale = "Make a New Sale"
    case manageSellers = "Manage Sellers"
    case collection = "Collection"
    case statistics = "Statistics"
}

struct ManagerDashboardView: View {
    @State private var isMenuOpen: Bool = false
    @State private var selectedTab: DashboardTab = .newSale

    var body: some View {
        NavigationView {
            ZStack(alignment: .leading) {
                // Custom header and main content
                VStack(spacing: 0) {
                    // Header with burger button
                    HStack {
                        Button(action: {
                            withAnimation {
                                isMenuOpen.toggle()
                            }
                        }) {
                            Image(systemName: "line.horizontal.3")
                                .font(.title2)
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 16)
                    
                    // Divider (horizontal line)
                    Divider()
                    
                    // Title placed below the divider
                    HStack {
                        Text(selectedTab.rawValue)
                            .font(.headline)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    
                    Divider()
                    
                    // Content area
                    content
                        .padding()
                    
                    Spacer()
                }
                .navigationBarHidden(true)
                
                // Menu overlay
                if isMenuOpen {
                    // Translucent overlay
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                isMenuOpen = false
                            }
                        }
                    
                    menuOverlay
                        .frame(width: 250)
                        .background(Color(UIColor.systemGray6))
                        .transition(.move(edge: .leading))
                }
            }
        }
    }
    
    private var content: some View {
        Group {
            switch selectedTab {
            case .newSale:
                MakeNewSaleView()
            case .manageSellers:
                ManageSellersView()
            case .collection:
                CollectionView()
            case .statistics:
                StatisticsView()
            }
        }
    }
    
    private var menuOverlay: some View {
        VStack(alignment: .leading) {
            ForEach(DashboardTab.allCases, id: \.self) { tab in
                Button(action: {
                    withAnimation {
                        selectedTab = tab
                        isMenuOpen = false
                    }
                }) {
                    HStack {
                        Text(tab.rawValue)
                            .padding(.vertical, 12)
                            .padding(.horizontal)
                        Spacer()
                    }
                }
                .foregroundColor(.primary)
            }
            Spacer()
        }
        .padding(.top, 60)
    }
}

struct ManagerDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        ManagerDashboardView()
    }
}