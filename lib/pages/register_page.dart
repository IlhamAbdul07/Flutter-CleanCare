import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/register_controller.dart';
import '../widgets/register_step_form.dart';
import '../widgets/register_step_verify.dart';

class RegisterPage extends StatelessWidget {
  final c = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Obx(() {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: c.step.value == 1
                ? RegisterStepVerifyWidget()
                : RegisterStepFormWidget(),
          );
        }),
      ),
    );
  }
}
