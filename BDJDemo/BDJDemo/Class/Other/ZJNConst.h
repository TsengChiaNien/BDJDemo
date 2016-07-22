#import <Foundation/Foundation.h>
/** 精华,新帖帖子类型 */
typedef enum {
    kZJNContentTypeAll = 1,
    kZJNContentTypePhotos = 10,
    kZJNContentTypeSmallStory = 29,
    kZJNContentTypeSound = 31,
    kZJNContentTypevideo = 41
} ZJNContentType;

/** 主界面tabBar被点击的通知 */
UIKIT_EXTERN NSString * const ZJNTabBarDidClickNotification;

/** 精华,新帖模块标签视图宽度 */
UIKIT_EXTERN CGFloat const jn_tagViewHeight;

/** 精华,新帖cell边缘宽度 */
UIKIT_EXTERN CGFloat const jn_cellMargin;
/** 精华,新帖cell中文本内容的Y值 */
UIKIT_EXTERN CGFloat const jn_textY;
/** 精华,新帖cell中文本内容的边缘宽度 */
UIKIT_EXTERN CGFloat const jn_textMargin;
/** 精华,新帖cell评论区高度 */
UIKIT_EXTERN CGFloat const jn_commentH;
/** 精华,新帖cell图片的X值 */
UIKIT_EXTERN CGFloat const jn_photoX;
/** 精华,新帖cell图片的边缘宽度 */
UIKIT_EXTERN CGFloat const jn_photoMargin;
/** 精华,新帖cell图片最大高度 */
UIKIT_EXTERN CGFloat const jn_photoMaxHeight;
/** 精华,新帖cell缩略图片高度 */
UIKIT_EXTERN CGFloat const jn_partPhotoHeight;
/** 精华,新帖cell热门评论标题高度 */
UIKIT_EXTERN CGFloat const jn_topCmtTitleHeight;

/** 男的评论 */
UIKIT_EXTERN NSString * const ZJNCommentGenderMale;
/** 女的评论 */
UIKIT_EXTERN NSString * const ZJNCommentGenderFemale;
/** 评论内容X值 */
UIKIT_EXTERN CGFloat const jn_commentTextX;
/** 评论内容Y值 */
UIKIT_EXTERN CGFloat const jn_commentTextY;
/** 评论内容右侧边距 */
UIKIT_EXTERN CGFloat const jn_commentTextMargin;
/** 声音按钮高度 */
UIKIT_EXTERN CGFloat const jn_commentVoiceH;

/** 发段子文本边缘宽度 */
UIKIT_EXTERN CGFloat const jn_publishTextMargin;

/** 播放器状态改变的通知 */
UIKIT_EXTERN NSString * const ZJNPlayerStatusDidChangeNotification;