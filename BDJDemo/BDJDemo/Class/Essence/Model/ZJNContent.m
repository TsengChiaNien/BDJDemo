//
//  ZJNContent.m
//  百思不得姐
//
//  Created by 曾嘉年 on 16/6/2.
//  Copyright © 2016年 zengjianian. All rights reserved.
//

#import "ZJNContent.h"
#import "ZJNComment.h"
#import "ZJNCommentUser.h"
#import <objc/runtime.h>
#import <MJExtension.h>

@interface ZJNContent () <NSCopying>

@end

@implementation ZJNContent
#pragma mark  - 声明私有属性
{
    CGFloat _cellHeight;
}
#pragma mark - MJExtension功能
/** 字典关键字转换 */
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"ID": @"id",
             @"content_image": @"image1",
             @"content_voice": @"voiceuri",
             @"content_video": @"videouri",
             @"top_cmt": @"top_cmt[0]"
             };
}
/** 模型内数组字典转换模型 */
//+ (NSDictionary *)mj_objectClassInArray {
//    return @{
//             @"top_cmt": @"ZJNComment"
//             };
//}
#pragma mark - 评论栏数据数据处理
- (NSString *)love {
    NSUInteger count = [_love integerValue];
    if (count == 0) {
        return @"赞";
    } else if (count < 10000) {
        return _love;
    } else return @"9999+";
}
- (NSString *)hate {
    NSUInteger count = [_hate integerValue];
    if (count == 0) {
        return @"踩";
    } else if (count < 10000) {
        return _hate;
    } else return @"9999+";
}
- (NSString *)repost {
    NSUInteger count = [_repost integerValue];
    if (count == 0) {
        return @"分享";
    } else if (count < 10000) {
        return _repost;
    } else return @"9999+";
}
- (NSString *)comment {
    NSUInteger count = [_comment integerValue];
    if (count == 0) {
        return @"评论";
    } else if (count < 10000) {
        return _comment;
    } else return @"9999+";
}
#pragma mark - 发布时间数据处理
- (NSString *)created_at {
    //获取当前时间
    NSDate *now = [NSDate date];
    //获取服务器帖子创建时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *createTime = [formatter dateFromString:_created_at];
    //得到创建时间与当前时间的差值(单位:second)
    NSTimeInterval delta = [now timeIntervalSinceDate:createTime];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *creatTimeComponents = [calendar components:unit fromDate:createTime];
    
    
    if (delta < 10 * 60) return @"刚刚";
    if (delta < 1 * 60 * 60) return [NSString stringWithFormat:@"%zd分钟前",(NSUInteger)(delta / 60)];
    else if (delta < 24 * 60 * 60) return [NSString stringWithFormat:@"%zd小时前",(NSUInteger)(delta / 60 / 60)];
    else if (delta < 48 * 60 * 60) {
        if ([createTime jn_isYesterday])
            return [NSString stringWithFormat:@"昨天 %02zd:%02zd",creatTimeComponents.hour,creatTimeComponents.minute];
        else
            return [NSString stringWithFormat:@"前天 %02zd:%02zd",creatTimeComponents.hour,creatTimeComponents.minute];
    }
    else if (delta < 72 * 60 * 60 ) {
        if ([createTime jn_isTheDayBeforeYesterday])
            return [NSString stringWithFormat:@"前天 %02zd:%02zd",creatTimeComponents.hour,creatTimeComponents.minute];
        else
            return [NSString stringWithFormat:@"%02zd-%02zd",creatTimeComponents.month,creatTimeComponents.day];
    }
    if ([createTime jn_isThisYear]) return [NSString stringWithFormat:@"%02zd-%02zd",creatTimeComponents.month,creatTimeComponents.day];
    else return [NSString stringWithFormat:@"%04zd-%02zd-%02zd",creatTimeComponents.year,creatTimeComponents.month,creatTimeComponents.day];
}
#pragma mark - 播放时长数据处理
- (NSString *)voicetime {
    NSInteger duration = [_voicetime integerValue];
    self.voiceDuration = duration;
    NSInteger min = duration / 60;
    NSInteger sec = duration % 60;
    return [NSString stringWithFormat:@"%02zd:%02zd",min,sec];
}
- (NSString *)videotime {
    NSInteger duration = [_videotime integerValue];
    self.videoDuration = duration;
    NSInteger min = duration / 60;
    NSInteger sec = duration % 60;
    return [NSString stringWithFormat:@"%02zd:%02zd",min,sec];
}
#pragma mark - cell高度计算
- (CGFloat)cellHeight {
    if (!_cellHeight) {
        CGFloat textH = [self.text jn_stringHeightWithFontSize:17 width:(ZJNScreenWidth - 2 * jn_textMargin) lineSpacing:10.];
        ZJNComment *cmt = self.top_cmt;
        if (cmt) {
            NSString *cmtContent = [NSString stringWithFormat:@"%@: %@",cmt.user.username,cmt.content];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:5.];
            CGFloat cmtH = [cmtContent jn_stringHeightWithFontSize:14.5 width:(ZJNScreenWidth - 2 * jn_textMargin) lineSpacing:5.];
            _cellHeight = jn_cellMargin + cmtH + jn_topCmtTitleHeight;
        }
        _cellHeight = _cellHeight + jn_textY + textH + jn_textMargin + jn_cellMargin +jn_commentH;
        if (self.type == kZJNContentTypePhotos) {
            CGFloat photoY = jn_textY + textH + jn_textMargin;
            CGFloat photoW = ZJNScreenWidth - 2 * jn_textMargin;
            CGFloat photoH = photoW * self.height / self.width;
            if (photoH > jn_photoMaxHeight) {
                self.tooLong = YES;
                photoH = jn_partPhotoHeight;
            }
            _contentImageFrame = CGRectMake(jn_photoX, photoY, photoW, photoH);
            _cellHeight = jn_photoMargin + photoH + _cellHeight;
        }
        if (self.type == kZJNContentTypeSound) {
            CGFloat photoY = jn_textY + textH + jn_textMargin;
            CGFloat photoW = ZJNScreenWidth - 2 * jn_textMargin;
            CGFloat photoH = photoW * self.height / self.width;
            _contentVoiceFrame = CGRectMake(jn_photoX, photoY, photoW, photoH);
            _cellHeight = 2 * jn_photoMargin + photoH + _cellHeight;
        }
        if (self.type == kZJNContentTypevideo) {
            CGFloat photoY = jn_textY + textH + jn_textMargin;
            CGFloat photoW = ZJNScreenWidth - 2 * jn_textMargin;
            CGFloat photoH = photoW * self.height / self.width;
            if (photoH > jn_partPhotoHeight) {
                self.tooLong = YES;
                photoH = jn_partPhotoHeight;
            }
            _contentVideoFrame = CGRectMake(jn_photoX, photoY, photoW, photoH);
            _cellHeight = jn_photoMargin + photoH + _cellHeight;
        }
    }
    return _cellHeight;
}
#pragma mark - copy协议
- (id)copyWithZone:(nullable NSZone *)zone {
    ZJNContent *content = [[ZJNContent allocWithZone:zone] init];
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([ZJNContent class], &count);
    for (int i = 0; i < count; i++) {
        //获得属性名
        NSString *keyPath = @(ivar_getName(ivars[i]));
        //属性赋值
        [content setValue:[self valueForKeyPath:keyPath] forKeyPath:keyPath];
    }
    //释放内存
    free(ivars);
    return content;
}
@end
