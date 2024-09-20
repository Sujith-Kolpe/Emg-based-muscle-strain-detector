#include <WiFi.h>
#include <HTTPClient.h>

const char* ssid = "$ujith";
const char* password = "000000000";
const char* serverName = "http://192.168.142.173:3000/data"; // Update this to your server's IP and endpoint

const int pulsePin = 35; // GPIO 35 for the pulse sensor
int threshold = 100;     // Adjust based on your sensor's output

unsigned long lastPulseTime = 0; // Timestamp of the last detected pulse
int beatsPerMinute = 0;          // Calculated BPM value

void setup() {
  Serial.begin(115200);
  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting to WiFi...");
  }

  Serial.println("Connected to WiFi");
  pinMode(pulsePin, INPUT);
}

void loop() {
  if (WiFi.status() == WL_CONNECTED) {
    int pulseValue = analogRead(pulsePin);
    int emgValue = analogRead(34); // Read EMG sensor value regardless of pulse detection

    if (pulseValue > threshold || emgValue > 0) {
      unsigned long currentTime = millis();

      // Calculate interval since last pulse
      unsigned long timeSinceLastPulse = currentTime - lastPulseTime;

      // Only update BPM if a pulse is detected
      if (pulseValue > threshold) {
        // Calculate BPM based on the interval between pulses
        beatsPerMinute = 60000.0 / ((float)timeSinceLastPulse); // 60000 ms in a minute

        Serial.print("Pulse Value: ");
        Serial.println(pulseValue);
        Serial.print("Time Since Last Pulse: ");
        Serial.println(timeSinceLastPulse);
        Serial.print("Calculated BPM: ");
        Serial.println(beatsPerMinute);
        Serial.print("EMG Value: ");
        Serial.println(emgValue);

        // Update last pulse time
        lastPulseTime = currentTime;

        // Check if BPM is within the range of 60 to 90
        if (beatsPerMinute >= 60 && beatsPerMinute <= 90) {
          HTTPClient http;
          http.begin(serverName);
          http.addHeader("Content-Type", "application/json");

          // Include the 'port' field in your JSON payload
          String postData = "{\"port\": 1, \"emg\": " + String(emgValue) + ", \"bpm\": " + String(beatsPerMinute) + "}";
          int httpResponseCode = http.POST(postData);

          if (httpResponseCode > 0) {
            String response = http.getString();
            Serial.print("HTTP Response code: ");
            Serial.println(httpResponseCode);
            Serial.print("Response: ");
            Serial.println(response);
          } else {
            Serial.print("Error on sending POST: ");
            Serial.println(httpResponseCode);
          }
          http.end();
        }
      }
    } else {
      Serial.println("Pulse not detected");
    }
  } else {
    Serial.println("WiFi Disconnected");
  }

  delay(10); // Send data every 0.5 seconds (adjust as needed)
}
