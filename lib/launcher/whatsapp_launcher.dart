import 'package:url_launcher/url_launcher.dart';

Future<void> sendWhatsAppMessage(String phoneNumber, String message) async {
  // Format: https://api.whatsapp.com/send?phone=PHONE_NUMBER&text=MESSAGE
  final whatsappUrl = "https://api.whatsapp.com/send?phone=$phoneNumber&text=${Uri.encodeComponent(message)}";
  
  if (await canLaunch(whatsappUrl)) {
    await launch(whatsappUrl);
  } else {
    throw 'Could not launch WhatsApp';
  }
}
