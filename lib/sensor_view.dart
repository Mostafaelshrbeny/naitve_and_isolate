import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gif/gif.dart';
import 'package:isolation_and_naitve/cubit/cubit1.dart';
import 'package:isolation_and_naitve/cubit/state1.dart';
import 'package:isolation_and_naitve/naitve_integration.dart';

class SensorPage extends StatelessWidget {
  const SensorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SensorCubit(),
      child: Scaffold(
        body: BlocBuilder<SensorCubit, State1>(
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    transform: Matrix4.identity()
                      ..rotateX(state.data['x'] ?? 0.0)
                      ..rotateY(state.data['y'] ?? 0.0)
                      ..rotateZ(state.data['z'] ?? 0.0),
                    child: SvgPicture.asset(
                      "assets/images/location-arrow-svgrepo-com.svg",
                      height: 150,
                    )),
                Gif(
                    autostart: Autostart.loop,
                    image: AssetImage(
                        'assets/images/Animation - 1749845318238.gif')),
                ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all(Colors.deepPurple),
                    ),
                    onPressed: () {
                      context.read<SensorCubit>().count();
                    },
                    child: Text(
                      "count: ${state.count}",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    )),
                ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all(Colors.deepPurple),
                    ),
                    onPressed: () async {
                      await context.read<SensorCubit>().heavyNaitve();
                    },
                    child: Text(
                      "without isolated threads",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    )),
                SizedBox(width: double.infinity),
                ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all(Colors.deepPurple),
                    ),
                    onPressed: () async {
                      await context
                          .read<SensorCubit>()
                          .heavyNaitveWithIsolatedThreads();
                    },
                    child: Text(
                      "heavyNaitve with isolated threads",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    )),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(onPressed: () async {
          await IntergartionFunctions.openNativeScreen();
        }),
      ),
    );
  }
}
