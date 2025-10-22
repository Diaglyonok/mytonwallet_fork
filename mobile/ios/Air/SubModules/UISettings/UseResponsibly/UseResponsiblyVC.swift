//
//  AboutVC.swift
//  UICreateWallet
//
//  Created by nikstar on 05.09.2025.
//

import UIKit
import SwiftUI
import UIComponents
import WalletContext
import WalletCore

public final class UseResponsiblyVC: WViewController {
    
    private var hostingController: UIHostingController<UseResponsiblyView>!
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        
        addNavigationBar(
            addBackButton: { topWViewController()?.navigationController?.popViewController(animated: true) }
        )
        navigationBarProgressiveBlurDelta = 32
        
        hostingController = addHostingController(makeView(), constraints: .fill)
        
        bringNavigationBarToFront()
        
        updateTheme()
    }
    
    private func makeView() -> UseResponsiblyView {
        UseResponsiblyView(
            navigationBarInset: navigationBarHeight,
            onScroll: { [weak self] y in self?.updateNavigationBarProgressiveBlur(y) }
        )
    }
    
    override public func updateTheme() {
        view.backgroundColor = WTheme.groupedBackground
    }
}


@available(iOS 18, *)
#Preview {
    UseResponsiblyVC()
}
