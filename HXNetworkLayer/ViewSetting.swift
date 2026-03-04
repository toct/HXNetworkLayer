//
//  ViewSetting.swift
//  TestSwiftUI
//
//  Created by shuruiinfo on 2025/8/11.
//

import SwiftUI
import Combine

class ViewSetting: ObservableObject {
    lazy var hx_statusHeight: CGFloat = {
        let hx_height = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.flatMap { $0.windows }.first?.safeAreaInsets.top ?? 0
        return hx_height
    }()
    let hx_webApp = true
    @Published var hx_userAppear: Bool = false
    @Published var hx_tabbarAppear: Bool = true
    @Published var hx_tabIndex = 0
    @Published var hx_orderMark = 20
    @Published var hx_updateType: String = ""
    @Published var hx_updateClose:Bool = false
    @Published var hx_praiseCheck:Bool = false
    @Published var hx_seviceBtnHidden = false
    @Published var hx_updateOrder = false
    @Published var hx_root = false
    var hx_normalUpdateShowed = false
    var hx_kycComplete = false
    @Published var hx_runkyc = false
    @Published var hx_bundId = ""

    static let shared = ViewSetting()
    
    init() {
        let hx_appearance = UINavigationBarAppearance()
        hx_appearance.configureWithTransparentBackground()
        hx_appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,       // 标题颜色
            .font: UIFont.systemFont(ofSize: 18) // 字体
        ]
        hx_appearance.backgroundColor = .clear
        UINavigationBar.appearance().standardAppearance = hx_appearance
        UINavigationBar.appearance().scrollEdgeAppearance = hx_appearance
        UITableView.appearance().backgroundColor = .red
        UITableViewCell.appearance().backgroundColor = .red
        UITableView.appearance().tableFooterView = UIView()
        UITabBar.appearance().isHidden = true // 彻底隐藏系统TabBar
    }
    
    func hx_setRoot() {
        hx_root = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.hx_root = false
        }
    }
    func hx_kyc() {
        hx_runkyc = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.hx_runkyc = false
        }
    }
}

