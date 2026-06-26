//
//  ViewSetting.swift
//  TestSwiftUI
//
//  Created by shuruiinfo on 2025/8/11.
//

import SwiftUI
import Combine

public let hx_webApp = false
public let hx_kycFour = false

public class ViewSetting: ObservableObject {
    @Published public var hx_userAppear: Bool = false
    @Published public var hx_tabbarAppear: Bool = true
    @Published public var hx_tabIndex = 0
    @Published public var hx_orderMark = 20
    @Published public var hx_updateType: String = ""
    @Published public var hx_updateClose:Bool = false
    @Published public var hx_praiseCheck:Bool = false
    @Published public var hx_seviceBtnHidden = false
    @Published public var hx_appPush = false
    @Published public var hx_updateOrder = false
    @Published public var hx_root = false
    @Published public var hx_runkyc: FormType = .none
    public var hx_normalUpdateShowed = false
    public var hx_kycComplete = false
    public var hx_emiHome = false
    public static let shared = ViewSetting()
    
    private init() {
        let hx_appearance = UINavigationBarAppearance()
        hx_appearance.configureWithTransparentBackground()
        hx_appearance.titleTextAttributes = [
            .foregroundColor: UIColor(red: 34/255.0, green: 92/255.0, blue: 63/255.0, alpha: 1.0),// 标题颜色
            .font: UIFont.systemFont(ofSize: 16, weight: .heavy) // 字体
        ]
        hx_appearance.backgroundColor = .clear
        UINavigationBar.appearance().standardAppearance = hx_appearance
        UINavigationBar.appearance().scrollEdgeAppearance = hx_appearance
        UITableView.appearance().tableFooterView = UIView()
        UITabBar.appearance().isHidden = true // 彻底隐藏系统TabBar
    }
    
    public func hx_setRoot() {
        hx_root = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.hx_root = false
        }
    }
    public func hx_kyc(_ type: FormType = .kyc) {
        hx_runkyc = type
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.hx_runkyc = .none
        }
    }
    
    public func hx_checkWeatherShowPushToday() {
        @UIApplicationDelegateAdaptor(PushAppDelegate.self) var delegate
        delegate.hx_checkAuth { granted in
            if !granted {
                let lastShownTimestamp = UserDefaults.standard.double(forKey: "pushAlert")
                let lastShownDate = Date(timeIntervalSince1970: lastShownTimestamp)
                
                // 比较是否同一天
                let calendar = Calendar.current
                let today = Date()
                
                if calendar.isDate(lastShownDate, inSameDayAs: today) {
                    self.hx_appPush = false
                } else {
                    // 保存当前时间戳
                    if lastShownTimestamp != 0 { //lastShownTimestamp == 0时，说明第一次获取网络权限失败，此时已经有系统弹框了，不再弹二次弹框
                        self.hx_appPush = true
                    }
                    UserDefaults.standard.set(today.timeIntervalSince1970, forKey: "pushAlert")
                }
            } else {
                delegate.hx_uploadGoogleToken()
            }
        }
    }
}

