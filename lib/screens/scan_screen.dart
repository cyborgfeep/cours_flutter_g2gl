import 'package:camera/camera.dart';
import 'package:cours_flutter/main.dart';
import 'package:cours_flutter/widgets/card_widget.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  late CameraController controller;
  PageController pageController = PageController();
  bool isFlashOn=false;
  bool valueSwitch=false;

  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: pageController,
            children: [
              Stack(
                children: [
                  AspectRatio(
                      aspectRatio: MediaQuery.of(context).size.width /
                          MediaQuery.of(context).size.height,
                      child: CameraPreview(controller)),
                  ColorFiltered(
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(.5), BlendMode.srcOut),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(color:Colors.black,backgroundBlendMode: BlendMode.dstOut),
                        ),
                        Center(
                          child: Container(
                            width: 300,
                            height: 300,
                            decoration: BoxDecoration(color: Colors.red,borderRadius: BorderRadius.circular(25)),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(onTap: (){
                          if(isFlashOn){
                            controller.setFlashMode(FlashMode.off);
                          }else{
                            controller.setFlashMode(FlashMode.torch);
                          }
                          setState(() {
                            isFlashOn=!isFlashOn;
                          });
                        },child: Icon(!isFlashOn?Icons.flash_off:Icons.flash_on,color: Colors.white,))
                      ],
                    ),
                  )
                ],
              ),
              Center(
                child: Container(color: Colors.white,
                child: RotatedBox(quarterTurns:1,child: CardWidget(isClickable: false,)),),
              )
            ],
          ),
          Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.only(bottom: 50),
            child:
            ToggleSwitch(
              initialLabelIndex: 0,
              radiusStyle: true,
              totalSwitches: 2,
              labels: ['Scanner un code', 'Ma carte'],
              cornerRadius: 25,
              activeBgColors: [!valueSwitch?[
                Colors.white,
              ]:[Colors.grey],valueSwitch?[
                Colors.white,
              ]:[Colors.grey]],
              minWidth: 150,
              //inactiveBgColor: Colors.black,
              activeFgColor: !valueSwitch?Colors.white:Colors.black,
              onToggle: (index) {
                print('switched to: $index');

                pageController.animateToPage(index!, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                /*setState(() {
                  valueSwitch=index==0?false:true;
                });*/
                },
            ),
          )
        ],
      ),
    );
  }
}
