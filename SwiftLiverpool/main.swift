//
//  main.swift
//  SwiftLiverpool
//
//  Created by Justin Bui on 8/25/21.
//

import Foundation
import CoreLocation

func getLocation() {
    let locationManager = CLLocationManager()
    locationManager.startUpdatingLocation()
    
    // Get location attributes
    let latitude = String((locationManager.location?.coordinate.latitude)!)
    let longitude = String((locationManager.location?.coordinate.longitude)!)
    let altitude = String((locationManager.location?.altitude)!)
    let horizontalAccuracy = String((locationManager.location?.horizontalAccuracy)!)
    let verticalAccuracy = String((locationManager.location?.verticalAccuracy)!)
    
    // Get floor level
    var level = 0
    if (locationManager.location?.floor != nil) {
        // https://stackoverflow.com/questions/60837128/clfloor-returns-level-2146959360, it's a bug ...
        if (locationManager.location?.floor!.level != 2146959360) {
            level = (locationManager.location?.floor!.level)!
        }
    }
    
    // Get timestamp
    let timestamp = locationManager.location?.timestamp
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM d, YYYY, HH:mm:ss"
    let formattedTimestamp = dateFormatter.string(from: timestamp!)
    
    print("[*] Getting location data ...")
    print("     [+] Timestamp:", formattedTimestamp)
    print("     [+] Latitude, Longitude:", latitude, ",", longitude)
    print("     [+] Horizontal Accuracy:", horizontalAccuracy, "meter(s)")
    print("     [+] Altitude:", altitude, "meter(s)")
    print("     [+] Vertical Accuracy:", verticalAccuracy, "meter(s)")
    print("     [+] Floor:", level)
    
    // Get speed and course information
    print("[*] Getting speed and course information ...")
    let speed = String((locationManager.location?.speed)!)
    let speedAccuracy = String((locationManager.location?.speedAccuracy)!)
    let course = String((locationManager.location?.course)!)
    let courseAccuracy = String((locationManager.location?.courseAccuracy)!)
    if locationManager.location?.speed ?? -1 > 0 {
        print("     [+] Speed:", speed, "meters/second")
    }
    else {
        print("     [-] Speed could not be obtained")
    }
    if locationManager.location?.speedAccuracy ?? -1 > 0 {
        print("     [+] Speed Accuracy:", speedAccuracy, "meters/second")
    }
    else {
        print("     [-] Speed Accuracy could not be obtained")
    }
    if locationManager.location?.course ?? -1 > 0 {
        print("     [+] Course:", course, "° relative to due north")
    }
    else {
        print("     [-] Course could not be obtained")
    }
    if locationManager.location?.courseAccuracy ?? -1 > 0 {
        print("     [+] Course Accuracy:", courseAccuracy, "°")
    }
    else {
        print("     [-] Course Accuracy could not be obtained")
    }
}

func checkAvailability() -> Bool {
    var status = false
    let lm = CLLocationManager()
    lm.requestWhenInUseAuthorization()
    print("[*] Determining availability of Location Services ...")
    sleep(1) // I'm sorry for this monstrosity, this terror, this horrible practice, this failure to find the root cause, it worked in XCode while being debugged and while analyzing with Console.app and this "fixed" my race condition
    
    if (lm.locationServicesEnabled) {
        print("     [+] Location services is enabled on this device")
    }
    else {
        print("     [-] Location services is disabled on this device")
    }
    
    let authStatus = lm.authorizationStatus
    switch authStatus {
    case .authorizedAlways:
        print("     [+] The user authorized the app to start location services at any time")
    case .denied:
        print("     [-] The user denied the use of location services for the app or they are disabled globally in Settings")
    case .notDetermined:
        print("     [-] The user has not chosen whether the app can use location services")
    case .restricted:
        print("     [-] The app is not authorized to use location services.")
    default:
        print("     [-] SwiftLiverpool was unable to determine authorizationStatus")
    }
    
    if authStatus == .authorizedAlways {
        status = true
        if (lm.accuracyAuthorization == CLAccuracyAuthorization.fullAccuracy) {
            print("     [+] The application has access to location data with full accuracy")
        }
        else {
            print("     [-] The application has access to location data with reduced accuracy")
        }
    }
    
    if (lm.headingAvailable) {
        print("     [+] Location manager can generate heading-related events")
    }
    else {
        print("     [-] Location manager cannot generate heading-related events")
    }
    
    if status {
        getLocation()
    }
    
    return status
}

func banner()
{
    print("""
        @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        @@@@@@@@@@@@@@@(*(#/*/#/((///##%#(//(#(*#@@@@@@@@@@@@@@
        @@@@@@@@@@@(,,,*//**,**//(/#(#*/####(/#%%%%(@@@@@@@@@@@
        @@@@@@@@(/#**,,,,**/**,/(###(/*//*###%%%%%%%%&/&@@@@@@@
        @@@@@@.####*,,.    .,*//*,,****//((((##%%%%%%%&&#.@@@@@
        @@@@*(###((.....   ...../,/*****(((######%%%%%%%&&/&@@@
        @@%/####((.    .    .....,,,,/(##########%%%%%%%%&&%#@@
        @@#####((((.       .......,/(((#########%%%%%%%%%&&&% @
        @%####((((((,*.    ///////*/(((#########%%%%%%%%%%&&%#*
        @(####(((((////.. .*//..//((**(((#######%%%%%%%%%%&&%%,
        *#####(((((///////***....*(((((((#######%%%%%%%%%%%&%%(
        (#####((((((/////////////***/*,*,***/####%%%%%%%%&&&%%#
        *######(((((((//////////((((/,,,******///#%%%%%%%%%&&%#
        @/######(((((((((((((((((((,,*****/////(((((##%%&&&&%%.
        @/########((((((((((((((((((,*****////////((###%&&&%%#*
        @@############((((((((((#####/,,***//////((##%%%&&%%#&@
        @@@*############################***////((((#%%%%%%%#(@@
        @@@@*/%########################/*////(((%%%%&%%%%%.@@@@
        @@@@@@/(%%#####################////((#%%%%&&&%%%*&@@@@@
        @@@@@@@@@(%%%%%%%%%%%%%%%%%%%#(((#%%%%%&&&&&&##@@@@@@@@
        @@@@@@@@@@@@,#%%%%%%%%%%%%%%%##%%%%&&&&&&%(*@@@@@@@@@@@
        @@@@@@@@@@@@@@@@(/(%%%%%%%%%%&&&&&&&%(%%@@@@@@@@@@@@@@@
        """)
    print("")
    print("|~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*|")
    print("|~*~*~*~*~*~* SwiftLiverpool by @slyd0g ~*~*~*~*~*~*~|")
    print("|~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*|")
    print("| Enumerate Location Services using CoreLocation API |")
    print("|~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*|")
}

banner()
checkAvailability()
