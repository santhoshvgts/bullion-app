import 'package:url_launcher/url_launcher.dart';

launchUrl(String url) async {
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}
