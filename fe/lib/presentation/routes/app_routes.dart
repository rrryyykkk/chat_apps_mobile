import 'package:fe/data/models/chat_model.dart';
import 'package:fe/presentation/pages/auth/forgot_password_page.dart';
import 'package:fe/presentation/pages/auth/login_pages.dart';
import 'package:fe/presentation/pages/auth/register_pages.dart';
import 'package:fe/presentation/pages/auth/reset_password_page.dart';
import 'package:fe/presentation/pages/auth/verification_page.dart';
import 'package:fe/presentation/pages/chat/group/group_chat_page.dart';
import 'package:fe/presentation/pages/chat/single/single_chat_page.dart';
import 'package:fe/presentation/pages/contact/add_friend_page.dart';
import 'package:fe/presentation/pages/group/create_group_page.dart';
import 'package:fe/presentation/pages/group/select_members_page.dart';
import 'package:fe/presentation/pages/home/dashboard_page.dart';
import 'package:fe/presentation/pages/home/status_detail_page.dart';
import 'package:fe/presentation/pages/home/create_text_status_page.dart';
import 'package:fe/presentation/pages/home/create_media_status_page.dart';
import 'package:fe/presentation/pages/info/chat_info_page.dart';
import 'package:fe/presentation/pages/info/sub_pages/add_to_group_page.dart';
import 'package:fe/presentation/pages/info/sub_pages/custom_notification_page.dart';
import 'package:fe/presentation/pages/info/sub_pages/media_links_page.dart';
import 'package:fe/presentation/pages/info/sub_pages/wallpaper_sound_page.dart';
import 'package:fe/presentation/pages/more/about_page.dart';
import 'package:fe/presentation/pages/more/help_page.dart';
import 'package:fe/presentation/pages/more/security_page.dart';
import 'package:fe/presentation/pages/more/terms_page.dart';
import 'package:fe/presentation/pages/onboarding/get_started_page.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  // daftar nama route
  static const getStartedPage = '/getStartedPage';
  static const login = '/login';
  static const register = '/register';
  static const verification = '/verification';
  static const forgotPassword = '/forgotPassword';
  static const resetPassword = '/resetPassword';
  static const home = '/home';
  static const singleChat = '/singleChat';
  static const groupChat = '/groupChat';
  static const addFriend = '/addFriend';
  static const createGroup = '/createGroup';
  static const selectMembers = '/selectMembers';
  static const chatInfo = '/chatInfo';
  static const mediaLinks = '/mediaLinks';
  static const customNotification = '/customNotification';
  static const wallpaperSound = '/wallpaperSound';
  static const addToGroup = '/addToGroup';
  static const statusDetail = '/statusDetail';
  static const createTextStatus = '/createTextStatus';
  static const createMediaStatus = '/createMediaStatus';

  // More/Settings Routes
  static const security = '/security';
  static const terms = '/terms';
  static const about = '/about';
  static const help = '/help';

  // route generator opsional (lebih fleksible)
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case getStartedPage:
        return MaterialPageRoute(builder: (_) => const GetStartedPage());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPages());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterPages());
      case verification:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => VerificationPage(
            nextRoute: args?['nextRoute'] as String?,
            email: args?['email'] as String?,
            isResetParams: args?['isResetParams'] as bool? ?? false,
          ),
        );
      case forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordPage());
      case resetPassword:
        return MaterialPageRoute(builder: (_) => const ResetPasswordPage());
      case home:
        return MaterialPageRoute(builder: (_) => const DashboardPage());
      case singleChat:
        final chat = settings.arguments as Chat;
        return MaterialPageRoute(builder: (_) => SingleChatPage(chat: chat));
      case groupChat:
        final chat = settings.arguments as Chat;
        return MaterialPageRoute(builder: (_) => GroupChatPage(chat: chat));
      case addFriend:
        return MaterialPageRoute(builder: (_) => const AddFriendPage());
      case createGroup:
        return MaterialPageRoute(builder: (_) => const CreateGroupPage());
      case selectMembers:
        return MaterialPageRoute(builder: (_) => const SelectMembersPage());
      case chatInfo:
        final chat = settings.arguments as Chat;
        return MaterialPageRoute(builder: (_) => ChatInfoPage(chat: chat));
      case mediaLinks:
        return MaterialPageRoute(builder: (_) => const MediaLinksPage());
      case customNotification:
        return MaterialPageRoute(
          builder: (_) => const CustomNotificationPage(),
        );
      case wallpaperSound:
        return MaterialPageRoute(builder: (_) => const WallpaperSoundPage());
      case addToGroup:
        return MaterialPageRoute(builder: (_) => const AddToGroupPage());
      case statusDetail:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => StatusDetailPage(
            userName: args['userName'] as String,
            userColor: args['userColor'] as Color,
            isMyStatus: args['isMyStatus'] as bool? ?? false,
          ),
        );
      case createTextStatus:
        return MaterialPageRoute(builder: (_) => const CreateTextStatusPage());
      case createMediaStatus:
        return MaterialPageRoute(builder: (_) => const CreateMediaStatusPage());
      case security:
        return MaterialPageRoute(builder: (_) => const SecurityPage());
      case terms:
        return MaterialPageRoute(builder: (_) => const TermsPage());
      case about:
        return MaterialPageRoute(builder: (_) => const AboutPage());
      case help:
        return MaterialPageRoute(builder: (_) => const HelpPage());
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('404 - Page Not Found'))),
        );
    }
  }
}
