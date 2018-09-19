//
//  LXCameraConfig.h
//  ZXDemo
//
//  Created by 周鑫 on 2018/8/26.
//  Copyright © 2018年 ZX. All rights reserved.
//

#ifndef LXCameraConfig_h
#define LXCameraConfig_h

// 相机类型
typedef NS_ENUM(NSUInteger, LXCameraType) {
    LXCameraTypeUnknown,
    LXCameraTypeDefault,
    LXCameraTypeStillCamera = LXCameraTypeDefault,
    LXCameraTypeVideoCamera,
};


typedef NS_ENUM(NSUInteger, LXCameraMaskType) {
     LXCameraMaskTypeUnknown,
    LXCameraMaskTypeDefault,
     LXCameraMaskType1_1,
    LXCameraMaskType4_3,
    LXCameraMaskType16_9,
    LXCameraMaskTypeRound,    // 圆形
    LXCameraMaskTypeOval,    //  椭圆
    LXCameraMaskTypeTriangle,    // 三角形
    LXCameraMaskTypePentagon,   // 五角性
    LXCameraMaskTypeHexagon,   // 六角形
   
};


#endif /* LXCameraConfig_h */
