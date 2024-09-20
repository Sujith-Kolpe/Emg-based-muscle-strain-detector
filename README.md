# **EMG-Based Muscle Strain Detector with Heart Rate Monitoring**

## **Overview**
This project presents a real-time muscle strain detector using an EMG sensor and heart rate monitor. The system is built around an ESP32 microcontroller, with sensor data transmitted to a Node.js server and a custom Flutter application for real-time remote monitoring.

The system detects electrical muscle activity, helping monitor muscle strain and heart rate in applications such as healthcare, sports, and rehabilitation. By providing this data, it aids in injury prevention and facilitates better recovery.

## **Features**
- **Real-time monitoring:** Captures muscle strain and heart rate data using EMG and heart rate sensors.
- **Wireless data transmission:** Sends sensor data via ESP32 to a Node.js server and a custom Flutter app for remote access.
- **Dual power supply:** Powered by two 9V batteries for portability and flexibility.
- **Applications:** Useful in healthcare, sports training, and physical therapy for monitoring muscle activity and preventing injuries.

## **Hardware Components**
- **Microcontroller:** ESP32
- **EMG Sensor:** For detecting muscle strain
- **Heart Sensor:** Pulse Sensor HBT-V2 for heart rate monitoring
- **Power Supply:** Two 9V batteries for the EMG sensor
- **Other Components:** Wires, connectors, breadboard (or PCB for final setup)

## **Software Components**
- **Node.js Server:** For receiving and processing sensor data
- **Flutter App:** Custom mobile app for real-time data visualization
- **ESP32 Code:** Written in Arduino IDE for capturing and transmitting sensor data

## **How it Works**
1. **Data Acquisition:**
   - The EMG sensor captures electrical activity from the muscles.
   - The HBT-V2 pulse sensor captures heart rate.
   
2. **Data Processing:**
   - The ESP32 processes the acquired data.
   - The processed data is sent wirelessly to a Node.js server.
   
3. **Data Visualization:**
   - The Node.js server transmits the data to a custom-built Flutter app for real-time display and monitoring.

## **Future Enhancements**
- Advanced signal processing to enhance accuracy and filter noise.
- Integration of additional sensors for more comprehensive health monitoring.
- Improvements to the mobile app, including graphical analysis and more customization options.
  
## **Getting Started**

### **Prerequisites**
- ESP32
- Arduino IDE installed
- Node.js installed
- Flutter SDK installed

### **Installation Steps**

1. **Hardware Setup:**
   - Connect the EMG sensor to the ESP32.
   - Connect the HBT-V2 heart rate sensor to the ESP32.
   - Power the EMG sensor using two 9V batteries.

2. **ESP32 Firmware:**
   - Open the `emg_detector.ino` file in Arduino IDE.
   - Upload the code to the ESP32.

3. **Node.js Server:**
   - Clone the repository.
   - Navigate to the `server` directory and run `npm install` to install dependencies.
   - Run `node server.js` to start the server.

4. **Flutter App:**
   - Navigate to the `flutter_app` directory.
   - Run `flutter pub get` to install dependencies.
   - Run the app on an Android/iOS device or an emulator.
  
## **Contributing**
Feel free to fork this project and submit pull requests for any improvements or bug fixes.

## **License**
This project is licensed under the MIT License.


