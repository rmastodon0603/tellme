//
//  TellMeApp.swift
//  TellMe
//
//  Created by Volodymyr Kovalchuk on 04.03.2026.
//

import SwiftUI

@main
struct TellMeApp: App {
    @StateObject private var entitlementStore = EntitlementStore()
    @StateObject private var purchaseManager: PurchaseManager

    init() {
        let store = EntitlementStore()
        _entitlementStore = StateObject(wrappedValue: store)
        _purchaseManager = StateObject(wrappedValue: PurchaseManager(entitlementStore: store))
    }

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(entitlementStore)
                .environmentObject(purchaseManager)
        }
    }
}
