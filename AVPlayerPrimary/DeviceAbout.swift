//
//  DeviceAbout.swift
//  AVPlayerPrimary
//
//  Created by 陈岩 on 2018/3/23.
//  Copyright © 2018年 陈岩. All rights reserved.
//

import UIKit

class DeviceAbout: NSObject {

}

/*
 
 AVCaptureDevice
 //获取手机上的设备
 + (NSArray *)devices;
 //获取手机上某种类型的设备
 + (NSArray *)devicesWithMediaType:(NSString *)mediaType;
 //得到某人制定类型的设备
 + (AVCaptureDevice *)defaultDeviceWithMediaType:(NSString *)mediaType;
 //得到指定ID类型的设备
 + (AVCaptureDevice *)deviceWithUniqueID:(NSString *)deviceUniqueID;
 
 //获取媒体的授权状态
 + (AVAuthorizationStatus)authorizationStatusForMediaType:(NSString *)mediaType;
 
 //为媒体请求用户的权限
 + (void)requestAccessForMediaType:(NSString *)mediaType completionHandler:(void(^)(BOOL granted))handler;
 
 //请求调节硬件配置的权限
 - (BOOL)lockForConfiguration:(NSError **)outError;
 
 //放弃调节硬件配置的权限
 - (void)unlockForConfiguration;
 
 //是否允许调节焦点模式
 - (BOOL)isFocusModeSupported:(AVCaptureFocusMode)focusMode;
 
 AVCaptureFocusModeLocked      关闭对焦
 AVCaptureFocusModeAutoFocus   自动对焦
 AVCaptureFocusModeContinuousAutoFocus  自动连续对焦
 
 //对焦模式
 @property(nonatomic) AVCaptureFocusMode focusMode;
 
 //是否允许设置自己感兴趣的焦点
 @property(nonatomic, readonly, getter=isFocusPointOfInterestSupported) BOOLfocusPointOfInterestSupported;
 
 //自己感兴趣的对焦点
 @property(nonatomic) CGPoint focusPointOfInterest;
 
 //是否允许调节焦点
 @property(nonatomic, readonly, getter=isAdjustingFocus) BOOL adjustingFocus;
 
 //自动对焦的范围是否有限制
 @property(nonatomic, readonly, getter=isAutoFocusRangeRestrictionSupported)BOOL autoFocusRangeRestrictionSupported;
 
 //自动对焦的区域限制
 @property(nonatomic) AVCaptureAutoFocusRangeRestrictionautoFocusRangeRestriction;
 AVCaptureAutoFocusRangeRestrictionNone  没有限制
 AVCaptureAutoFocusRangeRestrictionNear   近处
 AVCaptureAutoFocusRangeRestrictionFar    远处
 
 //是否支持平滑对焦
 @property(nonatomic, readonly, getter=isSmoothAutoFocusSupported) BOOLsmoothAutoFocusSupported NS_AVAILABLE_IOS(7_0);
 
 //是否允许平滑对焦
 @property(nonatomic, getter=isSmoothAutoFocusEnabled) BOOLsmoothAutoFocusEnabled NS_AVAILABLE_IOS(7_0);
 
 //曝光调节
 //是否允许调节曝光
 @property(nonatomic,readonly, getter=isAdjustingExposure) BOOL adjustingExposure
 
 //曝光模式
 @property(nonatomic)AVCaptureExposureMode exposureMode
 
 AVCaptureExposureModeLocked                 锁定曝光
 AVCaptureExposureModeAutoExpose             自动曝光
 AVCaptureExposureModeContinuousAutoExposure  自动持续曝光
 AVCaptureExposureModeCustom                 自定义曝光
 
 //曝光模式是否支持
 -(BOOL)isExposureModeSupported:(AVCaptureExposureMode)exposureMode
 
 //感兴趣的曝光点
 @property(nonatomic)CGPoint exposurePointOfInterest
 
 //是否支持感兴趣的曝光点调节
 @property(nonatomic,readonly, getter=isExposurePointOfInterestSupported) BOOLexposurePointOfInterestSupported
 
 //是否支持白平衡模式
 -(BOOL)isWhiteBalanceModeSupported:(AVCaptureWhiteBalanceMode)whiteBalanceMode
 
 AVCaptureWhiteBalanceModeLocked           锁定
 AVCaptureWhiteBalanceModeAutoWhiteBalance  自动白平衡
 AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance 自动持续白平衡
 
 //白平衡模式
 @property(nonatomic)AVCaptureWhiteBalanceMode whiteBalanceMode
 
 //是否允许调节白平衡
 @property(nonatomic,readonly, getter=isAdjustingWhiteBalance) BOOL adjustingWhiteBalance
 
 //
 @property(nonatomic)CGFloat videoZoomFactor
 
 //
 -(void)rampToVideoZoomFactor:(CGFloat)factor
 withRate:(float)rate
 
 //
 -(void)cancelVideoZoomRamp
 
 //
 @property(nonatomic,readonly, getter=isRampingVideoZoom) BOOL rampingVideoZoom
 
 //闪光灯设置
 //设备是否有闪光灯
 @property(nonatomic,readonly) BOOL hasFlash
 
 //闪光灯模式
 @property(nonatomic)AVCaptureFlashMode flashMode
 AVCaptureFlashModeOff     关
 AVCaptureFlashModeOn     开
 AVCaptureFlashModeAuto   自动
 
 // 是否支持设定的闪光灯模式
 -(BOOL)isFlashModeSupported:(AVCaptureFlashMode)flashMode
 
 //当前闪光灯是否处于活动状态
 @property(nonatomic,readonly, getter=isFlashActive) BOOL flashActive
 
 //当前闪光灯是否处于可用状态
 @property(nonatomic,readonly, getter=isFlashAvailable) BOOL flashAvailable
 
 //手电筒设置
 //当前设备是否有手电筒
 @property(nonatomic,readonly) BOOL hasTorch
 
 //手电筒是否可用
 @property(nonatomic,readonly, getter=isTorchAvailable) BOOL torchAvailable
 
 //手电筒是否处于活动状态
 @property(nonatomic,readonly, getter=isTorchActive) BOOL torchActive
 
 //手电筒亮度调节
 @property(nonatomic,readonly) float torchLevel
 
 //手电筒模式
 -(BOOL)isTorchModeSupported:(AVCaptureTorchMode)torchMode
 
 AVCaptureTorchModeOff    关
 AVCaptureTorchModeOn     开
 AVCaptureTorchModeAuto   自动
 
 //调节手电筒的亮度
 -(BOOL)setTorchModeOnWithLevel:(float)torchLevel
 error:(NSError**)outError
 
 //低亮度设置
 //是否支持低亮度下提高亮度
 @property(nonatomic,readonly, getter=isLowLightBoostSupported) BOOL lowLightBoostSupported
 
 //是否允许低亮度调节
 @property(nonatomic,readonly, getter=isLowLightBoostEnabled) BOOL lowLightBoostEnabled
 
 //自动允许低亮状态下提高亮度
 @property(nonatomic)BOOL automaticallyEnablesLowLightBoostWhenAvailable
 
 //屏幕比率设置
 
 //最小屏幕的持续时间
 @property(nonatomic)CMTime activeVideoMinFrameDuration
 
 //最大屏幕的持续时间
 @property(nonatomic)CMTime activeVideoMaxFrameDuration
 
 
 //监测区域的改变
 //是否允许监视区域的改变，便于重新聚焦 调节白平衡，调节曝光等
 @property(nonatomic,getter=isSubjectAreaChangeMonitoringEnabled) BOOLsubjectAreaChangeMonitoringEnabled
 
 //检查设备的特性
 
 //当前设备是否连接
 @property(nonatomic,readonly, getter=isConnected) BOOL connected
 
 // 当前设备的位置
 @property(nonatomic,readonly) AVCaptureDevicePosition position
 
 AVCaptureDevicePositionUnspecified  未制定
 AVCaptureDevicePositionBack        后
 AVCaptureDevicePositionFront      前
 
 //判断当前设备是否有给定的媒体类型
 -(BOOL)hasMediaType:(NSString *)mediaType
 
 //modelID  所有设备相同model的不同ID
 @property(nonatomic,readonly) NSString *modelID
 
 // 设备的本地名字
 @property(nonatomic,readonly) NSString *localizedName
 
 //uniqueID
 @property(nonatomic,readonly) NSString *uniqueID
 
 //是否允许捕捉期间预先设置参数
 -(BOOL)supportsAVCaptureSessionPreset:(NSString *)preset
 
 //镜头的光圈 （只读）
 @property(nonatomic,readonly) float lensAperture
 
 //镜头的位置
 // 镜头的位置（只读）
 @property(nonatomic,readonly) float lensPosition
 
 //调节镜头的位置
 -(void)setFocusModeLockedWithLensPosition:(float)lensPosition
 completionHandler:(void(^)(CMTime syncTime))handler
 
 //图像曝光
 //曝光时长（只读）
 @property(nonatomic,readonly) CMTime exposureDuration
 
 //调解自定义曝光模式和时长
 -(void)setExposureModeCustomWithDuration:(CMTime)duration
 ISO:(float)ISO
 completionHandler:(void(^)(CMTime syncTime))handler
 
 //曝光的偏移量
 @property(nonatomic,readonly) float exposureTargetOffset
 
 //曝光目标的倾斜
 @property(nonatomic,readonly) float exposureTargetBias
 
 //最大的倾斜
 @property(nonatomic,readonly) float maxExposureTargetBias
 
 //最小的倾斜
 @property(nonatomic,readonly) float maxExposureTargetBias
 
 //调节曝光倾斜
 -(void)setExposureTargetBias:(float)bias
 completionHandler:(void(^)(CMTime syncTime))handler
 
 
 //白平衡
 //白平衡色度调节
 -(AVCaptureWhiteBalanceChromaticityValues)chromaticityValuesForDeviceWhiteBalanceGains:(AVCaptureWhiteBalanceGains)whiteBalanceGains
 
 //获取白平衡增益
 @property(nonatomic,readonly) AVCaptureWhiteBalanceGains deviceWhiteBalanceGains
 
 //最大的白平衡增益
 @property(nonatomic,readonly) float maxWhiteBalanceGain
 
 //设备的白平衡色彩度
 -(AVCaptureWhiteBalanceGains)deviceWhiteBalanceGainsForChromaticityValues:(AVCaptureWhiteBalanceChromaticityValues)chromaticityValues
 
 //温度和色彩度的白平衡调节
 -(AVCaptureWhiteBalanceGains)deviceWhiteBalanceGainsForTemperatureAndTintValues:(AVCaptureWhiteBalanceTemperatureAndTintValues)tempAndTintValues
 
 //
 @property(nonatomic,readonly) AVCaptureWhiteBalanceGains grayWorldDeviceWhiteBalanceGains
 
 //
 -(void)setWhiteBalanceModeLockedWithDeviceWhiteBalanceGains:(AVCaptureWhiteBalanceGains)whiteBalanceGains
 completionHandler:(void(^)(CMTime syncTime))handler
 
 //
 -(AVCaptureWhiteBalanceTemperatureAndTintValues)temperatureAndTintValuesForDeviceWhiteBalanceGains:(AVCaptureWhiteBalanceGains)whiteBalanceGains
 
 //ISO
 
 //曝光的ISO值
 @property(nonatomic,readonly) float ISO
 
 
 //HDR
 
 //是否允许自动调节HDR
 @property(nonatomic)BOOL automaticallyAdjustsVideoHDREnabled
 
 //是否允许HDR调节
 @property(nonatomic,getter=isVideoHDREnabled) BOOL videoHDREnabled
 
 
 //常量
 AVCaptureDevicePositionUnspecified = 0, 未规定
 AVCaptureDevicePositionBack  = 1,   后
 AVCaptureDevicePositionFront = 2   前
 
 AVCaptureFlashModeOff    = 0, 闪光灯关
 AVCaptureFlashModeOn     = 1, 闪光灯开
 AVCaptureFlashModeAuto   = 2  自动
 
 AVCaptureTorchModeOff    = 0, 手电筒关
 AVCaptureTorchModeOn     = 1, 手电筒开
 AVCaptureTorchModeAuto   = 2  手电筒自动
 
 const float AVCaptureMaxAvailableTorchLevel  手电筒最大亮度
 
 AVCaptureFocusModeLocked               = 0, 不对焦
 AVCaptureFocusModeAutoFocus            = 1,  自动对焦
 AVCaptureFocusModeContinuousAutoFocus   = 2,  持续对焦
 
 AVCaptureExposureModeLocked                   = 0, 不曝光
 AVCaptureExposureModeAutoExpose               = 1, 自动曝光
 AVCaptureExposureModeContinuousAutoExposure    = 2, 持续曝光
 AVCaptureExposureModeCustom                   = 3, 自定义曝光
 
 AVCaptureWhiteBalanceModeLocked            = 0,  关闭拍平衡模式
 AVCaptureWhiteBalanceModeAutoWhiteBalance   = 1, 自动白平衡
 AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance = 2, 持续拍平衡
 
 AVAuthorizationStatusNotDetermined = 0, 授权状态不确定
 AVAuthorizationStatusRestricted,   受限制的授权状态
 AVAuthorizationStatusDenied,       无权访问
 AVAuthorizationStatusAuthorized    授权
 
 AVCaptureAutoFocusRangeRestrictionNone = 0, 自动对焦区域无限制
 AVCaptureAutoFocusRangeRestrictionNear = 1, 近
 AVCaptureAutoFocusRangeRestrictionFar  = 2, 远
 
 const AVCaptureWhiteBalanceGainsAVCaptureWhiteBalanceGainsCurrent; 当前白平衡增益
 
 const float AVCaptureLensPositionCurrent  当前镜头位置
 
 const float AVCaptureISOCurrent 当前ISO
 
 const float AVCaptureExposureTargetBiasCurrent 当前曝光倾斜
 
 const CMTime AVCaptureExposureDurationCurrent; 当前曝光时间
 
 
 //通知Notifications
 AVCaptureDeviceWasConnectedNotification  已连接通知
 AVCaptureDeviceWasDisconnectedNotification 未连接通知
 AVCaptureDeviceSubjectAreaDidChangeNotification 区域改变通知
 
 */
