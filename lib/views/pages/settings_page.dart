import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController controller = TextEditingController();
  bool? isChecked = false;
  bool isSwitched = false;
  double sliderValue = 0.0;
  String? menuItem = 'e1';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FilledButton(onPressed: () {}, child: Text("Reset Favorites")),
              SizedBox(height: 40),
              // DropdownButton(
              //   value: menuItem,
              //   items: [
              //     DropdownMenuItem(value: 'e1', child: Text('Element 1')),
              //     DropdownMenuItem(value: 'e2', child: Text('Element 2')),
              //     DropdownMenuItem(value: 'e3', child: Text('Element 3')),
              //   ],
              //   onChanged: (String? value) {
              //     setState(() {
              //       menuItem = value;
              //     });
              //   },
              // ),
              // TextField(
              //   controller: controller,
              //   decoration: InputDecoration(border: OutlineInputBorder()),
              //   onEditingComplete: () => setState(() {}),
              // ),
              // Text(controller.text),
              // Checkbox.adaptive(
              //   value: isChecked,
              //   onChanged: (bool? value) {
              //     setState(() {
              //       isChecked = value!;
              //     });
              //   },
              // ),
              // CheckboxListTile.adaptive(
              //   title: Text("Click me"),
              //   value: isChecked,
              //   onChanged: (bool? value) {
              //     setState(() {
              //       isChecked = value!;
              //     });
              //   },
              // ),
              // Switch.adaptive(
              //   value: isSwitched,
              //   onChanged: (bool value) {
              //     setState(() {
              //       isSwitched = value;
              //     });
              //   },
              // ),
              // SwitchListTile.adaptive(
              //   title: Text("Switch me"),
              //   value: isSwitched,
              //   onChanged: (bool value) {
              //     setState(() {
              //       isSwitched = value;
              //     });
              //   },
              // ),
              // Slider.adaptive(
              //   max: 10.0,
              //   value: sliderValue,
              //   divisions: 10,
              //   onChanged: (double value) {
              //     setState(() {
              //       sliderValue = value;
              //     });
              //     print(value);
              //   },
              // ),
              // InkWell(
              //   splashColor: Colors.teal,
              //   onTap: () {
              //     print("Image clicked");
              //   },
              //   child: Container(
              //     height: 50,
              //     width: double.infinity,
              //     color: Colors.white12,
              //   ),
              // ),
              // ElevatedButton(
              //   onPressed: () {},
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.teal,
              //     foregroundColor: Colors.white,
              //   ),
              //   child: Text("click me"),
              // ),
              // ElevatedButton(onPressed: () {}, child: Text("click me")),
              // FilledButton(onPressed: () {}, child: Text("click me")),
              // TextButton(onPressed: () {}, child: Text("click me")),
              // OutlinedButton(onPressed: () {}, child: Text("click me")),
              // CloseButton(),
              // BackButton(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Material(
          elevation: 8,
          color: Theme.of(context).colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Image(
                      image: AssetImage('assets/images/fpZSrOZ.gif'),
                      height: 80,
                    ),
                    SizedBox(width: 12),
                    Image(
                      image: AssetImage('assets/images/RpVCQpe.gif'),
                      height: 80,
                    ),
                    SizedBox(width: 12),
                    Image(
                      image: AssetImage('assets/images/XNoCsYg.gif'),
                      height: 80,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  "Made by Christian James Lee with Flutter for learning",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 4),
                const Text(
                  "https://github.com/christianJames24",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Datasets for images and data from Kaggle",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
