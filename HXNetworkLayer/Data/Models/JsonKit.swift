
import UIKit

class JsonKit{
 
    static func hx_jsonToString(_ obj:Any?) ->String? {
        guard let obj = obj else {
            return nil
        }
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: obj as Any, options:[])
            let string = String.init(data: jsonData, encoding: String.Encoding.utf8)
            return string
        }catch{
            print(error)
            return nil
        }
    }
    
    static func hx_jsonToModel<T:Codable>(_ obj:Any?,modelType:T.Type) ->T? {
        guard let obj = obj else {
            return nil
        }
        
        // 如果输入是Data类型，直接使用JSONDecoder解码
        if let data = obj as? Data {
            do {
                let model = try JSONDecoder().decode(modelType, from: data)
                return model
            } catch {
                print("Data解码失败: \(error)")
                return nil
            }
        }
        
        // 如果输入是JSON对象，先序列化为Data再解码
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: obj as Any, options:[])
            let model = try JSONDecoder().decode(modelType, from: jsonData)
            return model
        }catch{
            print("JSON序列化失败: \(error)")
            return nil
        }
    }
        
    static func hx_modelToJsonObject<T:Codable>(obj:T) -> [String: Any]? {
        do{
            let data = try JSONEncoder().encode(obj)
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            return json
        }catch{
            print(error)
            return nil
        }
    }
    
   
}
