import 'dart:developer';

import 'package:flutter/services.dart';

class IntergartionFunctions {
  /*
  يا مساء النيتڤ الجميل 
  هنا بقى هنشوف ازاى نربط بين النيتڤ والفلاتر فى كذا حالة 
  طب اصلا انا ممكن احتاج ده ليه 
  بص يا سيدى 
  اوقات فى باكدجات فى نيتڤ مش بتكون متاحة عندنا او مثلا انى عايز اوصل لحاجة فالهارد وير 
  وده بيتم عن طريق حاجة اسمها
  Channel
  نقدر نقول انها بواية الوصول للنيتڤ
  عندنا بقى نوعين 
  method channel 
  دى بقى زى الcompute كده
  مجرد ما بخلص المطلوب بنقفل 
  event channel 
  دى بقى ستريم شغال بينى وبين النيتڤ
  نشوف بقى الامثلة
  
  */
  static Future<int> counter(int value) async {
    final platform =
        /*
    دى بقى بواية الوصول للنيتڤ
    هنا انا بقوله روح على الباب اللى اسمه كذا 
    نقدر نعتبرها زى الimport بالظبط 
    المسمى مش مشروط بشكل معين المهم يكون نفس الاسم اللى هكتبه فالنيتڤ 
    */
        MethodChannel('Methodexample');
    try {
      return await platform.invokeMethod('counter', value);
    } on PlatformException catch (e) {
      log(e.message.toString());
      return 0;
    }
  }

  static Future<void> openNativeScreen() async {
    await MethodChannel('com.example/native').invokeMethod('openNativeScreen');
  }

  static heavyFunction() async {
    /*
    هنا بقى جربت نفس العملية ومحصلش اى تهنيج 
    لان البلاتفورم بتشتغل على ثريد مستقبل بيها عن ثريد فلاتر
    لكن لما جربته مع السينسور علق لان الحمل تقيل على الثريد فا هنا ممكن نعمل ثريد مختلف فى النيتڤ
    */
    final platform = MethodChannel('Methodexample');
    try {
      return await platform.invokeMethod('heavyLoop', 1000000000);
    } on PlatformException catch (e) {
      log(e.message.toString());
      return 0;
    }
  }

  static heavyLoopWithThread() async {
    final platform = MethodChannel('Methodexample');
    try {
      return await platform.invokeMethod('heavyLoopWithThreads', 1000000000);
    } on PlatformException catch (e) {
      log(e.message.toString());
      return 0;
    }
  }
}

class SensorStream {
  static const EventChannel _sensorChannel =
      EventChannel('com.example.naitveintegrationexample/sensor');

  static Stream<Map<String, double>> get motionStream {
    return _sensorChannel.receiveBroadcastStream().map((event) {
      final Map<dynamic, dynamic> map = event as Map;
      return {
        'x': map['x'] as double,
        'y': map['y'] as double,
        'z': map['z'] as double,
      };
    });
  }
}
