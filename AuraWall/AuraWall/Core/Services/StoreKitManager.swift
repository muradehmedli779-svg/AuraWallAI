import Foundation
import StoreKit

@MainActor
public final class StoreKitManager: ObservableObject {
    @Published public private(set) var isProUser: Bool = false
    @Published public private(set) var availableProducts: [Product] = []
    @Published public private(set) var purchasedProductIDs = Set<String>()
    @Published public var isLoading: Bool = false
    @Published public var purchaseErrorMessage: String?
    
    private var transactionListener: Task<Void, Error>?
    
    public init() {
        // Start listening to StoreKit 2 transactions
        transactionListener = listenForTransactions()
        Task {
            await requestProducts()
            await updateSubscriptionStatus()
        }
    }
    
    deinit {
        transactionListener?.cancel()
    }
    
    public func requestProducts() async {
        isLoading = true
        defer { isLoading = false }
        
        let productIdentifiers = [
            Configuration.StoreKit.proMonthlyID,
            Configuration.StoreKit.proYearlyID,
            Configuration.StoreKit.proLifetimeID
        ]
        
        do {
            let products = try await Product.products(for: productIdentifiers)
            self.availableProducts = products.sorted { $0.price < $1.price }
        } catch {
            print("Failed to fetch StoreKit products: \(error.localizedDescription)")
        }
    }
    
    public func purchase(_ product: Product) async throws -> Bool {
        isLoading = true
        defer { isLoading = false }
        
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            await transaction.finish()
            await updateSubscriptionStatus()
            return true
        case .userCancelled:
            return false
        case .pending:
            return false
        @unknown default:
            return false
        }
    }
    
    public func restorePurchases() async {
        isLoading = true
        defer { isLoading = false }
        try? await AppStore.sync()
        await updateSubscriptionStatus()
    }
    
    public func updateSubscriptionStatus() async {
        var purchased = Set<String>()
        
        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)
                if transaction.revocationDate == nil {
                    purchased.insert(transaction.productID)
                }
            } catch {
                print("Failed verification on transaction entitlement: \(error)")
            }
        }
        
        self.purchasedProductIDs = purchased
        self.isProUser = !purchased.isEmpty
    }
    
    private func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)
                    await transaction.finish()
                    await self.updateSubscriptionStatus()
                } catch {
                    print("Transaction verification failed: \(error)")
                }
            }
        }
    }
    
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified(_, let error):
            throw error
        case .verified(let safe):
            return safe
        }
    }
    
    /// Development convenience toggle
    public func debugUnlockPro() {
        self.isProUser = true
    }
}
