# ParkPlace

A parking mobile applicatiom which enables users to park their vehicles as well as rent their location for parking. Clone the project through this link:
   * For Mobile App:  https://github.com/Samiksha99/ParkPlace

## Getting Started

The ParkPlace will provide 2 interfaces to users, One for parking your vehicle and another one for renting your place. Users can easily register through Phone authetication and
enter their details. We are taking Aadhar Number of the user who wants to rent their place and verifying it for securtiy purposes. The user can add the time slots at which he/she wants to rent their place and can update as per their choice.We are taking current location of the person who wants to park their vehicle So that we can sort locations according to his/her nearby parking location from our database. After selecting the parking location and completing the payment stuff (either through razorpay or cryptocurrency), we will let our users to see the complete direction from his current location to the parking place with live tracking system in our application.

## How to Use 

**Step 1:**

Download or clone this repo by using the link below:
```
https://github.com/Samiksha99/ParkPlace.git
```
**Step 2:**

Go to project root and execute the following command in console to get the required dependencies: 

```
flutter pub get 
```
**Step 3:**

After it run this command:
  ```
  flutter run
  ```
  
  Tools & modules Used:
  - Flutter 
  - FireBase (for backend and database)
  - Google_maps_flutter
  - razorpay_flutter
  - geocoding
  - geolocator
  - flutter_polyline_points
  - cloud_firestore
  - Tezster_dart
  - flutter_google_places
  
