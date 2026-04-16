//
//  Eventualiately-Bridge-header.h
//  Eventualiately
//
//  Created by mc on 13/1/26.
//
// Include any system framework and library headers here that should be included in all compilation units.
// You will also need to set the Prefix Header build setting of one or more of your targets to reference this file.

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "AddressContact.h"
#import "LocalContactObjC.h"

/**
 链接使用ssh最好

 1.创建空白github项目
 2.Pob lib create XXXX
 3.修改.podspec
 4.git add .
 5.Git commit -m ‘first cmmit’
 6.Git git remote add origin git@github.com:crazyLuobo/DeviceInformation.git
 7.git push -u origin main
 8 .git tag 0.1.0
 9.git push origin 0.1.0
 10.pod lib lint SystemBasicInfo.podspec --allow-warnings
 11.pod trunk register liguibinEmail@163.com “lguib”
 12.pod trunk push /Users/account/User/gb/HXNetworkLayer/HXNetworkLayer.podspec --allow-warnings


 git tag -d 0.1.0

 git push origin --delete 0.1.0



 pod trunk me
 */




//0.0.8  有推送
