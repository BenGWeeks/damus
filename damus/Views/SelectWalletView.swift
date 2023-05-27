//
//  SelectWalletView.swift
//  damus
//
//  Created by Suhail Saqan on 12/22/22.
//

import SwiftUI

struct SelectWalletView: View {
    let default_wallet: Wallet
    @Binding var showingSelectWallet: Bool
    let our_pubkey: String
    let invoice: String
    @State var invoice_copied: Bool = false
    
    @State var allWalletModels: [Wallet.Model] = Wallet.allModels
    let generator = UIImpactFeedbackGenerator(style: .light)
    
    var body: some View {
        NavigationView {
            Form {
                Section(NSLocalizedString("Copy invoice", comment: "Title of section for copying a Lightning invoice identifier.")) {
                    HStack {
                        Text(invoice).font(.body)
                            .lineLimit(2)
                            .truncationMode(.tail)
                        
                        Spacer()
                        
                        Image(self.invoice_copied ? "check-circle" : "copy2").foregroundColor(.blue)
                    }.clipShape(RoundedRectangle(cornerRadius: 5)).onTapGesture {
                        UIPasteboard.general.string = invoice
                        self.invoice_copied = true
                        generator.impactOccurred()
                    }
                }
                Section(NSLocalizedString("Select a Lightning wallet", comment: "Title of section for selecting a Lightning wallet to pay a Lightning invoice.")) {
                    List{
                        Button() {
                            open_with_wallet(wallet: default_wallet.model, invoice: invoice)
                        } label: {
                            HStack {
                                Text("Default Wallet", comment: "Button to pay a Lightning invoice with the user's default Lightning wallet.").font(.body).foregroundColor(.blue)
                            }
                        }.buttonStyle(.plain)
                        List($allWalletModels) { $wallet in
                            if wallet.index >= 0 {
                                Button() {
                                    open_with_wallet(wallet: wallet, invoice: invoice)
                                } label: {
                                    HStack {
                                        Image(wallet.image).resizable().frame(width: 32.0, height: 32.0,alignment: .center).cornerRadius(5)
                                        Text(wallet.displayName).font(.body)
                                    }
                                }.buttonStyle(.plain)
                            }
                        }
                    }.padding(.vertical, 2.5)
                }
            }.navigationBarTitle(Text("Pay the Lightning invoice", comment: "Navigation bar title for view to pay Lightning invoice."), displayMode: .inline).navigationBarItems(trailing: Button(action: {
                self.showingSelectWallet = false
            }) {
                Text("Done", comment: "Button to dismiss wallet selection view for paying Lightning invoice.").bold()
            })
        }
    }
}

struct SelectWalletView_Previews: PreviewProvider {
    @State static var show: Bool = true
    
    static var previews: some View {
        SelectWalletView(default_wallet: .lnlink, showingSelectWallet: $show, our_pubkey: "", invoice: "")
    }
}
