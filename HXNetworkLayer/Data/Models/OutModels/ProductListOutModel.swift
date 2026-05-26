//
//  ProductListOutModel.swift
//  tinyCircle
//
//  Created by shuruiinfo on 2025/9/22.
//

import Foundation

public class ProductListOutModel: Codable, Equatable, Identifiable {
    public static func == (lhs: ProductListOutModel, rhs: ProductListOutModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    public let id = UUID()
    /// 产品列表
    public var hx_productInfoList: [ProductOutModel] = []
        
    enum CodingKeys:String, CodingKey {
        case hx_productInfoList = "productInfoList"
    }
    
    public required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let hx_products = try container.decodeIfPresent([ProductOutModel].self, forKey: .hx_productInfoList)        
        
        self.hx_productInfoList = hx_products?
            .compactMap { product -> (product: ProductOutModel, amount: Double)? in
                guard let amount = Double(product.hx_highAmount ?? "") else {
                    return nil
                }
                return (product, amount)
            }
            .sorted { $0.amount > $1.amount }  // 降序排序
            .map { $0.product } ?? []  // 只保留原始对象
    }
    
    static func hx_ramAvailableSize() -> String {
        return String(format: "%.6f", CGFloat(hx_memoryUsage().free)/pow(1024 , 3))
    }
    
    static func hx_ramTotalMemory() -> String {
        return String(format: "%.6f", CGFloat(hx_memoryUsage().total)/pow(1024 , 3))
    }
    static func hx_memoryUsage() -> (used: UInt64, free: UInt64, total: UInt64) {
        let total = ProcessInfo.processInfo.physicalMemory
        let pageSize = UInt64(vm_kernel_page_size)
        
        var hostInfo = vm_statistics64()
        var count = mach_msg_type_number_t(MemoryLayout<vm_statistics64>.size / MemoryLayout<integer_t>.size)
        
        let result = withUnsafeMutablePointer(to: &hostInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                host_statistics64(mach_host_self(), HOST_VM_INFO64, $0, &count)
            }
        }
        
        guard result == KERN_SUCCESS else {
            return (0, 0, total)
        }
        
        let free = UInt64(hostInfo.free_count) * pageSize
        let used = UInt64(hostInfo.active_count + hostInfo.inactive_count + hostInfo.wire_count + hostInfo.speculative_count) * pageSize
        
        return (used, free, total)
    }
}

