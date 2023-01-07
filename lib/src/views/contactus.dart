import 'package:flutter/material.dart';
import 'package:contactus/contactus.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';

class ContactUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SafeArea(
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.primary,
            body: Column(children: [
              FxSpacing.height(16),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(Get.context!);
                      },
                      child: FxContainer(
                        paddingAll: 4,
                        color: Theme.of(context).primaryColor,
                        child: Icon(
                          Icons.chevron_left_outlined,
                          color: Theme.of(context).colorScheme.onPrimary,
                          size: 32,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              FxSpacing.height(16),
              Expanded(
                child: Container(
                  child: ContactUs(
                    logo: AssetImage(
                      'assets/icons/REACONSPOT.png',
                    ),
                    email: 'info@dirmgroup.co.tz',
                    companyName: 'Dirm Group',
                    phoneNumber: '+255736889966',
                    dividerThickness: 2,
                    website: 'https://www.dirmgroup.co.tz',
                    // githubUserName: 'AbhishekDoshi26',
                    // linkedinURL: 'https://www.linkedin.com/in/abhishek-doshi-520983199/',
                    tagLine: 'ReaconSpots App',
                    // twitterHandle: 'AbhishekDoshi26',
                    // instagram: '_abhishek_doshi',
                    textColor: Color(0xffdafafa),
                    companyColor: Theme.of(context).colorScheme.onPrimary,
                    cardColor: Color.fromARGB(255, 68, 105, 148),
                    taglineColor: Color(0xffdafafa),
                  ),
                ),
              )
            ]),
          ),
        ));
  }
}
