import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final waterProvider = StateProvider<int>((ref) => 0);
void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: WaterScreen());
  }
}

class WaterScreen extends ConsumerWidget {
  const WaterScreen({super.key});

  @override
  Widget build(context, ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('State Provider')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Number of glasses of water consumed:'),
            Consumer(
              builder: (context, ref, child) {
                final count = ref.watch(waterProvider);
                return Text('$count', style: const TextStyle(fontSize: 24));
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(waterProvider.notifier).state++,
        child: const Icon(Icons.add),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class WaterCubit extends Cubit<int>{
//   WaterCubit() : super(0);
//   void drinkWater() => emit(state+ 1);
//   void reset() => emit(0);
// }
// void main(){
//   runApp(
//     BlocProvider(
//       create: (context) => WaterCubit(),
//       child: const MyApp(),
//     )
//   );
// }
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: WaterScreen()
//     );
//   }
// }
// class WaterScreen extends StatelessWidget{
//   const WaterScreen({super.key});
//   @override
//   Widget build(BuildContext context){
//     return Scaffold(appBar: AppBar(title: const Text('Bloc'),),
//     body: Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children:[
//           const Text('Number of glasses of water comsumed:'),
//           BlocBuilder<WaterCubit,int>(
//             builder: (context,count){
//               return Text('$count', style: const TextStyle(fontSize: 24));
//             }
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ElevatedButton(onPressed: () => context.read<WaterCubit>().drinkWater(), child: const Text('Drink Water')),
//               const SizedBox(width: 20,),
//               ElevatedButton(onPressed: () => context.read<WaterCubit>().reset(), child: const Text('Reset')),
//             ],
//           )
//         ],
//       )
//     ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class WaterController extends GetxController{
//   var count = 0.obs;
//   void drinkWater() => count.value++;
//   void reset() => count.value = 0;
// }
// void main(){
//   runApp(const GetMaterialApp(
//     home: WaterScreen(),
//   ));
// }
// class WaterScreen extends StatelessWidget{
//   const WaterScreen({super.key});
//   @override
//   Widget build(BuildContext context){
//     final WaterController waterController = Get.put((WaterController()));
//     return Scaffold(appBar: AppBar(title: const Text('GetX'),),
//     body: Center(
//        child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Text('Number of glasses of water consumed:'),
//           Obx(() => Text('${waterController.count.value}', style: const TextStyle(fontSize: 24))),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ElevatedButton(onPressed: () => waterController.drinkWater(), child: const Text('Drink Water')),
//               const SizedBox(width: 20,),
//               ElevatedButton(onPressed: () => waterController.reset(), child: const Text('Reset')),
//             ],
//           )
//         ]
//        )
//     ));
//   }
// }