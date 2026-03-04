import Foundation
import Contacts

class Contact: NSObject{
    
    static let shared = Contact()
    
    let hx_store = CNContactStore()

    var hx_callback: CallBackType?
    
    //get Contacts Access
    func hx_getContactsAuthorization(_ maxNumber: Int = Int(INT_MAX)) {
        hx_store.requestAccess(for: .contacts) { [self] (granted, error) in
            if let error = error, !granted {
                print("Error requesting access: \(error.localizedDescription)")
                DispatchQueue.main.async { [self] in
                    hx_callback?(.authorization, .denied,[])
                }
            }else{
                let hx_authStatus = CNContactStore.authorizationStatus(for: .contacts)
                // Fallback on earlier versions
                hx_fetchContacts(maxNumber, hx_authStatus == .authorized, CheckType: .authorization)
            }
        }
    }
   
    private func hx_fetchContacts(_ maxNumber: Int = Int(INT_MAX), _ isAuthorized: Bool, CheckType: CheckType) -> ()
    {
        DispatchQueue.global().async {
            
            var hx_contacts: [LocalContactInModel] = []
            
            if isAuthorized {
                if let objcArr = AddressContact.hx_getContacts() as? [LocalContactObjC] {
                    let converted: [LocalContactInModel] = objcArr.map { obj in
                        let m = LocalContactInModel()
                        m.hx_firstName = obj.hx_firstName
                        m.hx_lastName = obj.hx_lastName
                        m.hx_phoneArray = obj.hx_phoneArray as? [String]
                        m.hx_alterTime = obj.hx_alterTime
                        return m
                    }
                    hx_contacts.append(contentsOf: converted)
                }
            }else{
                let hx_cotactArr = self.hx_getContacts()
                hx_contacts.append(contentsOf: hx_cotactArr)
            }
            
            var hx_contactDatas:[ContactInModel] = []
            
            var phoneAssets:[String] = []
            
            for hx_contact in hx_contacts {
                            
                guard let hx_contacts = hx_contact.hx_contacts, !hx_contacts.isEmpty else { continue }
                
                for hx_contact in hx_contacts {
                    
                    if !phoneAssets.contains(hx_contact.hx_contactPhone) && phoneAssets.count < maxNumber{
                        
                        hx_contactDatas.append(hx_contact)
                        phoneAssets.append(hx_contact.hx_contactPhone)
                    }
                }
            }
         
            DispatchQueue.main.async { [weak self] in
                if isAuthorized {
                    self?.hx_callback?(CheckType, .authorized, hx_contactDatas)
                } else {
                    if #available(iOS 18.0, *) {
                        self?.hx_callback?(CheckType, .limited, hx_contactDatas)
                    }
                }
            }
        }
    }
    
    private func hx_getContacts() -> [LocalContactInModel] {
        var hx_contactArr:[LocalContactInModel] = []
        let hx_fetchKeys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor]
        let hx_request = CNContactFetchRequest(keysToFetch: hx_fetchKeys)
        do {
            try hx_store.enumerateContacts(with: hx_request) { (contact, cursor) in
                let hx_phoneArr = contact.phoneNumbers.map({ $0.value.stringValue })

                let hx_model = LocalContactInModel()
                hx_model.hx_firstName = contact.givenName
                hx_model.hx_lastName = contact.familyName
                hx_model.hx_phoneArray = hx_phoneArr
                
                hx_contactArr.append(hx_model)
            }
        } catch {
            print("Contacts get contacts error : \(error)")
        }
        return hx_contactArr
    }
    
    
    static func hx_getContacts(_ maxNumber: Int = Int(INT_MAX), _ closer: @escaping CallBackType) {
        
        let hx_status = CNContactStore.authorizationStatus(for: .contacts)
        switch hx_status {
        case .notDetermined:
            shared.hx_callback = closer
            shared.hx_getContactsAuthorization(maxNumber)
            return
        case .restricted:
            closer(.inquire, .restricted, [])
        case .denied:
            closer(.inquire, .denied, [])
        case .limited:
            shared.hx_callback = closer
            shared.hx_fetchContacts(maxNumber, hx_status == .authorized, CheckType: .inquire)
        case .authorized:
            shared.hx_callback = closer
            shared.hx_fetchContacts(maxNumber, hx_status == .authorized, CheckType: .inquire)
        @unknown default:
            return
        }
    }
}
