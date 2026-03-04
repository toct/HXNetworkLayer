@objcMembers class LocalContactInModel: NSObject, Codable {
    var hx_firstName: String?
    var hx_lastName: String?
    var hx_phoneArray: [String]?
    var hx_creatTime: Date?
    var hx_alterTime: Date?
    
    var hx_contacts: [ContactInModel]? {
        get {
            var hx_models: [ContactInModel] = []
            
            guard let hx_phoneNums = hx_phoneArray,  !hx_phoneNums.isEmpty else { return [] }
            
            let hx_name = ((hx_lastName ?? "") + (hx_firstName ?? "")).trimmingCharacters(in: CharacterSet.whitespaces)

            for hx_phoneNum in hx_phoneNums {
                
                let hx_phone = hx_phoneNum.hx_philippinePhone.trimmingCharacters(in: CharacterSet.whitespaces).hx_philippinePhone
                if hx_phone.isEmpty { continue }
                var hx_time = String(format: "%.f", ((hx_alterTime?.timeIntervalSince1970 ?? 0) * 1000))
                hx_time = hx_time == "0" ? "" : hx_time
                
                let hx_model = ContactInModel()
                hx_model.hx_contactName = hx_name
                hx_model.hx_contactPhone = hx_phone
                hx_model.hx_contactUpdateTime = hx_time
                hx_model.hx_contactStorage = "-1"
                hx_model.hx_contactCount = "-99"
                hx_model.hx_contactTime = ""
                
                hx_models.append(hx_model)
            }
            return hx_models
        }
    }
}
