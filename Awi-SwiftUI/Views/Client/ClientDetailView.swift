import SwiftUI

struct ClientDetailView: View {
    let client: Client
    
    var body: some View {
        Form {
            Section(header: Text("Client Information")) {
                HStack {
                    Text("Name")
                    Spacer()
                    Text(client.name)
                        .foregroundColor(.secondary)
                }
                HStack {
                    Text("Email")
                    Spacer()
                    Text(client.email)
                        .foregroundColor(.secondary)
                }
                HStack {
                    Text("Phone")
                    Spacer()
                    Text(client.num)
                        .foregroundColor(.secondary)
                }
                HStack {
                    Text("Address")
                    Spacer()
                    Text(client.address)
                        .foregroundColor(.secondary)
                }
                // Display additional fields as needed.
            }
        }
        .navigationTitle(client.name)
    }
}

struct ClientDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleClient = Client(
            id_client: 1,
            id_client_public: "d05c2918-f035-46dd-a6be-1e093bb7a62f",
            address: "789 Elm St",
            num: "555-1001",
            email: "alice@example.com",
            name: "Alice Smith",
            id_town_public: "2d55174a-c633-429c-b165-8644d0801657"
        )
        NavigationView {
            ClientDetailView(client: sampleClient)
        }
    }
}
