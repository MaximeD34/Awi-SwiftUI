import SwiftUI

enum DashboardTab: String, CaseIterable {
    case collection = "Collection"
    case newSale = "Make a New Sale"
    case manageSellers = "Manage Sellers"
    case statistics = "Statistics"
}

struct ManagerDashboardView: View {
    @State private var isMenuOpen: Bool = false
    @State private var selectedTab: DashboardTab = .collection
    @State private var showDisconnectAlert: Bool = false
    @EnvironmentObject var loginVM: LoginViewModel  // Access the login view model to disconnect
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .leading) {
                // Header and main content.
                VStack(spacing: 0) {
                    // Header with a burger button.
                    HStack {
                        Button(action: {
                            withAnimation { isMenuOpen.toggle() }
                        }) {
                            Image(systemName: "line.horizontal.3")
                                .font(.title2)
                        }
                        Spacer()
                    }
                    .padding([.horizontal, .top])
                    .padding(.bottom, 16)
                    
                    Divider()
                    
                    // Content title header.
                    HStack {
                        Text(selectedTab.rawValue)
                            .font(.headline)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    
                    Divider()
                    
                    // Main content area.
                    content
                        .padding()
                    
                    Spacer()
                }
                .navigationBarHidden(true)
                
                // Menu overlay if open.
                if isMenuOpen {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation { isMenuOpen = false }
                        }
                    
                    menuOverlay
                        .frame(width: 250)
                        .background(Color(UIColor.systemGray6))
                        .transition(.move(edge: .leading))
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .alert("Confirm Disconnect", isPresented: $showDisconnectAlert) {
            Button("Disconnect", role: .destructive) {
                loginVM.isAuthenticated = false
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to disconnect?")
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
                CatalogueView()
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
            
            // Disconnect Button with confirmation.
            Button(action: {
                withAnimation {
                    showDisconnectAlert = true
                }
            }) {
                HStack {
                    Image(systemName: "escape")
                    Text("Disconnect")
                        .bold()
                    Spacer()
                }
                .padding(.vertical, 12)
                .padding(.horizontal)
                .background(Color.red.opacity(0.1))
                .cornerRadius(8)
            }
            .foregroundColor(.red)
            .padding()
        }
        .padding(.top, 60)
    }
}

struct ManagerDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        ManagerDashboardView()
            .environmentObject(LoginViewModel())
    }
}