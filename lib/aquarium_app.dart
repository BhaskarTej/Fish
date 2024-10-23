// lib/aquarium_app.dart
import 'package:flutter/material.dart';
import 'fish.dart';
import 'database_helper.dart';

class AquariumApp extends StatefulWidget {
  @override
  _AquariumAppState createState() => _AquariumAppState();
}

class _AquariumAppState extends State<AquariumApp> with SingleTickerProviderStateMixin {
  List<Fish> fishList = [];
  Color selectedColor = Colors.blue;
  double selectedSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() async {
    final settings = await DatabaseHelper.instance.getSettings();
    if (settings != null) {
      setState(() {
        int fishCount = settings['fish_count'];
        selectedSpeed = settings['speed'];
        selectedColor = Color(int.parse(settings['color']));

        // Add fish according to the saved count
        for (int i = 0; i < fishCount; i++) {
          Fish newFish = Fish(color: selectedColor, speed: selectedSpeed);
          newFish.startSwimming(this);
          fishList.add(newFish);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Virtual Aquarium')),
      body: Column(
        children: [
          Container(
            width: 300,
            height: 300,
            color: Colors.lightBlueAccent,
            child: Stack(
              children: fishList.map((fish) => fish.buildFish()).toList(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _addFish,
                child: Text('Add Fish'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: _saveSettings,
                child: Text('Save Settings'),
              ),
            ],
          ),
          Slider(
            value: selectedSpeed,
            min: 0.5,
            max: 3.0,
            divisions: 5,
            label: 'Speed: $selectedSpeed',
            onChanged: (value) {
              setState(() {
                selectedSpeed = value;
              });
            },
          ),
          DropdownButton<Color>(
            value: selectedColor,
            items: [
              DropdownMenuItem(
                child: Text('Blue'),
                value: Colors.blue,
              ),
              DropdownMenuItem(
                child: Text('Red'),
                value: Colors.red,
              ),
              DropdownMenuItem(
                child: Text('Green'),
                value: Colors.green,
              ),
            ],
            onChanged: (color) {
              setState(() {
                selectedColor = color!;
              });
            },
          ),
        ],
      ),
    );
  }

  void _addFish() {
    if (fishList.length < 10) {
      Fish newFish = Fish(color: selectedColor, speed: selectedSpeed);
      newFish.startSwimming(this);
      setState(() {
        fishList.add(newFish);
      });
    }
  }

  void _saveSettings() async {
    await DatabaseHelper.instance.saveSettings(
      fishList.length,
      selectedSpeed,
      selectedColor.value.toString(),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Settings saved!')),
    );
  }
}
