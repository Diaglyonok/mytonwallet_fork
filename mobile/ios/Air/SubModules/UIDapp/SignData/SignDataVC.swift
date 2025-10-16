
import SwiftUI
import UIKit
import Ledger
import UIPasscode
import UIComponents
import WalletCore
import WalletContext

class SignDataVC: WViewController {
    
    var update: ApiUpdate.DappSignData?
    var onConfirm: ((String?) -> ())?
    var onCancel: (() -> ())?
    
    var placeholderAccountId: String?
    
    var hostingController: UIHostingController<SignDataViewOrPlaceholder>?
    
    init(
        update: ApiUpdate.DappSignData,
        onConfirm: @escaping (String?) -> (),
        onCancel: @escaping () -> ()
    ) {
        self.update = update
        self.onConfirm = onConfirm
        self.onCancel = onCancel
        super.init(nibName: nil, bundle: nil)
    }
    
    init(placeholderAccountId: String?) {
        self.placeholderAccountId = placeholderAccountId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func replacePlaceholder(
        update: ApiUpdate.DappSignData,
        onConfirm: @escaping (String?) -> (),
        onCancel: @escaping () -> ()
    ) {
        self.update = update
        self.onConfirm = onConfirm
        self.onCancel = onCancel
        withAnimation {
            self.hostingController?.rootView = makeView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        
        addNavigationBar(title: nil, subtitle: nil, closeIcon: true)

        hostingController = addHostingController(makeView(), constraints: .fill)
        
        bringNavigationBarToFront()
        
        updateTheme()
    }
    
    private func makeView() -> SignDataViewOrPlaceholder {
        if let update {
            let account = AccountStore.accountsById[update.accountId] ?? DUMMY_ACCOUNT
            return SignDataViewOrPlaceholder(content: .signData(SignDataView(
                update: update,
                account: account,
                onConfirm: { [weak self] in self?._onConfirm() },
                onCancel: { [weak self] in self?._onCancel() },
                navigationBarInset: navigationBarHeight,
                onScroll: weakifyUpdateProgressiveBlur(),
            )))
        } else {
            let account = placeholderAccountId.flatMap { AccountStore.accountsById[$0] }
            return SignDataViewOrPlaceholder(content: .placeholder(TonConnectPlaceholder(
                account: account,
                connectionType: .signData,
                navigationBarInset: navigationBarHeight
            )))
        }
    }
    
    override func updateTheme() {
        view.backgroundColor = WTheme.sheetBackground
    }

    func _onConfirm() {
        if let update, let onConfirm {
            UnlockVC.presentAuth(
                on: self,
                title: lang("Sign Data"),
                subtitle: update.dapp.name,
                onDone: { passcode in
                    onConfirm(passcode)
                    self.dismiss(animated: true)
                },
                cancellable: true
            )
        }
    }

    func _onCancel() {
        navigationController?.presentingViewController?.dismiss(animated: true)
        onCancel?()
    }
}
