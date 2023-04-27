import 'package:stacked_services/stacked_services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app/app.locator.dart';
import '../ui/shared/dialog_service.dart';

class LinkService {
  final _dialogSv = sl<DialogService>();

  void launchInstagram(String username) {
    username = _removeAtIfPresent(username);
    confirmAppLeaveAndNavigate("https://instagram.com/$username");
  }

  void launchSnapchat(String username) {
    username = _removeAtIfPresent(username);
    confirmAppLeaveAndNavigate("https://snapchat.com/add/$username");
  }

  void launchTikTok(String username) {
    username = _removeAtIfPresent(username);
    confirmAppLeaveAndNavigate("https://tiktok.com/@$username");
  }

  String _removeAtIfPresent(String username) {
    if (username.startsWith("@")) {
      return username.substring(1);
    }
    return username;
  }

  void confirmAppLeaveAndNavigate(String url) async {
    final r = await _dialogSv.showCustomDialog(
      variant: kConfirmationDialog,
      title: 'Leave RedLino?',
      description: 'Are you sure you want to leave RedLino and go to $url?',
      mainButtonTitle: 'Go',
      secondaryButtonTitle: 'Cancel',
    );
    if (r == null) return;
    if (r.confirmed) {
      launch(url);
    }
  }
}
