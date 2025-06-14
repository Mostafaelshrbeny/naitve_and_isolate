import 'dart:developer';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gif/gif.dart';
import 'package:isolation_and_naitve/sensor_view.dart';

void main() {
  runApp(const MyApp());
  /*
  بسم الله 
  isolate
اولا ايه هو ال ثريد 
الثريد ده هو المسئول عن تنفيذ الاوامر  فالكود 
فلاتر شغالة على ثريد واحد  فقط على عكس النيتڤ مثلا 
مثال للفرق 
لنفرض ان فى مطبخ شغال فيه شيف واحد بس مسئول عن كل الطلبات 
فى حالة ان الطلبات كلها بسيطة فا محدش فالعملاء هيحس ان بالتأخير فالطلبات 
لكن لو حد طلب بشاميل وديك رومى وهكذا الوقت هيطول جدا لكل اوردر 
عشان كده بنجيب كذا شيف
ودى فكرة الisolate
  */
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        canvasColor: Colors.blue,
        floatingActionButtonTheme:
            FloatingActionButtonThemeData(backgroundColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  child: Text(
                    "without isolate",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    //هنا المعزه هتعطل بسبب تقل الجهد على ال main thread
                    heavyLoop([1000000000]);
                  },
                ),
                FloatingActionButton(
                  child: Text(
                    "with Compute",
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    /*
                 الحالة دى مجرد ما العملية تخلص ال thread الجديد اللى اشتغلنا عليه هيقفل لوحده
                 */
                    compute(heavyLoop, [1000000000]);
                  },
                ),
                FloatingActionButton(
                  child: Text(
                    "with isolate",
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () async {
                    /*
              دى بقى بواية الاتصال بينى وبين الثريد الجديد
              وده لان كل ثريد منعزل عن التانى 
              بمعنى انى مقدرش من خلال الثريد الجديد اعرف اى حاجه موجوده فالثريد الاساسى والعكس صحيح 
              لكن البوابة دى بنقل منها الداتا من الاتنين

              */
                    final ReceivePort port = ReceivePort();
/*
شرط اساسى ان الفانكشن تكون بتستقبل متغير واحد
 فا لو عايز ابعت اكتر من واحد ببعته على هيئة ليست او ماب مثلا
*/
                    await Isolate.spawn(heavyLoop, [1000000000, port.sendPort]);
                    port.listen((message) {
                      log(message.toString());
                      /*
                 الحالة دى مجرد ما العملية تخلص ال thread الجديد اللى اشتغلنا عليه هيقفل لوحده
                */
                      port.close();
                      try {
                        port.listen((message) {
                          log(message.toString());
                        });
                      } catch (e) {
                        log("قفلوا يا زينب");
                      }
                    });
                  },
                ),
              ],
            ),
            const Text(
              'لاما سعيدة',
              style: TextStyle(fontSize: 40),
            ),
            Gif(
                autostart: Autostart.loop,
                image:
                    AssetImage('assets/images/Animation - 1749845318238.gif')),
            SizedBox(height: 20),
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.deepPurple),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SensorPage()));
                },
                child: Text(
                  "روح عالنيتڤ",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ))
          ],
        ),
      ),
    );
  }
}

int heavyLoop(List<dynamic> arguments) {
  final iterations = arguments[0];
  log("heeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeelp");
  int sum = 0;
  for (int i = 0; i < iterations; i++) {
    sum += (i % 100);
  }
  log("heeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeelp");
  if (arguments.length > 1) {
    final SendPort? sendPort = arguments[1];
    sendPort?.send(sum);
  }
  return sum;
}
