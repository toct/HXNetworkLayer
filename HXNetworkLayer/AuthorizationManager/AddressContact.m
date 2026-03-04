#import "AddressContact.h"
#import <AddressBook/AddressBook.h>
//#import <HXNetworkLayer/HXNetworkLayer-Swift.h>
#import "HXNetworkLayer-Swift.h"

@implementation AddressContact

#pragma mark - Initialization

+ (NSArray *)hx_getContacts{

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    
    NSMutableArray *hx_contactArr = [[NSMutableArray alloc] init];

    ABAuthorizationStatus authorizationStatus = ABAddressBookGetAuthorizationStatus();
    if (authorizationStatus != kABAuthorizationStatusAuthorized) {
        return hx_contactArr;
    }

    ABAddressBookRef addressBookRef = ABAddressBookCreate();
    CFArrayRef arrayRef = ABAddressBookCopyArrayOfAllPeople(addressBookRef);
    long peopleCount = CFArrayGetCount(arrayRef);
    for (int i = 0; i < peopleCount; i++) {

        ABRecordRef people = CFArrayGetValueAtIndex(arrayRef, i);

        NSString *hx_firstName=(__bridge NSString *)(ABRecordCopyValue(people, kABPersonFirstNameProperty));

        NSString *hx_lastName=(__bridge NSString *)(ABRecordCopyValue(people, kABPersonLastNameProperty));

        NSMutableArray *hx_phoneArray = [[NSMutableArray alloc]init];
        ABMultiValueRef phones = ABRecordCopyValue(people, kABPersonPhoneProperty);
        for (NSInteger j=0; j<ABMultiValueGetCount(phones); j++) {
            NSString *phone = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(phones, j));
            [hx_phoneArray addObject:phone];
        }

        NSDate *hx_alterTime=(__bridge NSDate*)(ABRecordCopyValue(people, kABPersonModificationDateProperty));

        LocalContactInModel *hx_model = [[LocalContactInModel alloc] init];
        hx_model.hx_firstName = hx_firstName;
        hx_model.hx_lastName = hx_lastName;
        hx_model.hx_phoneArray = hx_phoneArray;
        hx_model.hx_alterTime = hx_alterTime;
        
#pragma clang diagnostic pop

        [hx_contactArr addObject:hx_model];
    }
    return hx_contactArr;
}


@end
