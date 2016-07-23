# BDJ App Demo
A demo of BDJ app

##Screen Shot
![image](https://github.com/TsengChiaNien/BDJDemo/raw/master/ScreenShot/1.jpg)
![image](https://github.com/TsengChiaNien/BDJDemo/raw/master/ScreenShot/2.jpg)

![image](https://github.com/TsengChiaNien/BDJDemo/raw/master/ScreenShot/3.jpg)
![image](https://github.com/TsengChiaNien/BDJDemo/raw/master/ScreenShot/4.jpg)

![image](https://github.com/TsengChiaNien/BDJDemo/raw/master/ScreenShot/5.jpg)
![image](https://github.com/TsengChiaNien/BDJDemo/raw/master/ScreenShot/6.jpg)

![image](https://github.com/TsengChiaNien/BDJDemo/raw/master/ScreenShot/7.jpg)
![image](https://github.com/TsengChiaNien/BDJDemo/raw/master/ScreenShot/8.jpg)

##开发环境
- XCode 7, iOS 8 SDK, iPhone模拟器, 只支持垂直方向, 已屏幕适配
- 第三方框架
  - AFNetworking, 用于精华、新帖和推荐标签等获取服务器数据
  - SDWebImage, 下载用户头像、推荐标签图标和帖子图片内容等网络图片
  - MJExtension, 解析从服务器获取到的JSON数据
  - MJRefresh, 精华、新帖和评论界面等的上、下拉刷新
  - SVProgressHUD, app的一些状态提醒
  - pop, 发布界面的动画
  - M13ProgressSuite, 帖子图片缓存时的进度条
  - FreeStreamer, 处理音乐流媒体
  - NJKWebViewPorgress, 模拟浏览器进度条
- 在demo运行之前, 需要将仓库的ImageResource压缩包的图片拖进项目中

##demo的一些处理
- 文本处理
  - 帖子的发帖时间根据距离现在时间的长短, 在对应的Model中做处理
  - 帖子、评论的文本内容根据是否需要换行, 设置Label文本为NSString还是NSAttributedString
- 图像处理
  - 帖子、评论的圆形头像, 标签的圆角icon使用CoreGraphics进行绘图, 并且利用GCD在子线程渲染
  - 图片帖子长图片的缩略图也使用CoreGraphics绘图, 在子线程渲染
- 音频处理 
  - 点击音乐帖子的播放按钮可以播放网络音乐, 可以拖拽进度条改变播放进度, 同一时间只播放一首歌曲
- 视频处理
  - 点击视频按钮可以播放视频, 可拖拽进度条改变播放进度, 进度条可以自动隐藏或者点击显示或隐藏
  - 视频可以全屏播放
  - 当滑动界面使视频不显示时, 自动停止播放视频
- 文件
  - 点击大图后可以保存图片至本地相册
  - 图片和音乐在Library/Cache的缓存文件大小显示在"我"模块的设置界面上, 通过点击cell清除缓存文件
- 其他细节处理
  - 登录界面用单例设计
  - 点击tabbar上精华、新帖的icon可以刷新当前内容
  - 点击statusBar时当前显示的scrollView回滚到顶部
  - 长按评论文字内容显示UIMenuController, 对内容点赞或取消、回复、举报
  - 发表文字时, 添加标签的动画设计
  - 左边缘滑动pop view controller
  - 音乐帖子的背景图片底部加上了一层CAGrandientLayer, 使进度时间能清晰显示

##demo已知的一些bug(正在处理中)
- 进入评论界面后cell的frame有改变
- 音乐帖子进入评论界面时进度条不更新进度
- "我的关注"进入"推荐关注", 在加载某个大图片头像时会crash
