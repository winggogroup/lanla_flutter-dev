import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:lanla_flutter/pages/detail/Amountdetails/view.dart';
import 'package:lanla_flutter/pages/detail/Prizedetails/index.dart';
import 'package:lanla_flutter/pages/detail/XiumiData/index.dart';
import 'package:lanla_flutter/pages/detail/geographicalposition/view.dart';
import 'package:lanla_flutter/pages/detail/picture/view.dart';
import 'package:lanla_flutter/pages/detail/recording/view.dart';
import 'package:lanla_flutter/pages/detail/share/share.dart';
import 'package:lanla_flutter/pages/detail/splash/view.dart';
import 'package:lanla_flutter/pages/detail/topic/view.dart';
import 'package:lanla_flutter/pages/detail/user/view.dart';
import 'package:lanla_flutter/pages/detail/video/view.dart';
import 'package:lanla_flutter/pages/detail/webview/view.dart';
import 'package:lanla_flutter/pages/home/Pricecomparison/Evaluationdetails.dart';
import 'package:lanla_flutter/pages/home/Pricecomparison/view.dart';
import 'package:lanla_flutter/pages/home/friend/Planningpage.dart';
import 'package:lanla_flutter/pages/home/me/Appsetup/view.dart';
import 'package:lanla_flutter/pages/home/me/GiftWall/index.dart';
import 'package:lanla_flutter/pages/home/me/InvitationCode.dart';
import 'package:lanla_flutter/pages/home/me/LevelDescription/index.dart';
import 'package:lanla_flutter/pages/home/me/TaskCenter/index.dart';
import 'package:lanla_flutter/pages/home/me/authentication/index.dart';
import 'package:lanla_flutter/pages/home/me/update_info_view.dart';
import 'package:lanla_flutter/pages/home/me/view.dart';
import 'package:lanla_flutter/pages/home/message/view.dart';
import 'package:lanla_flutter/pages/home/shoppingmall/Productlabellist.dart';
import 'package:lanla_flutter/pages/home/shoppingmall/commoditylike.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/ConnectionStartViewPage.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/ConnectionTopicViewPage.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/Topicxqpage.dart';
import 'package:lanla_flutter/pages/home/view.dart';
import 'package:lanla_flutter/pages/practice/view.dart';
import 'package:lanla_flutter/pages/publish/Geography.dart';
import 'package:lanla_flutter/pages/publish/Longraphicwriting.dart';
import 'package:lanla_flutter/pages/publish/binding.dart';
import 'package:lanla_flutter/pages/publish/image_preview.dart';
import 'package:lanla_flutter/pages/publish/preview.dart';
import 'package:lanla_flutter/pages/publish/topic_view.dart';
import 'package:lanla_flutter/pages/publish/view.dart';
import 'package:lanla_flutter/pages/user/login/view.dart';
import 'package:lanla_flutter/pages/user/register/view.dart';

//手机号验证
import 'package:lanla_flutter/pages/user/phone_verification/view.dart';

//设置信息
import 'package:lanla_flutter/pages/user/set_information/view.dart';

//选话题
import 'package:lanla_flutter/pages/user/chooseTopic/view.dart';

//密码
import 'package:lanla_flutter/pages/user/inputpassword/view.dart';

//登录方式
import 'package:lanla_flutter/pages/user/Loginmethod/view.dart';

//搜索
import 'package:lanla_flutter/pages/search/view.dart';

//登录方式
import 'package:lanla_flutter/services/content.dart';

import 'pages/detail/FlowDetails/view.dart';
import 'pages/home/me/drafts/view.dart';

class Routers {
  static List<GetPage> getPages = [
    // 无需登录

    GetPage(
      name: '/splash',
      page: () => SplashPage(),
        transition: Transition.fadeIn
    ),
    GetPage(
      name: '/public',
      page: () => HomePage(),
      children: [
        GetPage(
          name: '/share',
          page: () => SharePage(),
        ),
        ///话题
        GetPage(
          name: '/TopicxqpagePage',
          page: () => const ConnectionTopicPage(),
          // name: '/TopicxqpagePage',
          // page: () => TopicxqpagePage(),
          //transition: Transition.leftToRight
        ),
        GetPage(
            name: '/video',
            page: () => const VideoPage(),
            //transition: Transition.leftToRight
        ),
        GetPage(
            name: '/picture',
            page: () => const PicturePage(),
            //transition: Transition.leftToRight
        ),
        GetPage(
          name: '/xiumidata',
          page: () => xiumidataPage(),
          //transition: Transition.leftToRight
        ),
        GetPage(
          name: '/LongraphicwritingPage',
          page: () => LongraphicwritingPage(),
          //transition: Transition.leftToRight
        ),
        GetPage(
            name: '/message',
            page: () => MessagePage(),
            //transition: Transition.leftToRight
        ),
        GetPage(
          name: '/recording',
          page: () => RecordingPage(),
        ),
        GetPage(
          name: '/login',
          page: () => LoginPage(),
        ),
        GetPage(
          name: '/public/register',
          page: () => RegisterPage(),
        ),
        //手机号验证
        GetPage(
          name: '/phone_verification',
          page: () => PhoneVerificationPage(),
        ),
        //输入密码
        GetPage(
          name: '/inputpassword',
          page: () => InputpasswordPage(),
        ),
        //设置信息
        GetPage(
          name: '/SetInformationPage',
          page: () => SetInformationPage(),
        ),
        //选择话题
        GetPage(
          name: '/chooseTopic',
          page: () => ChooseTopicPage(),
        ),
        //登录方式
        GetPage(
          name: '/loginmethod',
          page: () => LoginmethodPage(),
          transition: Transition.downToUp,
        ),
        //搜索
        GetPage(
          name: '/search',
          page: () => SearchPage(),
        ),
        GetPage(
          name: '/user',
          page: () => UserHomePage(),
        ),
        //测试
        GetPage(
          name: '/practice',
          page: () => PracticePage(),
        ),
        GetPage(
          name: '/topic',
          page: () => TopicPage(),
        ),
        //地理位置详情页
        GetPage(
          name: '/geographical',
          page: () => geographicalPage(),
        ),
        // H5页面
        GetPage(
          name: '/webview',
          page: () => WebViewPage(),
        ),
        //钱包
        GetPage(
          name: '/amountPage',
          page: () => AmountPage(),
        ),
        //比价
        GetPage(
          name: '/Pricecomparison',
          page: () => Pricecomparisonpage(),
        ),
        ///比价详情
        GetPage(
          name: '/Evaluationdetails',
          page: () => EvaluationdetailsPage(),
        ),
        ///奖品详情
        GetPage(
          name: '/Prizedetails',
          page: () => PrizedetailsPage(),
        ),
        ///内容专区详情
        GetPage(
          name: '/Planningpage',
          page: () => Planningpage(),
        ),
        ///喜欢的商品
        GetPage(
          name: '/commoditylike',
          page: () => commoditylikePage(),
        ),
        ///标签商品
        GetPage(
          name: '/ProductlabelPage',
          page: () => ProductlabelPage(),
        ),
      ],
    ),
    // 需要登录
    GetPage(name: '/verify', page: () => MePage(), children: [
      GetPage(
        name: '/publish',
        page: () => PublishPage(),
        binding: PublishBinding(),
      ),
      GetPage(
        name: '/publishTopic',
        page: () => PublishTopicPage(),
      ),
      ///位置列表
      GetPage(
        name: '/locationlist',
        page: () => GeographylistPage(),
      ),
      // 预览页面
      GetPage(
        name: '/publishPreview',
        page: () => PublishPreviewPage(),
      ),
      GetPage(
        name: '/publishImagePreview',
        page: () => PublishImagePreviewPage(),
      ),
      GetPage(
          name: '/userUpdateInfo',
          page: () => UserUpdateInfoPage(),
         // transition: Transition.leftToRight
      ),
      //邀请码
      GetPage(
          name: '/InvitationCode',
          page: () => InvitationCodePage(),
          //transition: Transition.leftToRight
      ),
      //邀请码
      GetPage(
          name: '/Appsetup',
          page: () => AppsetupWidget(),
          //transition: Transition.leftToRight
      ),
      //流水明细
      GetPage(
          name: '/flowing',
          page: () => FlowDetailsPage(),
          //transition: Transition.leftToRight
      ),
      //草稿箱
      GetPage(
        name: '/drafts',
        page: () => draftsWidget(),
        //transition: Transition.leftToRight
      ),
      ///礼物墙
      GetPage(
        name: '/GiftWall',
        page: () => GiftWallPage(),
        //transition: Transition.leftToRight
      ),
      ///等级规则
      GetPage(
        name: '/LevelDescription',
        page: () => LevelDescriptionPage(),
        //transition: Transition.leftToRight
      ),
      ///任务中心
      GetPage(
        name: '/TaskCenter',
        page: () => TaskCenterPage(),
        //transition: Transition.leftToRight
      ),
      ///达人认证
      GetPage(
        name: '/authentication',
        page: () => authentication(),
        //transition: Transition.leftToRight
      ),

    ])
  ];
}
