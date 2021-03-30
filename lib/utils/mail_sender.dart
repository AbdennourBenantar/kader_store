import 'package:url_launcher/url_launcher.dart';
class Utils{
  static Future launchUrl(String url) async{
    if(await canLaunch(url)){
      await launch(url);
    }
  }
  static openEmail({String toEmail,String subject, String body})
  async {
    final url='mailto:$toEmail?subject=${Uri.encodeFull(subject)}&body=${Uri.encodeFull(body)}';
    await launchUrl(url);
  }
}