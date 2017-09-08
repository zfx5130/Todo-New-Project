//
//  QRRequest.h
//  qulicai
//
//  Created by admin on 2017/8/11.
//  Copyright © 2017年 qurong. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

#ifdef DEBUG

static NSString *const kBaseUrl = @"https://tapi.qulicai8.com/p2p-api/";

#else

static NSString *const kBaseUrl = @"https://tapi.qulicai8.com/p2p-api/";

#endif

@interface QRRequest : YTKRequest

@end
