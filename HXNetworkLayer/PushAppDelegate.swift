//
//  AppDelegate.swift
//  Eventualiately
//
//  Created by mc on 4/10/26.
//

import FirebaseCore
import FirebaseMessaging
import UserNotifications
// 2. 创建 AppDelegate 并实现所有代理
public class PushAppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    // MARK: - 启动配置
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 初始化 Firebase
        FirebaseApp.configure()
        // 设置代理
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self

        return true
    }
    
    // 请求推送权限
    public func hx_checkAuth(_ application: UIApplication = UIApplication.shared, callback: @escaping ((Bool)->())) {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                hx_uploadBuryPoint("600")

                print("推送权限已授权")
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            } else {
                hx_uploadBuryPoint("601")
                print("推送权限被拒绝")
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                callback(granted)
            }
        }
    }
    public func hx_uploadGoogleToken() {
        Messaging.messaging().token { token, error in
            if let _ = error {
                // 重新获取
                self.hx_uploadGoogleToken()
                return
            } else {// 上传token
                print("上传googleToken")
                let hx_model = UserInfoInModel()
                hx_model.hx_googleToken = token
                hx_model.hx_execute(showHub: false) { _ in }
            }
        }
    }
    
    // MARK: - 获取 Device Token (APNs)
    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // 将 APNs 令牌传给 FCM (关键步骤，缺失则无法收到推送)
        Messaging.messaging().apnsToken = deviceToken
                    
        // 打印调试
        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("APNs Device Token: \(tokenString)")
        hx_uploadGoogleToken()
    }

    public func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("注册远程推送失败: \(error.localizedDescription)")
    }

    // MARK: - FCM Token 刷新回调
    public func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        // Swift 6 兼容写法：添加 nonisolated 标记（如果在 Actor 隔离环境下）
        print("FCM Token: \(fcmToken ?? "")")
    }
    
    // MARK: - 接收和展示推送
    // App 在前台时收到推送，系统默认不会弹窗，需要手动指定展示方式
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        print("前台收到推送: \(userInfo)")
        // 让推送在前台也能弹窗、响铃
        completionHandler([.banner, .sound])
    }
    
    // 用户点击推送消息打开 App 时触发
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print("用户点击了推送: \(userInfo)")
        // 这里处理跳转逻辑
        let state = UIApplication.shared.applicationState
        if state == .inactive || state == .background {
            hx_uploadBuryPoint("602")
        }
        completionHandler()
    }
}
