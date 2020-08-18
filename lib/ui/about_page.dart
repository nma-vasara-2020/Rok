import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Container(
            child: Image.asset("assets/nma-logo.png"),
            height: 30,
          ),
        ),
      ),
      body: Container(
        child: AboutPageBody(),
      ),
    );
  }
}

class AboutPageBody extends StatelessWidget {
  static const NMA_WEBSITE_URL = "https://www.nmakademija.lt/eng/";
  static const NMA_FACEBOOK_URL = "https://www.facebook.com/nmakademija/";

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: Text(
                "Nacionalinė moksleivių akademija (NMA) – unikali papildomo ugdymo institucija, skirta mokslui ir muzikai gabiems Lietuvos vaikams. Nuo 2004 m. NMA ugdymo programas yra baigę daugiau nei 1300 talentingiausių vaikų iš įvairių Lietuvos kampelių. Akademijoje stiprinamas Lietuvos intelektinis potencialas, investuojama į gabius ir motyvuotus vaikus. Nepriklausomai nuo gyvenamosios vietos, talentingiems mokiniams sudaromos sąlygos mokytis pas geriausius Lietuvos ir kitų šalių dėstytojus bei mokytojus.",
                textAlign: TextAlign.center,
              ),
            ),
        ),
        RaisedButton(
          child: Text("Mygtukas"),
          onPressed: () => {},
        ),
      ],
    );
  }

  Future<bool> _launchWebsite() async {
    return await _launchURL(NMA_WEBSITE_URL);
  }

  Future<bool> _launchFacebook() async {
    return await _launchURL(NMA_FACEBOOK_URL);
  }

  // https://pub.dev/packages/url_launcher
  Future<bool> _launchURL(String url) async {
    if (await canLaunch(url)) {
      return await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
