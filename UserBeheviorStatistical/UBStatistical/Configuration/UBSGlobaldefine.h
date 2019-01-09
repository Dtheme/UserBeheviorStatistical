//
//  UBSGloabe.h
//  UserBeheviorStatistical
//
//  Created by dzw on 2019/1/9.
//  Copyright © 2019 dzw. All rights reserved.
//

#ifndef UBSGloabe_h
#define UBSGloabe_h


#ifdef DEBUG
# define NSLog(...) NSLog(__VA_ARGS__)
#else
# define NSLog(...) {}
#endif


#define UBS_Manager [AspectsStatisticalManager shareManager]
#define UBS_Storage [AspectsLocalStorage setupStorage]
#define UBS_Monitor [AspectsMonitor setupMonitor]

#define kEventTrack @"EventTrack"
#define kLiftCycleTrack @"LiftCycleTrack"
#define kConfigurationPlistFileName @"Aspects.plist"

#endif /* UBSGloabe_h */
