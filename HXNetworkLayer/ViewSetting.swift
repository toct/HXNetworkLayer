//
//  ViewSetting.swift
//  TestSwiftUI
//
//  Created by shuruiinfo on 2025/8/11.
//

import SwiftUI
import Combine

public class ViewSetting: ObservableObject {
    public lazy var hx_statusHeight: CGFloat = {
        let hx_height = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.flatMap { $0.windows }.first?.safeAreaInsets.top ?? 0
        return hx_height
    }()
    public let hx_webApp = true
    @Published public var hx_userAppear: Bool = false
    @Published public var hx_tabbarAppear: Bool = true
    @Published public var hx_tabIndex = 0
    @Published public var hx_orderMark = 20
    @Published public var hx_updateType: String = ""
    @Published public var hx_updateClose:Bool = false
    @Published public var hx_praiseCheck:Bool = false
    @Published public var hx_seviceBtnHidden = false
    @Published public var hx_updateOrder = false
    @Published public var hx_root = false
    public var hx_normalUpdateShowed = false
    public var hx_kycComplete = false
    @Published public var hx_runkyc = false
    @Published public var hx_bundId = ""

    public static let shared = ViewSetting()
    
    public init() {
        let hx_appearance = UINavigationBarAppearance()
        hx_appearance.configureWithTransparentBackground()
        hx_appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,       // 标题颜色
            .font: UIFont.systemFont(ofSize: 18) // 字体
        ]
        hx_appearance.backgroundColor = .clear
        UINavigationBar.appearance().standardAppearance = hx_appearance
        UINavigationBar.appearance().scrollEdgeAppearance = hx_appearance
// 如此设置，iOS16以下系统的通讯录选择，会触发两次，这里有疑问
//        UITableView.appearance().backgroundColor = .red
//        UITableViewCell.appearance().backgroundColor = .red
        UITableView.appearance().tableFooterView = UIView()
        UITabBar.appearance().isHidden = true // 彻底隐藏系统TabBar
    }
    
    public func hx_setRoot() {
        hx_root = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.hx_root = false
        }
    }
    public func hx_kyc() {
        hx_runkyc = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.hx_runkyc = false
        }
    }
}

