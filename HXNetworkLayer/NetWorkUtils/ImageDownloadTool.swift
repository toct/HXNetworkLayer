//
//  ImageDownloadTool.swift
//  AnchorMedium
//
//  Created by mlgbb on 5/14/25.
//

import Foundation

class ImageDownloadTool {
    static let shared = ImageDownloadTool()
    static func hx_image(from url: String?, _ completion: @escaping (UIImage?) -> Void) {
        guard let hx_url = url else {
            completion(nil)
            return
        }
        
        ImageDownloadTool.shared.hx_downloadImage(hx_url) { hx_image in
            if let image = hx_image {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                print("image download failed")
                completion(nil)
            }
        }
    }
        
    private let hx_queue = DispatchQueue(label: "com.example.imageDownloadQueue", attributes: .concurrent)
    private var hx_pendingOperations: [String: Operation] = [:]
    private let hx_operationQueue: OperationQueue = {
        let hx_queue = OperationQueue()
        hx_queue.maxConcurrentOperationCount = 5
        return hx_queue
    }()
    
    private let hx_folder: URL = {
        let hx_link = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        let hx_folder = hx_link[0].appendingPathComponent("ImageCache")
        try? FileManager.default.createDirectory(at: hx_folder, withIntermediateDirectories: true, attributes: nil)
        return hx_folder
    }()
    
    private init() {}
    
    private func hx_downloadImage(_ hx_link: String, completion: @escaping (UIImage?) -> Void) {
        let hx_name = hx_link.hx_md5 + ".jpg"
        let hx_path = hx_folder.appendingPathComponent(hx_name)
        
        if let hx_image = hx_loadCachedImage(hx_path) {
            DispatchQueue.main.async {
                completion(hx_image)
            }
            return
        }
        
        let operation = BlockOperation { [weak self] in
            guard let self = self else { return }
            
            if let hx_image = self.hx_loadCachedImage(hx_path) {
                DispatchQueue.main.async {
                    completion(hx_image)
                }
                return
            }
            
            guard let hx_url = URL(string: hx_link),
                  let hx_data = try? Data(contentsOf: hx_url),
                  let hx_image = UIImage(data: hx_data) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            try? hx_data.write(to: hx_path)
            
            DispatchQueue.main.async {
                completion(hx_image)
            }
        }
        
        hx_queue.async(flags: .barrier) {
            self.hx_pendingOperations[hx_link] = operation
            self.hx_operationQueue.addOperation(operation)
        }
    }
    
    private func hx_loadCachedImage(_ hx_url: URL) -> UIImage? {
        guard FileManager.default.fileExists(atPath: hx_url.path) else {
            return nil
        }
        
        if let hx_data = try? Data(contentsOf: hx_url), let hx_image = UIImage(data: hx_data) {
            return hx_image
        }
        
        return nil
    }
    
    func hx_cancelDownload(_ hx_link: String) {
        hx_queue.async(flags: .barrier) {
            if let operation = self.hx_pendingOperations[hx_link] {
                operation.cancel()
                self.hx_pendingOperations.removeValue(forKey: hx_link)
            }
        }
    }
}
