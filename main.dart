import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async'; // Import for Timer

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WifiApp(),
    );
  }
}

class WifiApp extends StatefulWidget {
  @override
  _WifiAppState createState() => _WifiAppState();
}

class _WifiAppState extends State<WifiApp> {
  String emgValue = '';
  String bpmValue = '';
  String errorMessage = '';
  Timer? timer; // Timer variable
  bool showWarningMessage =
      false; // Flag to track if warning message is displayed
  int lastEmg = 0; // Last fetched EMG value
  int lastBpm = 0; // Last fetched BPM value
  DateTime lastUpdateTime = DateTime.now(); // Time of last data update
  Duration pulseNotDetectedThreshold =
      Duration(seconds: 10); // Threshold for pulse not detected

  @override
  void initState() {
    super.initState();
    fetchDataPeriodically();
  }

  @override
  void dispose() {
    timer?.cancel(); // Cancel timer to avoid memory leaks
    super.dispose();
  }

  void fetchDataPeriodically() {
    const duration = Duration(seconds: 2); // Fetch data every 2 seconds
    timer = Timer.periodic(duration, (Timer t) {
      if (!showWarningMessage) {
        fetchData(); // Call fetchData() every 2 seconds if no warning message is displayed
      }
    });
  }

  Future<void> fetchData() async {
    try {
      final response =
          await http.get(Uri.parse('http://192.168.51.173:3000/data'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          emgValue = data['port1']['emg']?.toString() ?? 'No Data';
          bpmValue = data['port1']['bpm']?.toString() ?? 'No Data';
        });

        // Check EMG value against threshold
        int parsedEmg = int.tryParse(emgValue) ?? 0;
        bool showWarning = parsedEmg > 2000;

        // Check if EMG and BPM values remain same for pulseNotDetectedThreshold duration
        if (parsedEmg == lastEmg &&
            int.tryParse(bpmValue) == lastBpm &&
            DateTime.now().difference(lastUpdateTime) >=
                pulseNotDetectedThreshold) {
          showPulseNotDetected();
        }

        // Update last values and time
        lastEmg = parsedEmg;
        lastBpm = int.tryParse(bpmValue) ?? 0;
        lastUpdateTime = DateTime.now();

        if (showWarning) {
          showMuscleStrainWarning();
        }
      } else {
        setState(() {
          errorMessage = 'Failed to load data: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load data: $e';
      });
    }
  }

  void showMuscleStrainWarning() {
    setState(() {
      showWarningMessage =
          true; // Set flag to true when showing warning message
    });

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing dialog by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Muscle Strain Detected'),
          content: Text('EMG value exceeds threshold of 2000.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  showWarningMessage =
                      false; // Reset flag when warning message is dismissed
                });
              },
            ),
          ],
        );
      },
    );
  }

  void showPulseNotDetected() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing dialog by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pulse Not Detected'),
          content: Text(
              'No change in EMG and BPM values for ${pulseNotDetectedThreshold.inSeconds} seconds.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wi-Fi Data'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (errorMessage.isNotEmpty) ...[
                  Text(errorMessage, style: TextStyle(color: Colors.red)),
                ] else ...[
                  _buildDataContainer(
                      'assets/emg_icon.jpeg', 'EMG Value', emgValue),
                  SizedBox(height: 20),
                  _buildDataContainer('assets/bpm.jpg', 'BPM Value', bpmValue),
                ],
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (!showWarningMessage) {
                      fetchData(); // Only allow refresh if no warning message is displayed
                    }
                  },
                  child: Text('Refresh'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataContainer(String imagePath, String label, String value) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(imagePath, width: 40, height: 40),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
