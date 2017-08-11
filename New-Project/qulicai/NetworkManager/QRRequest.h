//
//  QRRequest.h
//  qulicai
//
//  Created by admin on 2017/8/11.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

#ifdef DEBUG

static NSString *const kBaseUrl = @"http://192.168.1.223:8999/p2p-api";

#else

static NSString *const kBaseUrl = @"http://120.27.130.97:8999/p2p-api";

#endif


@interface QRRequest : YTKRequest

@end
