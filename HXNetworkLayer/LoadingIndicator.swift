//
//  LoadingIndicator.swift
//  HXNetworkLayer
//
//  单例加载指示器：包含 UIActivityIndicatorView 与可选 label，可显示在 keyWindow 上。纯 UIKit 实现。
//

import UIKit

// MARK: - LoadingIndicator (单例)

/// 全局单例加载指示器：show 将控件显示到 keyWindow，hide 从 window 移除。
/// - 若未传 label，仅显示 UIActivityIndicatorView，需主动调用 hide 隐藏，或 1.5 秒后自动移除。
public final class LoadingIndicator {

    public static let shared = LoadingIndicator()

    private var overlayWindow: UIWindow?
    private var contentView: UIView?
    private var autoHideWorkItem: DispatchWorkItem?
    private let lock = NSLock()

    private init() {}

    // MARK: - 项目兼容 API（类方法，供现有代码调用）

    /// 仅显示加载指示器（无文案），需主动调用 hx_hide() 隐藏。
    public static func hx_show() {
        shared.show(label: nil)
    }

    /// 根据 showIndicator 显示：true 时显示指示器，需主动 hx_hide()；传 false 不显示。
    public static func hx_show(showIndicator: Bool) {
        if showIndicator {
            shared.show(label: nil)
        }
    }

    /// 显示加载指示器及文案（指示器在上、文案在下）。带文案时不会自动消失，需主动 hx_hide()。
    public static func hx_show(_ message: String) {
        shared.show(label: message.isEmpty ? nil : message, progressViewFirst: true)
    }

    /// 从 window 上移除加载指示器。
    public static func hx_hide() {
        shared.hide()
    }

    // MARK: - 显示 / 隐藏

    /// 在 keyWindow 上显示加载指示器。
    /// - Parameters:
    ///   - label: 文案，传 nil 或空字符串时只显示 UIActivityIndicatorView（仅指示器时 1.5 秒后自动隐藏，也可主动 hide）。
    ///   - progressViewFirst: true 表示指示器在上、label 在下；false 表示 label 在上、指示器在下。
    public func show(label: String? = nil, progressViewFirst: Bool = true) {
        lock.lock()
        defer { lock.unlock() }

        cancelAutoHide()

        let effectiveLabel = (label != nil && !label!.isEmpty) ? label : nil

        DispatchQueue.main.async { [weak self] in
            self?.removeFromWindow()
            guard let window = self?.keyWindow(), let self = self else { return }
            let overlay = self.makeOverlayWindow(with: window)
            let content = self.makeContentView(label: effectiveLabel, progressViewFirst: progressViewFirst)
            guard let rootVC = overlay.rootViewController else { return }
            rootVC.view.addSubview(content)
            content.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                content.centerXAnchor.constraint(equalTo: rootVC.view.centerXAnchor),
                content.centerYAnchor.constraint(equalTo: rootVC.view.centerYAnchor),
            ])
            overlay.isHidden = false
            self.overlayWindow = overlay
            self.contentView = content

            if effectiveLabel == nil {
                self.scheduleAutoHide()
            }
        }
    }

    /// 从 window 上移除加载指示器。
    public func hide() {
        lock.lock()
        cancelAutoHide()
        lock.unlock()

        DispatchQueue.main.async { [weak self] in
            self?.removeFromWindow()
        }
    }

    // MARK: - 内部

    private func keyWindow() -> UIWindow? {
        if #available(iOS 13.0, *) {
            guard let scene = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first(where: { $0.activationState == .foregroundActive }),
                  let window = scene.windows.first(where: { $0.isKeyWindow }) ?? scene.windows.first
            else {
                return nil
            }
            return window
        } else {
            return UIApplication.shared.keyWindow
        }
    }

    private func makeOverlayWindow(with parent: UIWindow) -> UIWindow {
        let overlay = UIWindow(frame: parent.bounds)
        overlay.windowLevel = .alert
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        let rootVC = UIViewController()
        rootVC.view.backgroundColor = .clear
        overlay.rootViewController = rootVC
        return overlay
    }

    private func makeContentView(label: String?, progressViewFirst: Bool) -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor.systemBackground
        container.layer.cornerRadius = 12
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.15
        container.layer.shadowRadius = 10
        container.layer.shadowOffset = CGSize(width: 0, height: 4)

        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()

        if let labelText = label, !labelText.isEmpty {
            let labelView = UILabel()
            labelView.text = labelText
            labelView.font = .preferredFont(forTextStyle: .subheadline)
            labelView.textColor = .secondaryLabel
            labelView.translatesAutoresizingMaskIntoConstraints = false

            container.addSubview(indicator)
            container.addSubview(labelView)

            let spacing: CGFloat = 12
            if progressViewFirst {
                NSLayoutConstraint.activate([
                    indicator.topAnchor.constraint(equalTo: container.topAnchor, constant: 24),
                    indicator.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                    labelView.topAnchor.constraint(equalTo: indicator.bottomAnchor, constant: spacing),
                    labelView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                    labelView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -24),
                ])
            } else {
                NSLayoutConstraint.activate([
                    labelView.topAnchor.constraint(equalTo: container.topAnchor, constant: 24),
                    labelView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                    indicator.topAnchor.constraint(equalTo: labelView.bottomAnchor, constant: spacing),
                    indicator.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                    indicator.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -24),
                ])
            }
        } else {
            container.addSubview(indicator)
            NSLayoutConstraint.activate([
                indicator.topAnchor.constraint(equalTo: container.topAnchor, constant: 24),
                indicator.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -24),
                indicator.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 24),
                indicator.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -24),
            ])
        }

        return container
    }

    private func removeFromWindow() {
        contentView?.removeFromSuperview()
        contentView = nil
        overlayWindow?.isHidden = true
        overlayWindow = nil
    }

    private func scheduleAutoHide() {
        let work = DispatchWorkItem { [weak self] in
            self?.hide()
        }
        autoHideWorkItem = work
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: work)
    }

    private func cancelAutoHide() {
        autoHideWorkItem?.cancel()
        autoHideWorkItem = nil
    }
}
