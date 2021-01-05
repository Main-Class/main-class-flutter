library main_class.utils;

import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

launchEndereco(String endereco) async {
  if (Platform.isIOS) {
    String encoded = Uri.encodeQueryComponent(endereco);
    print("maps://maps.apple.com/?daddr=$encoded");
    launch("maps://maps.apple.com/?daddr=$encoded");
  } else {
    launch("geo:0,0?q=$endereco");
  }
}

launchTelefone(String telefone) async {
  launch("tel:0$telefone");
}

launchEmail(String email) async {
  launch("mailto:$email");
}

launchWhatsapp(String whatsapp) async {
  launch("https://wa.me/$whatsapp");
}

launchYoutube(String id) async {
  String path = "www.youtube.com/watch?v=$id";

  if (Platform.isIOS) {
    if (await canLaunch('youtube://$path')) {
      await launch('youtube://$path', forceSafariVC: false);
    } else {
      await launch('https://$path');
    }
  } else {
    await launch('https://$path');
  }
}

launchSite(String site) async {
  if (site.startsWith("http")) {
    launch(site);
  } else {
    launch("http://$site");
  }
}

launchMail(String email) async {
  launch("mailto:$email");
}
