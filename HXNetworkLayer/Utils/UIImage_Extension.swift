

typealias SCImageData = (image:UIImage, base64:String, data:Data)

//MARK: Image Compress
extension UIImage:ImageCompress {
    func hx_imageCompressed() -> SCImageData? {
        let targetSize = hx_calculateTargetSize(for: self.size)
        if targetSize == CGSize.zero {
            return nil
        }
        var modifiedImage = self
        if targetSize != self.size {
            modifiedImage = hx_imageByModifieSize(self, targetSize)!
        }
        var data = modifiedImage.jpegData(compressionQuality: 1.0)!
        let size = CGFloat(data.count)
        if  size > 200 * 1024 && size < 600 * 1024 {
            let base64Str = data.base64EncodedString()
            let compressedImage = UIImage(data: data)!
            return (compressedImage,base64Str,data)
        }
        
        data = hx_binarySearch(modifiedImage, maxSize: 600 * 1024)!
        let base64Str = data.base64EncodedString()
        let compressedImage = UIImage(data: data)!
        return (compressedImage,base64Str,data)
    }
}

protocol ImageCompress: AnyObject{
}
extension ImageCompress {
    
    func hx_calculateTargetSize(for hx_size: CGSize) -> CGSize {
        let minAllowed: CGFloat = 256
        let maxAllowed: CGFloat = 4096
        
        let width = hx_size.width
        let height = hx_size.height
        // 计算缩放因子
        var hx_factor: CGFloat = 1.0
        // 如果图片太小，需要放大
        let minDimension = min(width, height)
        if minDimension < minAllowed {
            hx_factor = max(hx_factor, minAllowed / minDimension)
        }
        // 如果图片太大，需要缩小
        let maxDimension = max(width * hx_factor, height * hx_factor)
        if maxDimension > maxAllowed {
            hx_factor *= maxAllowed / maxDimension
        }
        let targetSize = CGSize(
            width: width * hx_factor,
            height: height * hx_factor
        )
        // 确保不会因浮点误差导致超出范围
        return CGSize(
            width: min(max(targetSize.width, minAllowed), maxAllowed),
            height: min(max(targetSize.height, minAllowed), maxAllowed)
        )
    }
    
    func hx_imageByModifieSize(_ image: UIImage, _ targetSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 1)
        image.draw(in: CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func hx_binarySearch(_ image: UIImage, maxSize: Int) -> Data? {
        var low: CGFloat = 0.1
        var high: CGFloat = 1.0
        var hx_data: Data?
        
        while high - low > 0.01 {
            let mid = (low + high) / 2
            guard let hx_imgData = image.jpegData(compressionQuality: mid) else {
                break
            }
            hx_data = hx_imgData
            if hx_imgData.count <= maxSize {
                low = mid // 尝试更高的质量
            } else {
                high = mid // 需要更低的压缩质量
            }
        }
        return hx_data
    }
}
