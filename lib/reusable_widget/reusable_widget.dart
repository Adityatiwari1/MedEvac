import 'package:flutter/material.dart';

class BackgroundImage extends StatelessWidget {
  const BackgroundImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/background.jpg"),
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
      ),
    );
  }
}

Widget reusableTextField(
    String text, bool isPasswordType, TextEditingController controller,
    {bool onSubmitEnabled = true, Function(String, String)? onSubmit}) {
  void handleOnSubmit(String value) {
    if (onSubmitEnabled && onSubmit != null) {
      onSubmit(value, controller.text);
    }
  }

  return SizedBox(
    width: 350,
    child: TextField(
      controller: controller,
      obscureText: isPasswordType,
      enableSuggestions: !isPasswordType,
      autocorrect: !isPasswordType,
      cursorColor: Colors.black,
      style: TextStyle(color: Colors.black.withOpacity(0.9)),
      decoration: InputDecoration(
        labelText: text,
        labelStyle: TextStyle(color: Colors.black.withOpacity(0.9)),
        filled: true,
        floatingLabelAlignment: FloatingLabelAlignment.start,
        floatingLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        fillColor: Colors.white.withOpacity(0.5),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
      ),
      keyboardType: isPasswordType
          ? TextInputType.visiblePassword
          : TextInputType.emailAddress,
      onSubmitted: handleOnSubmit,
    ),
  );
}

Container loginButton(
    BuildContext context, Function onTap, Function onSubmitted) {
  return Container(
    width: 95,
    height: 45,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onTap();
        onSubmitted();
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith(
          (states) {
            if (states.contains(MaterialState.pressed)) {
              return const Color(0xFF6C9BCF);
            } else if (states.contains(MaterialState.hovered)) {
              return const Color.fromARGB(255, 188, 188, 255);
            }
            return Colors.white;
          },
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
      ),
      child: const Text(
        'Login',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    ),
  );
}

Container sosButton(BuildContext context, Function onTap) {
  return Container(
    width: 90,
    height: 45,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith(
          (states) {
            if (states.contains(MaterialState.pressed)) {
              return const Color(0xFF6C9BCF);
            } else if (states.contains(MaterialState.hovered)) {
              return const Color.fromARGB(255, 188, 188, 255);
            }
            return Colors.white;
          },
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
      ),
      child: const Text(
        'SOS',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    ),
  );
}


