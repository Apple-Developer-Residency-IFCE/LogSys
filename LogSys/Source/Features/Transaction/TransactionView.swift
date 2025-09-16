//
//  TransactionView.swift
//  LogSys
//
//  Created by Pedro Sousa on 16/09/25.
//

import SwiftUI
import SwiftData

struct TransactionView: View {
    var viewModel: TransactionViewModel

    var body: some View {
        NavigationStack {
            List(viewModel.transactions) { transaction in
                VStack(alignment: .leading) {
                    Text("\(transaction.date, style: .date)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("\(transaction.destination)")

                    HStack {
                        Spacer()
                        Text("\(transaction.value, format: .currency(code: "BRL"))")
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Pay") {
                        viewModel.makeTransaction()
                    }
                }
            }
        }
        .onAppear {
            viewModel.getTansactions()
        }
        .task {
            viewModel.shareLog()
        }
    }
}

#Preview {
    TransactionView(viewModel: .init(networkService: .shared,
                                     storageService: .shared))
}
