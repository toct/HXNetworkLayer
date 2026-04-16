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
    private static let shared = LoadingIndicator()
    private var overlayWindow: UIWindow?
    private var contentView: UIView?
    private var autoHideWorkItem: DispatchWorkItem?
    private let lock = NSLock()

    private init() {}

    /// 在 keyWindow 上显示加载指示器。
    /// - Parameters:
    ///   - label: 文案，传 nil 或空字符串时只显示 UIActivityIndicatorView（仅文案时 1.5 秒后自动隐藏，也可主动 hide）。
    ///   - showIndicator: true 表示指示器显示，false 代表指示器隐藏
    public static func hx_show(_ message: String? = nil, showIndicator: Bool = false, isKYC:Bool = false) {
        shared.hx_show(message, showIndicator: showIndicator)
        if let text = message, !text.isEmpty && isKYC {
            hx_uploadBuryPoint("29", remark1: text)
        }
    }
    /// 从 window 上移除加载指示器。
    public static func hx_hide() {
        shared.hide()
    }

    // MARK: - 显示 / 隐藏
    private func hx_show(_  label: String? = nil, showIndicator: Bool) {
        lock.lock()
        defer { lock.unlock() }

        cancelAutoHide()

        DispatchQueue.main.async { [weak self] in
            self?.removeFromWindow()
            guard let window = self?.keyWindow(), let self = self else { return }
            let overlay = self.makeOverlayWindow(with: window)
            let content = self.makeContentView(label: label, showProgress: showIndicator)
            guard let rootVC = overlay.rootViewController else { return }
            rootVC.view.addSubview(content)
            content.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                content.centerXAnchor.constraint(equalTo: rootVC.view.centerXAnchor),
                content.centerYAnchor.constraint(equalTo: rootVC.view.centerYAnchor),
                content.widthAnchor.constraint(lessThanOrEqualTo: rootVC.view.widthAnchor, constant: -40),
                content.widthAnchor.constraint(greaterThanOrEqualTo: content.heightAnchor, multiplier: 1.0)
            ])
            overlay.isHidden = false
            self.overlayWindow = overlay
            self.contentView = content

            self.scheduleAutoHide()
        }
    }
    // MARK: - 内部

    private func keyWindow() -> UIWindow? {
        guard let scene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive }),
              let window = scene.windows.first(where: { $0.isKeyWindow }) ?? scene.windows.first
        else {
            return nil
        }
        return window
    }

    private func makeOverlayWindow(with parent: UIWindow) -> UIWindow {
        let overlay = UIWindow(frame: parent.bounds)
        overlay.windowLevel = .alert
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        parent.addSubview(overlay)
        let rootVC = UIViewController()
        rootVC.view.backgroundColor = .clear
        overlay.rootViewController = rootVC
        return overlay
    }

    private func makeContentView(label: String?, showProgress: Bool) -> UIView {
        let hx_stack = UIStackView()
        hx_stack.axis = .vertical
        hx_stack.spacing = 10
        hx_stack.alignment = .fill
        hx_stack.distribution = .fill
        hx_stack.isLayoutMarginsRelativeArrangement = true
        hx_stack.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        hx_stack.backgroundColor = UIColor.systemBackground
        hx_stack.layer.cornerRadius = 12
        hx_stack.layer.shadowColor = UIColor.black.cgColor
        hx_stack.layer.shadowOpacity = 0.15
        hx_stack.layer.shadowRadius = 10
        hx_stack.layer.shadowOffset = CGSize(width: 0, height: 4)
        if showProgress {
            let hx_view = UIView()
            let hx_indicator = UIActivityIndicatorView(style: .large)
            hx_indicator.translatesAutoresizingMaskIntoConstraints = false
            hx_indicator.startAnimating()
            hx_indicator.translatesAutoresizingMaskIntoConstraints = false
            hx_view.addSubview(hx_indicator)
            NSLayoutConstraint.activate([
                hx_indicator.centerXAnchor.constraint(equalTo: hx_view.centerXAnchor),
                hx_indicator.topAnchor.constraint(equalTo: hx_view.topAnchor),
                hx_indicator.bottomAnchor.constraint(equalTo: hx_view.bottomAnchor)
            ])
            hx_view.translatesAutoresizingMaskIntoConstraints = false
            hx_stack.addArrangedSubview(hx_view)
        }
        if let hx_value = label, !hx_value.isEmpty {
            let hx_label = UILabel()
            hx_label.numberOfLines = 0
            hx_label.backgroundColor = .clear
            hx_label.text = hx_value
            hx_label.textAlignment = .center
            hx_label.font = .systemFont(ofSize: 16, weight: .medium)
            hx_label.textColor = .black
            hx_label.translatesAutoresizingMaskIntoConstraints = false
            hx_stack.addArrangedSubview(hx_label)
        }
        return hx_stack
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
    
    /// 从 window 上移除加载指示器。
    public func hide() {
        lock.lock()
        cancelAutoHide()
        lock.unlock()

        DispatchQueue.main.async { [weak self] in
            self?.removeFromWindow()
        }
    }
}
