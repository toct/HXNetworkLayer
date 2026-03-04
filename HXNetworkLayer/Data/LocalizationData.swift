//
//  LocalizationData.swift
//  TestSwiftUI
//
//  Created by shuruiinfo on 2025/8/6.
//
import Foundation
import Combine

class LocalizationData: ObservableObject, Codable {
    // MARK: - 使用 @Published 包装属性
    @Published var hx_loginData: LoginOutModel = LoginOutModel()
    @Published var hx_userData: UserInfoOutModel?
    @Published var hx_config: ConfigInfoOutModel?
    @Published var hx_homeData: HomeDataOutModel?
    @Published var hx_firstLunach: Bool = true
    @Published var hx_praise: Bool = false
    @Published var hx_abTag: String? = "1" // 默认显示B
    
    var hx_tmpLoginData: LoginOutModel?
    
    static let shared = LocalizationData()

    // MARK: - 文件管理
    private static var hx_saveURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            .appendingPathComponent(String(describing: self))
    }
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - 初始化
    init() {
        // 设置属性变更监听
        hx_setupBindings()
        // 从文件加载已有数据
        hx_loadData()
    }
    
    // MARK: - Codable 实现
    enum CodingKeys: String, CodingKey {
        case hx_loginData, hx_userData, hx_config, hx_homeData, hx_firstLunach, hx_praise, hx_abTag
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        hx_loginData = try container.decode(LoginOutModel.self, forKey: .hx_loginData)
        hx_userData = try container.decodeIfPresent(UserInfoOutModel.self, forKey: .hx_userData)
        hx_config = try container.decodeIfPresent(ConfigInfoOutModel.self, forKey: .hx_config)
        hx_homeData = try container.decodeIfPresent(HomeDataOutModel.self, forKey: .hx_homeData)
        hx_firstLunach = try container.decode(Bool.self, forKey: .hx_firstLunach)
        hx_praise = try container.decode(Bool.self, forKey: .hx_praise)
        hx_abTag = try container.decode(String.self, forKey: .hx_abTag)

        hx_tmpLoginData = hx_loginData
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(hx_loginData, forKey: .hx_loginData)
        try container.encode(hx_userData, forKey: .hx_userData)
        try container.encode(hx_config, forKey: .hx_config)
        try container.encode(hx_homeData, forKey: .hx_homeData)
        try container.encode(hx_firstLunach, forKey: .hx_firstLunach)
        try container.encode(hx_praise, forKey: .hx_praise)
        try container.encode(hx_abTag, forKey: .hx_abTag)
    }
    
    // MARK: - 设置Combine绑定
    private func hx_setupBindings() {
        // 合并所有属性的Publisher
        // 将所有Publisher转换为Void类型
        let hx_loginDataPublisher = $hx_loginData.dropFirst().map { _ in }
        let hx_userDataPublisher = $hx_userData.dropFirst().map { _ in }
        let hx_configPublisher = $hx_config.dropFirst().map { _ in }
        let hx_homeDataPublisher = $hx_homeData.dropFirst().map { _ in }
        let hx_firstLunachPublisher = $hx_firstLunach.dropFirst().map { _ in }
        let hx_praisePublisher = $hx_praise.dropFirst().map { _ in }
        let hx_abTagPublisher = $hx_abTag.dropFirst().map { _ in }

        Publishers.Merge7(
            hx_loginDataPublisher,
            hx_userDataPublisher,
            hx_configPublisher,
            hx_homeDataPublisher,
            hx_firstLunachPublisher,
            hx_praisePublisher,
            hx_abTagPublisher
        )
        .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main) // 防抖处理
        .sink { [weak self] _ in
            // 任一属性变更时执行保存
            self?.hx_saveData()
        }
        .store(in: &cancellables)
    }
    
    // MARK: - 保存实例
    private func hx_saveData() {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let self = self else { return }
            do {
                let data = try JSONEncoder().encode(self)
                try data.write(to: Self.hx_saveURL, options: [.atomic])
//                print("✅ 实例保存成功" + Self.hx_saveURL.absoluteString)
            } catch {
//                print("❌ 保存失败: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - 加载实例
    private func hx_loadData() {
        print(Self.hx_saveURL.absoluteString)
        
        guard FileManager.default.fileExists(atPath: Self.hx_saveURL.path) else {
//            print("ℹ️ 无保存数据，使用默认值")
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            do {
                let data = try Data(contentsOf: Self.hx_saveURL)
                
                // 直接使用JSONDecoder解码，不需要通过JsonKit
                let saved = try JSONDecoder().decode(LocalizationData.self, from: data)
                
                DispatchQueue.main.async {
                    // 更新主线程上的属性
                    self.hx_loginData = saved.hx_loginData
                    self.hx_config = saved.hx_config
                    self.hx_userData = saved.hx_userData
                    self.hx_firstLunach = saved.hx_firstLunach
                    self.hx_praise = saved.hx_praise
                    self.hx_abTag = saved.hx_abTag
                    self.hx_tmpLoginData = saved.hx_loginData
//                    print("✅ 实例加载成功")
                }
            } catch {
//                print("Detailed error: \(error)")
//                  if let decodingError = error as? DecodingError {
//                      print("Decoding error details: \(decodingError.localizedDescription)")
//                      switch decodingError {
//                      case .typeMismatch(let type, let context):
//                          print("Type '\(type)' mismatch:", context.debugDescription)
//                          print("Coding path:", context.codingPath)
//                      case .valueNotFound(let type, let context):
//                          print("Value '\(type)' not found:", context.debugDescription)
//                          print("Coding path:", context.codingPath)
//                      case .keyNotFound(let key, let context):
//                          print("Key '\(key)' not found:", context.debugDescription)
//                          print("Coding path:", context.codingPath)
//                      case .dataCorrupted(let context):
//                          print("Data corrupted:", context.debugDescription)
//                          print("Coding path:", context.codingPath)
//                      @unknown default:
//                          print("Unknown decoding error")
//                      }
//                  }
            }
        }
    }
}
