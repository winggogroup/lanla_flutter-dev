main() {
  final keys = {
    '首页': 'الرئيسية',
    '关注': 'متابعة',
    '发现': 'استكشف',
    '我': 'صفحتي',
    '推荐': 'لك',
    '发现': 'استكشف',
    '附近': 'بالقرب منك',
    '说点什么': 'قل شيئا',
    '编辑': 'تعديل',
    '不喜欢': 'لا يعجبني',
    '加载更多评论': 'تحميل المزيد من التعليقات',
    '欢迎来到LanLa': 'مرحبا بك في LanLa',
    '请输入手机号码': 'يرجى إدخال رقم الهاتف المحمول',
    '登录/注册': 'تسجيل الدخول/التسجيل',
    '验证码验证': 'رمز التحقق',
    '获取验证码': 'احصل على رمز التحقق',
    '请输入验证码': 'يرجى إدخال رمز التحقق',
    '下一步': 'الخطوة التالية',
    '重新发送': 'إعادة إرسال',
    '请输入密码': 'قم بإدخال كلمة المرور',
    '设置至少6个新密码': 'ضبط ما لا يقل عن 6 كلمات مرور جديدة',
    '完成': 'تم',
    '欢迎来到LanLa': 'مرحبا بك فيLanLa',
    '填写信息个性化你的内容': 'اكمل المعلومات , لتخصيص المحتوى الخاص بك',
    '男': 'ذكر',
    '女': 'أنثى',
    '选择你的生日': 'اختر عيد ميلادك',
    '选择感兴趣的内容': 'اختر ما يهمك',
    '根据兴趣生成你的内容': 'أنشئ المحتوى الخاص بك بناءً على الاهتمامات',
    '请完善信息': 'يرجى استكمال المعلومات',
    '您的美好生活指南！': 'دليلك لحياة رائعة!',
    '手机': 'الهاتف',
    '或': 'أو',
    '登录或注册意味着您同意': 'أوتسجيل الدخول أو التسجيل يعني أنك توافق على',
    '隐私政策': 'سياسة الخصوصية',
    '用户协议': 'بروتوكول المستخدم',
    '与': 'مع',
    '查看全文': 'عرض كامل النص',
    '粉丝': 'معجبين',
    '获赞和收藏': 'الإعجابات والمفضلة',
    '笔记正在上传，请不要关闭app': 'تحميل ، من فضلك لا تغلق',
    '上传提示': 'شارك مع الأصدقاء للحصول على المزيد 👍🏻',
    '不感兴趣内容': 'غير مهتم',
    '不喜欢该作者': 'لا يعجبني هذا المحتوى',
    '举报': 'إبلاغ',
    '搜索国家': 'بلد البحث',
    '搜索': 'بحث',
    '输入搜索内容': 'أدخل محتوى البحث',
    '搜索内容': 'البحث',
    '历史记录': 'سجل التاريخ',
    '本周排行': 'الترتيب هذا الأسبوع',
    '本月排行': 'الترتيب في هذا الشهر',
    '热度排行': 'تصنيف الترند',
    '没有内容': 'لا يوجد محتوى',
    '没有更多内容了': 'لا مزيد من المحتوى',
    '登录失败': 'فشل تسجيل الدخول',
    '用户': 'المستخدم',
    '所有': 'كل',
    '取消关注': 'إلغاء المتابعة',
    '已关注': 'أتابعه',
    '清除成功': 'تم المسح بنجاح',
    '作品': 'الأعمال',
    '收藏': 'المفضلة',
    '赞过': 'الإعجابات',
    '条评论': 'تعليق',
    '欢迎说出你的评论': 'نرحب بتعليقاتكم',
    '还没有关注的人': 'لايوجد لديك متابعين بعد',
    '关注后，可以在这里查看对方的最新动态': 'بعد المتابعة , تستطيع  استكشاف احدث التحركات',
    '我的消息': 'رسالتي',
    '赞和收藏': 'الإعجابات والمفضلة',
    '新增关注': 'إضافة متابعة',
    '评论和@': 'قام بمنشنك على',
    '选择频道': 'حدد القناة',
    '请选择频道': 'الرجاء تحديد قناة',
    '请选择标题': 'الرجاء تحديد عنوان',
    '说说你此刻的心情': 'قل لي كيف تشعر في هذه اللحظة',
    '发布笔记': 'الملاحظات اللاحقة',
    '添加图片': 'أضف الصور',
    '写标题会得到更多赞哦': 'اكتب عنوانًا لتحصل على المزيد من الإعجابات',
    '拍摄': 'تصوير',
    '从相册选择': 'اختيار من ألبوم',
    '取消': 'إلغاء',
    '照片或视频': 'الصور أو الفيديو',
    '名字': 'اسم',
    '简单介绍': 'مقدمة أساسية',
    '条评论': ' تعليقات في المجموع',
    '评论': 'تعليق',
    '还没有评论哟': 'لا توجد تعليقات حتى الآن',
    '发布': 'إرسال',
    '请填写评论内容': 'الرجاء ملء محتوى التعليقات',
    '评论成功': '💖 نجح التعليق',
    '再点一次退出应用': 'انقر مرة أخرى للخروج من التطبيق',
    '没有找到附近的信息': 'لم يتم العثور على معلومات في مكان قريب',
    '预览视频': 'معاينة الفيديو',
    '最多选择3件商品': ' اختر 3 سلع كحد أقصى',
    '修改资料': 'تعديل البيانات',
    '我们已经收到了您的举报': 'تلقينا التقرير الخاص بك', //
    '退出登录': 'تسجيل الخروج',
    '快去分享吧': 'اسرع بالمشاركة ',
    '我发布了一片新动态': 'لقد قمت بتنزيل عمل جديد',
    '关联宝贝': 'ارتباط بالبضائع',
    //'没有选择内容':'',
    '操作失败': 'فشلت العملية',
    '上传封面失败了,请检图片是否存在': 'فشل تنزيل الصورة , حاول مرة أخرى',
    '上传视频失败了,请检查视频是否存在': 'فشل تنزيل الفيديو, حاول مرة أخرى',
    '视频上传失败，请检查您的网络后重新上传':
        'فشلت عملية التنزيل , تحقق من الشبكة ثم حاول مرة أخرى',
    '🌟 发布成功,快去分享给你好朋友吧': 'تم تنزيل عملك بنجاح , قم بمشاركته مع أصدقائك🌟 ',
    '更新成功': 'تم التحديث بنجاح',
    '更新失败': 'فشل التحديث',
    '保存': 'حفظ',
    '快来看我发布的': 'قم بالإطلاع على أعمالي',
    '请求评论出错': 'حدث خطأ بالتعليق',
    '请求频道列表出错': 'خطأ في قائمة القنوات',
    '正在发布您的作品': 'يتم الان تنزيل عملك',
    '评论失败，请检查您的网络': 'يتم الان تنزيل عملك',
    '你的好友': 'صديقك',
    '已收藏': 'مفضل',
    '更换封面': 'تغيرصورة الواجهة',
    '不能关注自己': 'لا يستطيع التركيز على نفسه',
    '没有更多了': 'لا أكثر', ///////////
    '确定': 'تأكيد',
    '设置': 'إعدادات',
    '昵称': 'الإسم المستعار',
    '性别': 'الجنس',
    '生日': 'تاريخ الميلاد',
    '简介': 'المقدمة',
    '快来填写你的个人简介吧': 'تعال املأ ملفك الشخصي',
    '修改昵称': 'تغيير اللقب',
    '请输入你的昵称': 'من فضلك أدخل لقبك',
    '修改性别': 'تعديل الجنس',
    '名称不能为空': 'لا يمكن أن يكون الاسم فارغًا',
    '修改简介': 'الصفحة الشخصية',
    '请输入你简介': '请输入你简介',
    '简介不能为空': '简介不能为空',
    '请输入你简介': 'من فضلك املأ البايو',
    '简介不能为空': 'لا يمكن أن يكون البايو فارغًا',
    '您的账户已被注销': 'تم إلغاء حسابك',
    '没有更多了': 'لا أكثر',
    '注销账户': 'إلغاء حساب',
    '是否要举报本条内容': 'هل تريد الإبلاغ عن هذا المقال؟',
    '我们已经收到您的举报': 'لقد تلقينا تقريرك',
    '我们不会再向您推送此用户的内容': 'لن نرسل لك محتوى من هذا المستخدم بعد الآن',
    '我们会减少向您推送此类内容': 'سنقوم بتقليل هذا المحتوى لك',
    '不喜欢这名用户': 'لا تحب هذا المستخدم',
    '不喜欢此内容': 'لا تحب هذا المحتوى',
    '举报违规内容': 'الإبلاغ عن الانتهاكات',
    '感谢您的举报,我们核实后会此内容处理!': 'شكرا لتقريرك ، سنتعامل مع هذا المحتوى بعد التحقق!',
    '账号与安全': 'معلومات',
    '关于我们': 'معلومات عنا',
    '意见反馈': 'استجابة',
    '清除缓存': 'مسح ذاكرة التخزين المؤقت',
    '填写邀请码': 'دعوة الأصدقاء',
    '说说你的建议或者问题，以便我们更好的服务':
        'أخبرنا باقتراحاتك أو أسئلتك حتى نتمكن من تقديم خدمة أفضل',
    '问题与意见': 'الاسئلة والتعليقات',
    '不能为空': 'لا يمكن أن تكون فارغة',
    '提交反馈': 'إرسال ملاحظات',
    '反馈成功，感谢您的反馈': 'ردة فعل ناجحة ، شكرا لك على ملاحظاتك',
    '手机号': 'رقم الهاتف',
    '未绑定': 'غير مرتبط',
    '绑定新手机号': 'ربط رقم هاتف جديد',
    '确认解绑？': 'هل تريد تأكيد إلغاء الربط؟',
    '绑定失败': 'فشل الإرتباط',
    '绑定成功': 'إرتباط ناجح',
    '解绑成功': 'فك الارتباط بنجاح',
    '解绑Google后将无法继续使用它登录该账号':
        'بعد إلغاء ربط Google ، لن تتمكن من استخدامه لتسجيل الدخول إلى الحساب',
    '解绑Apple ID后将无法继续使用它登录该账号':
        'بعد إلغاء ربط   Apple ID الخاص بك ، لن تتمكن من استخدامه لتسجيل الدخول إلى الحساب',
    '解绑Facebook后将无法继续使用它登录该账号':
        'بعد إلغاء ربط Facebook ، لن تتمكن من استخدامه لتسجيل الدخول إلى الحساب',
    '现手机号验证': "التحقق من رقم الهاتف الحالي",
    '欢迎你的到来': 'مرحباُ بك',
    '最少选择1个': 'يرجى ملء 1اهتمام على الأقل',
    '草稿箱': 'مربع المسودة',
    '隐私设置': 'إعدادات الخصوصية',
    '清理缓存': 'تنظيف التخزين المؤقت',
    '您确定删除本条内容?': 'هل أنت متأكد أنك تريد حذف هذه المقالة؟',
    '删除': 'حذف',
    'loading': 'جار التحميل',
    '成功': 'النجاح',
    '失败': 'فشلت العملية',
    '已经加入黑名单,内容不可见': 'تمت إضافته إلى القائمة السوداء ، المحتوى غير مرئي',
    '解除黑名单': 'قم بإلغاء حظر القائمة السوداء',
    '登录失效了,请重新登录': 'تسجيل الدخول غير صالح ، يرجى تسجيل الدخول مرة أخرى',
    '用户不存在': 'المستخدم غير موجود',
    '填写邀请码': 'الدعوة عن طريق الكود',
    '请输入你的邀请码': 'الرجاء إدخال رمز الدعوة الخاص بك',
    '填写成功': 'تمت الكتابة بنجاح ',
    '内容已经被删除': 'تمت إزالة المحتوى',
    '数据加载中': 'جار التحميل',
    '不能为空': 'لايمكن ان يكون فارغا',
    '没有更多评论啦': 'لا توجد المزيد من التعليقات ',
    '发布作品数': 'عدد الأعمال المنشورة',
    '获得点赞数': 'احصل على إعجابات',
    '获得收藏数': 'احصل على المفضلة',
    '我知道了': 'أنا أعلم',
    '是否要删除这条评论?': 'هل تريد حذف هذا التعليق؟',
    '删除评论': 'حذف تعليق',
    '暂无搜索结果': "لاتوجد نتيجة للبحث ",
    '暂无搜索结果': "لاتوجد نتيجة للبحث ",
    '暂无内容': 'لايوجد محتوى',
    '是否要删除这条评论': 'تريد حذف هذا التعليق؟',
    '榜单': 'جدول',
    '为了安全，请增添一个手机号到你的LanLa账号':
        'لضمان أمان حسابك ، يرجى إضافة رقم هاتف الجوال  إلى حساب LanLa الخاص بك',
    '您确定要注销当前账号吗': 'هل أنت متأكد أنك تريد تسجيل الخروج من الحساب الحالي؟ ',
    '账号注销后会永久删除所有数据': 'بعد تسجيل الخروج , سيتم حذف جميع البيانات بشكل دائم',
    '音频加载失败': 'فشل تحميل الصوت',
    '录音': 'تسجيل',
    '快用语音简单描述一下吧': 'وصف بسيط مع الصوت',
    '单点就开始录音': 'ابدأ التسجيل بنقرة واحدة',
    '点击暂停': 'انقر للبدء',
    '你关注的人还没有发布内容哟': 'الشخص الذي يهمك لم تنشر بعد',

    ///
    '礼物': 'هدايا',
    '赠礼功能尚未开放，敬请期待哟': 'لم يتم فتح خاصية ارسال الهدايا بعد ، لذا ترقبوا ذلك',
    '请填写验证码': "مطلوب كود التحقق",
    '手机号错误': 'مطلوب رقم الجوال ',
    '地区编号错误': 'المنطقة رقم خاطئ',
    '请选择地区码': 'الرجاء اختيار رمز المنطقة',
    '音频上传中': 'تحميل الصوت',
    '请等待当前发布完成': 'يرجى الانتظار حتى يكتمل الإصدار الحالي',
    '浏览': 'متصفح',
    '没有选择话题': 'لم يتم تحديد موضوع',
    '跳过': 'تخطي',
    '热门话题': 'الهاشتاقات',
    '人参与': 'شخص مشارك',
    '已经选择': 'تم تحديده بالفعل',
    '立即创建': 'خلق',
    '已经存在话题': 'الموضوع موجود بالفعل',
    '已经选择': 'تم تحديده بالفعل',
    '笔记': 'الاعمال',
    '话题': 'مواضيع',
    '保密': 'سرية',
    '浏览量': 'الآراء',
    '最新': 'حتى الآن',
    '最热': 'الأكثر إثارة',
    '添加话题': 'أضف الموضوع',
    'LanLa鼓励向上、真实、原创的内容，含以下内容的笔记将不会被推荐：':
        ' نحن LanLa  يتم تشجيع المحتوى التصاعدي والأصلي  ، ولن يوصى باستخدام الملاحظات التي تحتوي على المحتوى التالي:',
    '1．含有不文明语言、过度性感图片；':
        '1. يحتوي على كلمات غير حضارية وصور مثيرة وقليلة الاحترام ؛',
    '2．含有网址链接、联系方式、二维码或售卖语言；':
        '2. يحتوي على روابط URL أو معلومات الاتصال أو رموز QR أو المبيعات ؛',
    '3．冒充他人身份或搬运他人作品；': 'انتحال هوية شخص آخر أو نقل عمل شخص آخر ؛',
    '4．为刻意博取眼球，在标题、封面等处使用夸张表达':
        '4. لجذب الانتباه بشكل متعمد ، استخدم التعبيرات المبالغ فيها في العنوان والغلاف وما إلى ذلك.',
    '发布小贴士': 'نصائح النشر',
    '发布到话题': 'نشر الان',
    '反馈与建议': 'المراجعات والاقتراحات',
    '图片描述': 'وصف الصورة',
    '最多三张': '3 صور كحد أقصى',
    '提示': 'جديلة',
    '是否要删除该照片': 'حذف هذه الصورة',
    '鼓励一下': 'قيم تطبيقنا',
    '新版本优化啦，快来体验吧': 'تم تحسين الإصدار الجديد ، قم بتجربته الآن',
    '立刻升级': 'تحديث الآن',
    '以后再说': 'أخبرني لاحقا',
    '喜欢LanLa吗？': 'هل أنت من محبين LanLa؟',
    'LanLa的成长需要你的支持，我们诚恳希望能得到你的鼓励与评价，因为你的每一次鼓励能让我们做得更好。':
        'يحتاج نمو وتطوير تطبيق ( LanLa ) إلى دعمك ، ونأمل بصدق أن نحصل على تشجيعك وتقييمك ، لأن كل تشجيع منك يمكن أن يجعلنا نعمل بشكل أفضل.',
    '五星好评': 'نرجو منح خمس نجوم',
    '我要反馈与建议': 'افيدونا بردود افعالكم واقتراحاتكم',
    '您的手机号有误，请重新输入': 'رقم هاتفك غير صحيح، يرجى إعادة إدخاله',
    '无效手机号': 'رقم الهاتف غير صحيح',
    '程序出错': 'خطأ في البرنامج',
    '请求太多': 'لقد تم إرسال طلبات متعددة ، انتظر من فضلك',
    '分享给你一个话题': 'مشاركة موضوع معك',
    '验证码不正确': 'رمز التحقق غير صحيح',
    '搜索': 'البحث',
    '没有更多数据': 'ليس هناك المزيد من البيانات',
    '不显示位置': 'لا تظهر الموقع',
    '添加地址': 'أضف العنوان',
    '话题不存在': 'الموضوع غير موجود',
    '位置不存在': 'الموقع غير موجود',
    '详情': 'تفاصيل',
    '开放时间': 'وقت العمل',
    '联系电话': 'رقم التواصل',
    '收藏成功': 'تم الحفظ في المفضلة بنجاح',
    '请到个人收藏夹查看': 'يرجى الذهاب إلى المفضلة الشخصية لعرضها',
    '点击查看': 'اضغط للعرض',
    '表达一下你的态度': 'عبر عن موقفك',
    '一般': 'عادي',
    '不好': 'ليس جيد ً',
    '发布作品': 'نشر العمل',
    '删除态度': 'إزالة الموق',
    '你对此标签的态度已删除': 'الموقف الخاص بك من هذه التسمية قد أزيلت',
    '地点': 'المكان',
    '打卡去过': 'لكمة',
    '想去': 'تريد أن تذهب',
    '已想去': 'تريد أن تذهب',
    '验证失败': 'فشل التحقق',
    '服务器出差了，请稍后再试': 'حصل خطأ في الخدمة ، يرجى المحاولة مرة أخرى لاحقًا',
    '发布失败，请检查您的网络后重新上传': 'فشل نشر عملك ، يرجى التحقق من شبكتك وتحميله مرة أخرى',
    '赠送': 'هدية',
    '充值la币': 'شحن عملة La',
    '充值贝壳': 'شحن الصدفة',
    '赠送成功': 'تم الإهداء بنجاح',
    '余额不足': 'رصيدك غير كاف',
    'La币': 'عملة La',
    '贝壳': 'الصدفة',
    '收益': 'المكتسب',
    '明细': 'تفاصيل',
    '贝壳的用途': 'استخدم الصدفة',
    '立即提现': 'سحب الآن',
    '礼物明细': 'تفاصيل الهدية',
    '被赠礼的作品': 'الموهوبين',
    '赠礼人': 'مانح الهدايا',
    '赠礼时间': 'وقت الهدية',
    '礼物收益': 'عائدات الهدية',
    '钱包': 'المحفظة',
    '任务': 'مهمة',
    '举报用户': 'أبلغ عن مستخدم',
    '提供更多信息有助于举报被快速处理':
        'قم بتوفير المزيد من المعلومات للمساعدة في معالجة التقرير بسرعة',
    '您没有google支付功能暂时无法充值':
        'عفواً لاتوجد لديك خاصية Google pay  لاتستطيع شحن العملات في الوقت الحالي',
    '贝壳可以被用来给你喜欢的作品送礼物':
        'يمكن استخدام الأصداف كهدية للأعمال المبدعة المفضلة لديك',
    '贝壳可以用于参与LanLa平台不同时段的活动':
        'يمكن استخدام الأصداف للمشاركة في الأنشطة على منصة LanLa في أوقات مختلفة',
    '还没有收益哟，快去发布优质作品赢礼物吧':
        'لا يوجد رصيد حتى الآن ، اسرع وقم بنشر أعمال عالية الجودة لكسب الهدايا',
    '提现功能敬请期待': 'خاصية سحب الرصيد ليست متوفرة ترقبوا',
    '快去发布优质作品更容易得到收益哟！':
        'أسرع وانشر أعمالًا عالية الجودة لتسهيل الحصول على الهدايا !',
    '支付失败，将在3个工作日退款': 'فشل الدفع ، سيتم استرداد المبلغ خلال 3 أيام عمل',
    '评价一下': 'تقييم',
    '个人资料': 'البيانات الشخصية',
    '更多': 'أكثر',
    '请选择你想要举报的类型': 'الرجاء اختيار نوع التقرير الذي تريد',
    '显示更多': 'عرض المزيد',
    '参与人员': 'الاشخاص المشاركين',
    '拉黑': 'حظر',
    '我们将不会再向您推此用户的内容': 'لن نظهر محتوى هذا المستخدم إليك بعد الآن',
    '前': 'منذ',
    '分钟': 'دقيقة',
    '小时': 'ساعة',
    '刚刚': 'فقط',
    '视频': 'فيديو',
    '图片': 'صور',
    '相册': 'الألبوم',
    '拍照': 'تصوير',
    '系统消息': 'رسالة النظام',
    '查看进入': 'عرض الدخول',
    '上传中': 'تحميل',
    '包含敏感词': 'تحتوي على كلمات حساسة',
    '请重新登录': 'الرجاد الدخول على الحساب من جديد',
    '敬请期待': 'ترقبوا',
    '怎样获得贝壳': 'كيفية الحصول على الأصداف',
    '每日登陆LanLa可得': 'قم بتسجيل الدخول إلى LanLa كل يوم لتحصل على',
    '可以参与LanLa平台不定期任务所得': '‎اربح من المشاركة في مهام عرضية على منصة LanLa',
    '他人送礼可得': 'يمكن للآخرين الحصول على هدايا',
    '连接失败请重启app': 'فشل الاتصال ، يرجى إعادة تشغيل التطبيق',
    '下载': 'تحميل',
    '下载成功': 'تم التحميل بنجاح',
    '下载失败': 'فشل في التحميل',

    '跳转购买': 'شراء',
    'lanla全网比价': 'LANLA مقارنة جميع المواقع على الانترنت ',
    '数据展示全网价格': 'تظهر البيانات سعر المواقع بالكامل',
    '用户评测': 'تقييم المستخدم',
    '查看全部评论': 'فتح جميع التعليقات',
    '精选': 'متميز',
    '好物': 'السلع',
    //'设置价格提醒':'设置价格提醒',
    '登录发现更多精彩内容': 'سجل الدخول لاكتشاف المزيد من المحتويات الرائعة!',
    '前往登陆': 'سجل دخولك',
    '请检查网络连接': 'يرجى التحقق من الاتصال بالشبكة',
    '全网比价': 'مقارنة جميع المواقع',
    '你的LanLa时尚购物指南': 'دليل التسوق والأزياء  الخاص بك lanla',
    '评估': 'تقييم',
    '用户评测': 'تقييم المستخدم',
    '你的评价': 'تقييمك',
    '说说你对TA的评价': 'حدثنا عن رأيك في هذا التقييم ',
    '质量': 'الجودة',
    '超赞': 'ممتاز',
    '满意': 'راضي',
    '性价比': 'القيمة المالية',
    '一般': 'عادي',
    '吐槽': 'تقديم شكوى',
    '糟糕': 'سيئ جدُا',
    '品牌': 'الماركة',
    '外观设计': 'التصميم الخارجي',
    '会回购': 'إغادة الشراء',
    '来说说你对TA的使用感受，跟大家一起交流吧': 'أخبرني عن تجربتك في استخدامه ، وشاركها مع الجميع',
    '请填写评分': 'الرجاء ملء التصنيف',
    '评价成功，感谢你的测评': 'التقييم ناجح شكرا على تقييمك',
    '立即发布': 'نشر الأن',
    '还没有用户评价': 'لا يوجد تعليقات من المستخدمين حتى الآن',
    '我也要评测': 'اريد التعليق ايضًا',
    '种草': 'التوصية',
    '7天': ' 7 أيام',
    '30天': ' 30 يومًا',
    '60天': ' 60 يومًا',
    '180天': ' 180 يومًا',
    '已评分': 'تم تقييمه',
    '未获取存储权限': 'لم يتم الحصول على إذن التخزين بعد',
    '下载中': 'جارى التحميل',
    '关注成功': 'تمت المتابعة',
    '继续关联': 'منتجات ذات صله',
    '无法删除': 'لا يمكن حذفه',
    '仅剩一张图片': 'بقيت صورة واحدة فقط',
    '保存并退出': 'حفظ وخروج',
    '退出': 'خروج',
    '草稿在应用卸载后会被删除，请及时发布': 'غاء تثبيت التطبيق ، يرج',
    '年龄': 'تاريخ الميلاد',
    '邀请码': "املأ رمز دعوة صديقك",
    '填写好友邀请码（非必填项）': 'املأ رمز دعوة الصديق (اختياري)',
    '填写好友邀请码': 'املأ رمز دعوة صديقك',
    '邀请奖励': 'دعوة المسابقة',
    '本地草稿': 'المسودة',
    '代发': ' أعمال لم ترسل',
    '篇作品': 'لديك ',
    '关注TA们': 'قم بمتابعتهم',
    '结交更多有趣的朋友': "تعرفي على صديقات مثيرين للاهتمام",
    '关注了': ' أشخاص',
    '人': 'متابعة ',
    '取消关注': 'الغاء المتابعة',
    '贝币兑换': 'استبدال الأصداف',
    '贝壳不足': 'الأصداف غير كافية',
    '去赚取': 'تعال و اكسب',
    '奖品名称': 'الجائزة هي',
    '兑换时间': 'وقت الاستبدال',
    '兑完为止': 'حتى الاستبدال',
    '兑换进程': 'تقدم الاستبدال',
    '收到': 'استقبلت',
    '礼物墙': 'جدار الهدايا',
    '等级说明': 'استبدال الجوائز',
    '任务中心': 'مركز المهام',
    'LanLa等级': 'عملة صدفتي',
    'la货币': 'عملة صدفتي',
    '兑换礼物': 'شرح الدرجات',
    '等级作品': 'استبدال الجوائز',
    '新手任务': 'مهمة المبتدئين',
    '日常任务': 'المهام اليومية',
    '连续签到7天得贝壳': 'لقد قمت بالتحضير  ل7أيام',
    '签到': 'التحضير',
    '惊喜': 'مفاجأة',
    '你获得了': 'لقد حصلتي على ',
    '个贝币': ' صدفة',
    '兑换历史': 'استبدال الجائزة',
    '兑换时间': 'وقت الاستبدال',
    '奖品兑换': 'استبدال الجائزة',
    '签到成功': 'تم التحضير بنجاح',
    '连续签到': 'لقد قمت بالتحضير  ل ',
    '天得贝壳': ' أيام',
    '兑换商城': 'متجر الاستبدال',
    '兑换': 'استبدال',
    '剩余': 'بقيت ',
    '件': ' نقطة',
    '立即兑换': 'استبدال الآن',
    '共': 'المجموع',
    '份': 'نقطة',
    '人参与': 'مشارك',
    '兑换申请已提交': 'تم تقديم طلب الاستبدال',
    '审核通过后，会有LanLa客服人员在3日内联系你的':
        'بعد اجتياز المراجعة ، سيتصل بك موظفو خدمة عملاء LanLa في غضون 3 أيام عمل',
    '兑换成功': 'نجح الاستبدال',
    '您的卡密': 'الرقم السري لبطاقة الشحن',
    '你的卡密，关闭后可在奖品兑换中查看':
        'يمكنك الاطلاع عليه في قسم استبدال الجوائز بعد الإغلاق',
    '进行中': 'قم بالتنفيذ',
    '我收到的': 'استقبلت',
    '我送出的': 'اهديت',
    '兑换成功': 'نجح الاستبدال',
    '兑换时间': 'وقت الاستبدال',
    '任务完成': 'المتبقي ',
    '完成次数': ' مرات اليوم',
    '前往': 'عرض المزيد',
    '通信': 'مراسلة',
    '暂无好友送礼': 'لايوجد هدايا من الاصدقاء',
    '快去给她的作品进行打赏吧': 'اسرع وامنحها مكافأة على عملها.',
    'LanLa等级': 'درجة LanLa',
    '审核中': 'قيد المراجعة',
    '回复': 'الرد',
    '回复评论': 'الرد على التعليق',
    '长图文': 'مقالة',
    '长图文': 'مقالة',
    '选择字号': 'اختر حجم الخط',
    '中': 'وسط',
    '小': 'صغير',
    '大': 'كبير',
    '请填写内容': 'يرجى ملء المحتوى',
    '请插入图片或者视频': 'يرجى إدراج صورة أو فيديو',
    '请输入邮箱号': 'يرجى إدخال رقم البريد الإلكتروني ',
    '邮箱格式错误': 'خطأ في تنسيق البريد الإلكتروني',
    '发送邮件成功': 'تم إرسال البريد الإلكتروني بنجاح',
    '发送邮箱失败': 'تم إرسال البريد الإلكتروني بنجاح',
    '邮箱验证失败': 'فشل التحقق من البريد الإلكتروني',
    '邮箱': 'البريد الإلكتروني',
    '解绑email后将无法继续使用它登录该账号':
        'بعد إلغاء ربط email ، لن تتمكن من استخدامه لتسجيل الدخول إلى الحساب',
    '邮箱号验证': 'التحقق بواسطة البريد الالكتروني',
    '绑定邮箱号': 'ربط رقم صندوق البريد',
    '绑定': 'ربط',
    '你的邮箱账号': 'حساب بريدك الإلكتروني',
    '已被下方账号绑定': 'تم الالتزام بالحساب أدناه',
    '当前绑定': 'مرتبط حالياً',
    '是否换绑至当前登录账号': 'ما إذا كان سيتم التبديل إلى حساب تسجيل الدخول الحالي',
    '当前登录': 'مسجّل الدخول حاليًا',
    '换绑': 'تغيير الارتباط',
    '暂不换绑': 'عدم الرغبة بتغيير الربط حالياً ',
    'LanLa认证申请': 'طلب توثيق LanLa',
    '内容创作者认证': 'توثيق خاص لصانعات المحتوى ',
    '在LanLa某一领域持续贡献内容的用户':
        'المستخدمين الذين يواصلون المساهمة بالمحتوى في مجال معين على LanLa ',
    '申请认证': 'وثق الحساب',
    '达人认证': 'توثيق صانعة محتوى مشهورة',
    '在LanLa某一领域持续贡献优质内容的内容创作者':
        'صانعات المحتوى الذين يواصلون المساهمة بمحتوى عالي الجودة في مجال معين على LanLa',
    'LanLa认证特权': 'توثيق الامتياز من  LanLa',
    '我们将发送一个链接到你的邮箱，点击链接即可登录注册':
        ' سنرسل رابطًا إلى بريدك الإلكتروني، انقر على الرابط لتسجيل الدخول أو التسجيل.',
    '账号绑定状态': 'حالة ربط الحساب',
    '注册': 'التسجيل',
    '达人标识': 'شعار الموهبة',
    '流量扶持': 'دعم في النشر والاكسبلور',
    '官号推荐': ' دعم ترشيح من الحساب الرسمي ',
    '资源位曝光': 'دعم في الريتش',
    '内容创作者认证申请': 'طلب التوثيق لصانع المحتوى',
    '立刻申请': 'قدم الآن',
    '申请条件未达成': 'لم تتحقق شروط الطلب',
    '认证申请已提交！': 'تم تقديم طلب التوثيق！',
    'LanLa工作人员将在3日内审核后给你提示并给予你相应的头衔哟～':
        'سيعطيك فريق LanLa تذكيرًا بالمعلومات وسيمنحك لقبا مطابقًا بعد المراجعة في غضون 3 أيام ~',
    '已申请': 'تم التقديم',
    '已认证': 'تم التوثيق',
    '申请条件': 'شروط التقديم',
    '安全验证': 'التحقق الأمني',
    '下面哪一个是你当前账号的头像': 'أي مما يلي هو الصورة الرمزية لحسابك الحالي',
    '设置账号密码': 'قم بتعيين كلمة مرور الحساب',
    '由与lanla的功能升级，以后可用账号密码进行登录':
        'نظرًا لترقية وظيفة lanla ، يمكن استخدام الحساب وكلمة المرور لتسجيل الدخول في المستقبل',
    '请设置5位数及以上的密码': 'يرجى تعيين كلمة مرور مكونة من 5 أرقام أو أكثر',
    '您的密码少于5位，请重新输入':
        'كلمة المرور الخاصة بك أقل من 5 أحرف ، يرجى إعادة إدخالها',
    '您的密码错误，请重新输入': 'كلمة المرور خاطئة، يرجى إعادة إدخالها',
    '密码登录': 'تسجيل الدخول بكلمة مرور',
    '请输入您的登录密码': 'يرجى إدخال كلمة مرور تسجيل الدخول الخاصة بك',
    '忘记密码': 'نسيت كلمة المرور ',
    '您的密码号不对，请重新输入': 'رقم كلمة المرور الخاصة بك خاطئ، يرجى إعادة إدخاله',
    '很抱歉，手机号登录系统正在升级中，请选择其他的登录方式':
        'عذرا، يتم تحديث نظام تسجيل الدخول إلى رقم الهاتف المحمول. يرجى اختيار طريقة تسجيل دخول أخرى.',
    '下面哪一个是你当前账号的昵称': 'أي مما يلي هو اسم حسابك الحالي',
    '下面哪一个是你当前账号的注册时间': 'أي مما يلي هو وقت تسجيل حسابك الحالي',
    '下面哪一个是你所填的生日信息': 'أي مما يلي هو معلومات عيد الميلاد التي قمت بتعبئتها ؟',
    '请输入您设置的密码': 'يرجى إدخال كلمة المرور الخاصة بك',
    '请再次输入密码': 'يرجى إدخال كلمة المرور مرة أخرى',
    '您两次输入的密码不一致': 'كلمة المرور التي أدخلتها مرتين غير متطابقة',
    '换一个问题': 'سؤال آخر',
    '由于LanLa登录系统的优化，请绑定其他的登录方式':
        'لتحسين نظام تسجيل الدخول إلى LanLa، يرجى ربط طرق تسجيل الدخول الأخرى',
    '其他频道': 'قنوات أخرى',
    '点击添加频道': 'انقر لإضافة قناة',
    '我的频道': 'قنواتي',
    '进入编辑': 'تعديل',
    '完成编辑': 'إنهاء التعديل',
    "点击进入频道": 'انقر للدخول إلى القناة',
    '频道不能再少了': 'القناة لا يمكن أن تكون أقل',
    '优选笔记': 'المحتويات المفضلة',
    '内容专区': 'منطقة المحتوى',
    '活动结束': 'انتهاء المسابقة',
    '即将开始': 'انها على وشك البدء',
    '活动专区': 'منطقة المسابقة',
    '倒计时': 'العد التنازلي',
    '天': 'أيام',
    '我的喜欢': 'مفضلاتي',
    '暂无喜欢的商品': 'لا يوجد منتجات مفضلة حالياً',
    '今日暂无更多推荐': 'اليوم لا توجد مزيد من الاقتراحات',
    '往下滑滑发现更多精彩吧':
        'المزيد من المحتوى المثير يمكن العثور عليه عند التمرير لأسفل',
    '今日特价': 'عرض خاص اليوم',
    '心动私藏': 'المنتجات المفضلة',
    '好物甄选': 'اختيار المنتجات الجيدة'
  };
  for (final entry in keys.entries) {
    print("'${entry.key}': '${entry.key}',");
  }
}
