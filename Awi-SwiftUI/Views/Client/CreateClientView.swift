import SwiftUI

struct CreateClientView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var name = ""
    @State private var email = ""
    @State private var num = ""
    @State private var address = ""
    @State private var errorMessage: String?
    @State private var isLoading = false
    
    // Callback to return the newly created client.
    var onClientCreated: (Client) -> Void
    
    // Automatically set town public id
    private let defaultTownPublicId = "2d55174a-c633-429c-b165-8644d0801657"
    
    var body: some View {
        Form {
            Section(header: Text("Client Details")) {
                TextField("Name", text: $name)
                TextField("Email", text: $email)
                TextField("Phone", text: $num)
                TextField("Address", text: $address)
            }
            if let message = errorMessage {
                Text(message)
                    .foregroundColor(.red)
            }
            Button(action: {
                createClient()
            }) {
                if isLoading {
                    ProgressView()
                } else {
                    Text("Create Client")
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .navigationTitle("Create Client")
    }
    
    private func createClient() {
        guard !name.isEmpty, !email.isEmpty, !num.isEmpty, !address.isEmpty else {
            errorMessage = "All fields are required."
            return
        }
        isLoading = true
        errorMessage = nil
        let newClientDto = CreateClientDto(
            address: address,
            num: num,
            email: email,
            name: name,
            id_town_public: defaultTownPublicId
        )
        ClientService().createClient(dto: newClientDto) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let client):
                    onClientCreated(client)
                    presentationMode.wrappedValue.dismiss()
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}

struct CreateClientView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CreateClientView(onClientCreated: { _ in })
        }
    }
}