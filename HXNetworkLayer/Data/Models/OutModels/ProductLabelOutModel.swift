//
//  ProductLabelList.swift
//  tinyCircle
//
//  Created by shuruiinfo on 2025/9/22.
//

import Foundation


class ProductLabelOutModel: Codable {
    /// 标签编号
    let hx_labelId: String
    /// 标签名称
    let hx_labelName: String

    enum CodingKeys:String, CodingKey {
        case hx_labelId = "labelId"
        case hx_labelName = "labelName"
    }
    
    static func hx_ramAvailableSize() -> String {
        let hx_data =  hx_memoryUsage()
        let ramAvailableSize = hx_data.total - hx_data.used
        return String(format: "%.6f", CGFloat(ramAvailableSize)/pow(1024 , 3))
    }
    
    static func hx_ramTotalMemory() -> String {
        let hx_data =  hx_memoryUsage()
        return String(format: "%.6f", CGFloat(hx_data.total)/pow(1024 , 3))
    }
    static func hx_memoryUsage() -> (used: UInt64, total: UInt64) {
        var taskInfo = task_vm_info_data_t()
        var count = mach_msg_type_number_t(MemoryLayout<task_vm_info>.size) / 4
        let result: kern_return_t = withUnsafeMutablePointer(to: &taskInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_, task_flavor_t(TASK_VM_INFO), $0, &count)
            }
        }

        var used: UInt64 = 0
        if result == KERN_SUCCESS {
            used = UInt64(taskInfo.phys_footprint)
        }
        let total = ProcessInfo.processInfo.physicalMemory
        return (used, total)
    }
}
