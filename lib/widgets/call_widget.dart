import 'package:doctor/constants/components.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/colors.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CallWidget extends StatelessWidget {
  const CallWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Emergency call',style: mainTextStyle(context,color: black),),
                Lottie.asset('assets/lotties/call.json'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final Uri url = Uri(scheme: 'tel', path: "01112870010");
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        } else {
                          debugPrint('can not launch');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: defaultColor,
                        padding: const EdgeInsets.symmetric(horizontal: 66),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: Size(
                            screenWidth(context, .1), screenHeight(context, .06)),
                      ),
                      child: Icon(
                        Icons.call_outlined,
                        color: white,
                      ),
                    ),
                    const SizedBox(width: 15),
                    ElevatedButton(
                      onPressed: _launchWhatsApp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(0, 217, 95, 1),
                        padding: const EdgeInsets.symmetric(horizontal: 66),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: Size(
                            screenWidth(context, .1), screenHeight(context, .06)),
                      ),
                      child: const Icon(
                        MdiIcons.whatsapp,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void _launchWhatsApp() async {
  String url = "whatsapp://send?phone=+201112870010&text=help me%2C%20please!";
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
