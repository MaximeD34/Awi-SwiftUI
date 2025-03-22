import Foundation
import Combine

final class SellerDetailViewModel: ObservableObject {
    @Published var sellerName: String = ""
    @Published var sellerEmail: String = ""
    @Published var sellerTel: String = ""
    @Published var sellerBillingAddress: String = ""
    
    // Inline validation error messages.
    @Published var nameError: String?
    @Published var emailError: String?
    @Published var telError: String?
    @Published var billingAddressError: String?
    
    private let sellerService = SellerService()
    
    func loadSellerDetails(for seller: Seller) {
        sellerName = seller.name
        sellerEmail = seller.email ?? ""
        sellerTel = seller.tel ?? ""
        sellerBillingAddress = seller.billingAddress ?? ""
    }
    
    // Validates all fields; returns true if valid.
    func validateFields() -> Bool {
        var valid = true
        
        if sellerName.trimmingCharacters(in: .whitespacesAndNewlines).count < 2 ||
           sellerName.trimmingCharacters(in: .whitespacesAndNewlines).count > 50 {
            nameError = "Name must be between 2 and 50 characters"
            valid = false
        } else {
            nameError = nil
        }
        
        if !isValidEmail(sellerEmail) {
            emailError = "Email must be a valid email address"
            valid = false
        } else {
            emailError = nil
        }
        
        if !isValidTel(sellerTel) {
            telError = "Telephone number must be a valid international phone number"
            valid = false
        } else {
            telError = nil
        }
        
        if !sellerBillingAddress.isEmpty {
            let count = sellerBillingAddress.trimmingCharacters(in: .whitespacesAndNewlines).count
            if count < 5 || count > 100 {
                billingAddressError = "Billing address must be between 5 and 100 characters if provided"
                valid = false
            } else {
                billingAddressError = nil
            }
        } else {
            billingAddressError = nil
        }
        
        return valid
    }
    
    // Saves the seller (updates if seller exists, creates new if nil).
    // The completion returns a success message, or an error.
    func saveSeller(_ seller: Seller?, completion: @escaping (Result<String, Error>) -> Void) {
        guard validateFields() else {
            completion(.failure(NSError(domain: "ValidationError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Please fix the errors before proceeding."])))
            return
        }
        
        if let seller = seller {
            sellerService.updateSeller(sellerID: seller.id, name: sellerName) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        completion(.success("Seller updated successfully"))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        } else {
            let dto = CreateSellerDto(
                name: sellerName,
                email: sellerEmail,
                tel: sellerTel,
                billing_address: sellerBillingAddress.isEmpty ? nil : sellerBillingAddress
            )
            sellerService.createSeller(dto: dto) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let newSeller):
                        completion(.success("Seller created successfully"))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    // Helper validation methods.
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = #"^\S+@\S+\.\S+$"#
        return email.range(of: emailRegEx, options: .regularExpression) != nil
    }
    
    private func isValidTel(_ tel: String) -> Bool {
        let telRegEx = #"^\+?[1-9]\d{1,14}$"#
        return tel.range(of: telRegEx, options: .regularExpression) != nil
    }
}