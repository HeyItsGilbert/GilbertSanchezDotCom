+++
date = 2020-12-31T20:11:55Z
description = "A left over LED and a few spare parts turns into a fun and potential useful project."
draft = false
slug = "controlling-a-cheap-led"
summary = "A left over LED and a few spare parts turns into a fun and potential useful project."
tags = ["Docker", "Arduino"]
title = "Controlling a Cheap \"Neon\" LED, Pt 1"

+++


> WARNING: I know very little about electronics. Messing with electricity can be deadly. Please take the appropriate precautions. Aka please don't sue me.

This all started with a spare "Neon" light that was meant for my sons room but it never went up. Something I found odd about this light was that it had the ability to be powered by either a USB connection OR a 3 AA battery pack. The thing that struck me was how they were both spliced together. I figured the amount of Volts must be similar.

If you want to skip the story and get to the good stuff, scroll down to Final Setup.

[https://www.instagram.com/p/CJM3kuJpBvR/](https://www.instagram.com/p/CJM3kuJpBvR/)

Let me preface this with: I know very little about electronics. This was my attempt at going from the "absolute beginner control a LED on a breadboard" to something I actually wanted.

## Research

I started looking at how much voltage a USB connector would provide. I found out it was about 5v. I had a spare microcontroller and I saw that it also had a 5v output.

I cut the line for the lights and tried connecting each end to either the ground and the 5v and success! So that would be always on, which I wasn't looking for so the next step was using a digital pin to try to toggle it on.

I plugged in the neutral line to the ground and connected the digital pin to the light and ran some sample code that would flip on the pin every 5 seconds. And LIGHT! Well... more like "light". The brightness was much lower. After I looked it up, I found the pins output 3.3v. Good but not good enough.

## Relays and Transistors

After consulting with a friend (thanks Oyvind!) I was suggested to check out relays. At the start of this journey I bought a cheap starter electronics pack with a bunch of components. After watching a few YouTube videos I settled on using the relay I had.

> **Relays** are electric switches that use electromagnetism to convert small electrical stimuli into larger currents. These conversions occur when electrical inputs activate electromagnets to either form or break existing circuits. - Google

So now we can use our 3.3v digital pin to flip the relay on and off. That relay is fed 5v and when it's on we have our bright LED!

To safely control the relay we use a transistor to control when the relay connection is completed.

Random Starter Pack I used:

{{< bookmark url="https://www.amazon.com/REXQualis-Complete-Development-Detailed-Tutorial/dp/B07BLV5LFY" title="Amazon.com: REXQualis Complete Starter Kit based on Arduino UNO R3 w/Detailed Tutorial and Controller Board Compatible with Arduino IDE: Computers & Accessories" description="Amazon.com: REXQualis Complete Starter Kit based on Arduino UNO R3 w/Detailed Tutorial and Controller Board Compatible with Arduino IDE: Computers & Accessories" icon="" author="Sanjay Patel" publisher="Brands related to this category on Amazon Create the futureShop ELEGOO\u00a0Shop now Shop the Yahboom StoreShop DIY Smart Robot for Christmas\u00a0Shop now Board for ArduinoShop KEYESTUDIO\u00a0Shop now Freenove Ultimate Starter Kit for Raspberry Pi 4 BShop Freenove\u00a0Shop now Flexible Planters for Healthy SeedlingsShop FLEXI-POT\u00a0Shop now RexQualis Inc. is a professional manufacturer of electronic components products, involved in development, design, production and saleing. We are committed to helping customer quickly realize the creative idea and product prototypes, making it easy to get started for enthusiasts of programing and electronics and launching innovative open source products. Our services include: Electronic components and modules Learning kit for Arduino Learning kit for Raspberry Pi Product customization service Robot kits RexQualis Inc. is a professional manufacturer of electronic components products, involved in development, design, production and saleing. We are committed to helping customer quickly realize the creative idea and product prototypes, making it easy to get started for enthusiasts of programing and electronics and launching innovative open source products. Our services include: Electronic components and modules Learning kit for Arduino Learning kit for Raspberry Pi Product customization service Robot kits" thumbnail="https://fls-na.amazon.com/1/batch/1/OP/ATVPDKIKX0DER:132-4813663-4351325:RB7YACP2AK3R5WVHV8YJ$uedata=s:%2Frd%2Fuedata%3Fstaticb%26id%3DRB7YACP2AK3R5WVHV8YJ%26pty%3D%26spty%3D%26pti%3D:1000" caption="" >}}

## Microcontroller (ESP8266)

So I ordered a 5 pack of ESP8266 microcontrollers from Amazon for around $10. These are great because they're super cheap and they come with easy to use WiFi library.

{{< bookmark url="https://www.amazon.com/Organizer-ESP8266-Internet-Development-Compatible/dp/B081PX9YFV" title="Amazon.com: Organizer ESP8266 ESP-12 ESP-12F NodeMcu Mini D1 Module WeMos Lua 4M Bytes WLAN WiFi Internet Development Board Base on ESP8266 ESP-12F for Arduino,Compatible with WeMos D1 Mini (5pcs): MP3 Players & Accessories" description="Amazon.com: Organizer ESP8266 ESP-12 ESP-12F NodeMcu Mini D1 Module WeMos Lua 4M Bytes WLAN WiFi Internet Development Board Base on ESP8266 ESP-12F for Arduino,Compatible with WeMos D1 Mini (5pcs): MP3 Players & Accessories" icon="" author="" publisher="" thumbnail="https://fls-na.amazon.com/1/batch/1/OP/ATVPDKIKX0DER:138-9698823-1417029:4PBJZWWSMFC37623BRGP$uedata=s:%2Frd%2Fuedata%3Fstaticb%26id%3D4PBJZWWSMFC37623BRGP%26pty%3DDetail%26spty%3DGlance%26pti%3DB08GWL5ZR6:1000" caption="" >}}

## MQTT Broker

I have small docker setup at my house running on a NUC. I read that HomeAssistant can easily talk to a MQTT server so I searched for a simple broker to run in docker. `eclipse-mosquitto` was easy enough to run.

# Final Setup

This will likely be a 2 part post since I'm still writing the client and I want to talk a bit about the home assistant integration which could use some more polishing. Stay tuned!

## Schematic

{{< figure src="/images/2021/01/20210101_114447.jpg" caption="My poorly drawn schematic." >}}

## Final Prototype Board

{{< figure src="/images/2021/01/20201231_125330.jpg" caption="Top of the prototype board." >}}

{{< figure src="/images/2021/01/20201231_125319.jpg" caption="Underside of the prototype board" >}}

## Docker Config

My MQTT broker is eclipse-mosquitto

```docker
mqtt:
     image: eclipse-mosquitto:latest
     container_name: mqtt
     volumes:
       - $DOCKERDIR/mqtt/config:/mosquitto/config
       - $DOCKERDIR/mqtt/data:/mosquitto/data
       - $DOCKERDIR/mqtt/log:/mosquitto/log
     networks:
       - iot
     ports:
       - 1883:1883
       - 9001:9001
```

My network `iot` is an external docker network that routes to a vlan just for my IOT devices.

## Arduino

```arduino
#include <ESP8266WiFi.h>
#include <PubSubClient.h>
#define LightPin D1 // Define which pin controls the light

const char* room = "Office";
const char* ssid     = "WeAre138_2G";      // SSID of local network
const char* password = "hunter2";   // Password on network
const char* mqtt_server = "192.168.138.900"; // MQTT Server IP

// Timers auxiliar variables
long now = millis();
long lastMeasure = 0;

// Variables
char* topic;

WiFiClient espClient;
PubSubClient client(espClient);

void callback(char* topic, byte* payload, unsigned int length) {
  Serial.print("Message arrived [");
  Serial.print(topic);
  Serial.print("] ");
  String messageTemp;
  for (int i=0;i<length;i++) {
    Serial.print((char)payload[i]);
    messageTemp += (char)payload[i];
  }
  Serial.println();
  Serial.print("Message Temp: ");
  Serial.println(messageTemp);
  
  if(messageTemp == "ON"){
    digitalWrite(LightPin, HIGH);
    digitalWrite(LED_BUILTIN, LOW);
  }
  if(messageTemp == "OFF"){
    digitalWrite(LightPin, LOW);
    digitalWrite(LED_BUILTIN, HIGH);
  }
}

void setup() {
  pinMode(LightPin, OUTPUT);
  pinMode(LED_BUILTIN, OUTPUT);

  delay(2000);
  Serial.begin(115200);

  // Turn off LED
  digitalWrite(LED_BUILTIN, HIGH);

  WiFi.hostname("office_esp8266"); //This changes the hostname of the ESP8266 to display neatly on the network esp on router.
  WiFi.begin(ssid, password);
  
  client.setServer(mqtt_server, 1883);
  client.setCallback(callback);
}

// This functions reconnects your ESP8266 to your MQTT broker
// Change the function below if you want to subscribe to more topics with your ESP8266 
void reconnect() {
  // Loop until we're reconnected
  while (!client.connected()) {
    Serial.print("Attempting MQTT connection...");
    // Attempt to connect
    if (client.connect("ESP8266Client")) {
      Serial.println("connected");  
      // Subscribe or resubscribe to a topic
      // You can subscribe to more topics (to control more LEDs in this example)
      client.subscribe("homeassistant/binary_sensor/office/lightning");
    } else {
      Serial.print("failed, rc=");
      Serial.print(client.state());
      Serial.println(" try again in 5 seconds");
      // Wait 5 seconds before retrying
      delay(5000);
    }
  }
}

void loop() {
  if (!client.connected()) {
    reconnect();
  }
  if(!client.loop())
    client.connect("ESP8266Client");

  // client.publish("homeassistant/binary_sensor/office/lightning", "ON");
  // client.publish("homeassistant/binary_sensor/office/lightning", "OFF");

}
```



