import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // String? errorText;
    //
    // final args =
    //     ModalRoute.of(context)?.settings.arguments as Map<String, String?>?;
    //
    // if (args != null) {
    //   errorText = args['errorText'];
    // }
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                constraints: const BoxConstraints(
                  maxWidth: 180,
                  maxHeight: 180,
                ),
                child: Image.asset(
                  'lib/assets/images/loading_img/car_running.gif',
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Text(
                '에러가',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context).secondaryHeaderColor,
                ),
              ),
              Text(
                '발생했습니다',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context).secondaryHeaderColor,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  fixedSize: const Size(180, 50),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                onPressed: () async {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/home',
                    ModalRoute.withName('/home'),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.home),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      "메인 화면으로",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
