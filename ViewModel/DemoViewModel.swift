//
//  DemoViewModel.swift
//  nextiles-demo
//
//  Created by Work on 5/17/22.
//

import Foundation
import NextilesSDK
import SwiftUI
import Combine

class DemoViewModel: ObservableObject, bleProtocols {
    
    //MARK: Enter your organization
    //initializing the sdk with the organziation that is allowed to use the token
    //plist must be included in the project files
    //if incorrect organization is provided or token is no longer valid,
    //false will be returned
    var sdk = NextilesSDK(organization: "You organization name here") { success in
        if !success{
            fatalError("SDK not initialized")
        }
    }
    
    
    //MARK: SDK Functions
    //Get session function returns analytics for a particular session
    func sdkGetSession(){
        addLine(newLine: "Getting data for your most recent session.")
        
        //First will get all session for a particular user, in this case the demo user
        //to get all the session for a particular user call the .getUserSessions function
        let demoUser = getDemoUser()
        
        //returned will be a bool to inform you if the sdk was able to get the sessions for a particular user
        //also returned is an array of strings is all the user session timestamps
        sdk.getUserSessions(user: demoUser,completionHandler: { success, allSessions in
            
            DispatchQueue.main.async{
            if success {
                //checking to see if the user performed any sessions
                if allSessions.count > 0{
                    if let recentSession = allSessions.last{
                        self.addLine(newLine: "User most recent session is: \(recentSession)")
                        self.compilerNewLine()
                        
                        self.addLine(newLine: "Getting session summary...")
                        
                        //taking the last session which is the most recent session
                        //to get analytics on the session
                        //to get analytics call the .getSession function
                        //returned is a bool to iform you if the networking call was made correctly
                        //also returned is an optional session which holds anayltics on reps, peaks, force, etc
                        self.sdk.getSession(user: demoUser, timeStamp: recentSession) { success, returnedSession in
                            DispatchQueue.main.async{
                            if success {
                                if let sessionData = returnedSession{
                                    self.addLine(newLine: "Session Data: \(sessionData)")
                                    self.compilerNewLine()
                                }
                                else {
                                    self.addLine(newLine: "No Summary for data")
                                    self.compilerNewLine()
                                }
                            }
                            else {
                                self.addLine(newLine: "No summary for data")
                                self.compilerNewLine()
                            }
                        }
                    }
                    }
                }
                else {
                    self.addLine(newLine: "User has no sessions")
                    self.compilerNewLine()
                }
            }
            else {
                self.addLine(newLine: "Can't get user sessions")
                self.compilerNewLine()
            }
        }
        })
    }
    
    //should be called when a user has completed their session
    //this will stop collecting data from nextile devices and upload any files that have not been uploaded yet
    func sdkStopSession(){
        addLine(newLine: "Stopping session...")
        
        //there are two ways to stop session
        //in the first way displayed returned to the user will be the sesison timestamp which can be used to get analytics on the session by calling getSession function
        //you can also use sdk.stopSession as Void if you do not care about the session timestamp
        if let session = sdk.stopSession() as String?{
            addLine(newLine: "Stop successful, timestamp of session: \(session)")
            compilerNewLine()
        }
        else {
            addLine(newLine: "Session stopped, no timestamp returned")
            compilerNewLine()
        }
    }
    
    //cancellable to hold data
    var subscription = Set<AnyCancellable>()
    //variable passthrough subject that will be set with the .getDeviceListener function
    var listener = PassthroughSubject<[String], Never>()
    
    func sdkGetDeviceListener(){
        //get a connected device
        if let connectedDevice = sdk.getConnectedDevices().first{
            
            //get the passthrough subject for that device and measurement
            //if you wanted to listen to a different measurement just change the measurement parameter
            //setting my variable passthrough subject to be the set as the returned subject
            //listen to the data and use the cancellable to store
            if let subject = sdk.getDeviceListener(device: connectedDevice, measurement: .NEXTILES_FORCE){
                listener = subject
                subscribeToListener()
            }
        }
        else {
            addLine(newLine: "No connected devices")
        }
    }
    
    //listen to the data
    //determines what to do with the data once recieved
    func subscribeToListener (){
        listener.sink { val in
            self.addLine(newLine: "Force: [\(val)]")
        }
        .store(in: &subscription)
    }
    
    
    //call when a user wants to start a session and collect data
    //there must be a user set through login, registration, or editUser
    func sdkStartSession(){
        addLine(newLine: "Starting a session...")
        sdk.startSession()
    }
    
    
    //connect to a nextiles device
    func sdkConnect (){
        addLine(newLine: "Attempting to connect to a NextilesDevice")
        
        //getting a random discovered device
        if let connectDevice = sdk.getDiscoveredDevices().first {
            
            //sdk connect has four ways to connect, using a device object, device name, device uuid or device uuid as a string
            //using a device object in this case
            
            //you must provide device settings
            //device settings is asking what type of device
            //also asking where the device is being placed
            //all options can be accessed using dot notation
            let connectSettings = DeviceSettings(placement: .right_arm, device_type: .sleeve)
            
            //calling connect
            sdk.connectDevice(device: connectDevice, settings: connectSettings)
        }
    }
    
    
    //you can manually check for discovered devices by call the getDiscoveredDevice function
    //you can also be notified by the delegate method
    func sdkGetDiscoveredDevices(){
        
        addLine(newLine: "Getting all discovered devives.")
        
        //nextiles devices have been found
        if sdk.getDiscoveredDevices().count > 0{
            
            addLine(newLine: "\(sdk.getDiscoveredDevices().count) devices found")
            
            for discoveredDevice in sdk.getDiscoveredDevices(){
                addLine(newLine: discoveredDevice.name)
            }
            compilerNewLine()
        }
        //no nextiles devices discoveted
        else{
            addLine(newLine: "No Nextiles devices found")
            addLine(newLine: "Run startScan before attempting to get discovered devices")
            compilerNewLine()
        }
    }
    
    
    //Need to ask for bluetooth permission in the applicaitons plist
    func sdkStartScan(){
        addLine(newLine: "Starting bluetooth scanning...")
        
        //this is a good time to set you class as the bluetooth delegate
        //in this way you can recieve updates on bluetooth functionality
        NextilesDelegates.bleDelegate = self
        
        //starting to scan for bluetooth devices
        //I will be notified of discovered devices by the triggered bleDelegate method
        sdk.startScan()
    }
    
    //MARK: Nextiles BLE Delegates Methods
    //triggered everytime a device is connected
    func deviceGotConnected(device: Device) {
        addLine(newLine: "\(device.name) recently connected")
        addLine(newLine: "notification triggered by bleDelegate")
        compilerNewLine()
    }
    
    //triggered everytime a new device is found
    func discoveredDevices(devices: [Device]) {
        addLine(newLine: "\(devices.count) nextile devices have been discovered")
        addLine(newLine: "notification triggered by bleDelegate")
        compilerNewLine()
    }
    
    //tirggered everytime a device gets disconnected
    func deviceGotDisconnected(device: Device) {
        addLine(newLine: "\(device.name) recently disconnected")
        addLine(newLine: "notification triggered by bleDelegate")
        compilerNewLine()
    }
    
    //triggered everytime the firmware of a device is found
    func firmwareDiscovered(device: Device) {
        addLine(newLine: "\(device.name) firmware recently discovered")
        addLine(newLine: "notification triggered by bleDelegate")
        compilerNewLine()
    }
    
    
    
    
    //logout the current user
    //unsets the current user in local storage
    func sdkLogout(){
        addLine(newLine: "Starting logout")
        
        if sdk.logoutUser(){
            addLine(newLine: "Logout successful")
            compilerNewLine()
        }
        else {
            addLine(newLine: "Logout unsuccessful")
            compilerNewLine()
        }
        
    }
    
    //get the current user from local storage
    //the current user is set after register, login, and edit user functions
    //returns a optional becuase a user might not be set
    func sdkGetUser(){
        
        addLine(newLine: "Getting current user...")
        
        if let currentUser = sdk.getUser(){
            addLine(newLine: "Found current user, \(currentUser.username)")
            compilerNewLine()
        }
        else {
            addLine(newLine: "No user found in local storage")
            addLine(newLine: "To set a user either login, register, or edit a user")
            compilerNewLine()
        }
    }
    
    
    func sdkRegister(){
        
        compilerText += "Starting registration...\n"
        
        //To register you need a user object
        let registerUser = User(username: "DemoUser", organization: "Nextiles")
        
        //adding metadata to the user object
        //not needed but helpful for analysis
        registerUser.setAge(age: 21)
        registerUser.setDob(dob: "01/01/2000")
        registerUser.setHand(hand: "right")
        registerUser.setFoot(foot: "left")
        registerUser.setName(name: "My name")
        registerUser.setHeight(height: 60)
        registerUser.setWeight(weight: 100)
        registerUser.setGender(gender: "male")
        registerUser.setCountry(country: "united-states")
        registerUser.setSportAndSkillLevel(sport: "basketball", skillLevel: "expert")
        registerUser.setSportAndSkillLevel(sport: "tennis", skillLevel: "intermediate")
        registerUser.setSportAndSkillLevel(sport: "soccer", skillLevel: "amateur")
        
        //if you would like you can use the setAll function to set all parameters
        //registerUser.setAll("My name", 21, 100, 60, "01/01/2000", "male", "united-states", "right", "left", "basketball", "expert")
        
        //registering a new user
        //provides a bool call back to let you know if registration was successful
        sdk.registerUser(user: registerUser) { success in
            
            DispatchQueue.main.async {
                if success {
                    self.addLine(newLine: "Registration successful")
                    self.compilerNewLine()
                }
                else {
                    self.addLine(newLine: "Registration unsuccessful")
                    self.addLine(newLine: "If user is registerd already, use sdk.login()")
                    self.compilerNewLine()
                }
            }
        }
    }
    
    //login a user that is already registered
    func sdkLogin(){
        
        addLine(newLine: "Starting login...")
        
        //takes a user object, this can just be the initialized User object
        //returns a bool if login was succesful or not
        sdk.loginUser(user: getDemoUser()) { success in
            
            DispatchQueue.main.async {
            
                if success {
                    self.addLine(newLine: "Login Successful")
                    self.compilerNewLine()
                }
                else {
                    self.addLine(newLine: "Login Unsuccessful")
                    self.addLine(newLine: "Check if the user is registered")
                }
            }
        }
    }
    
    //edit a user's metadata
    //the username and organization of a user cannot be editied
    func sdkEditUser(){
        
        addLine(newLine: "Starting edit user...")
        
        let demoUser = getDemoUser()
        demoUser.setHeight(height: 58)
        sdk.editUser(user: demoUser) { success in
            
            DispatchQueue.main.async {
                if success {
                    self.addLine(newLine: "Edit successful")
                    self.compilerNewLine()
                }
                else {
                    self.addLine(newLine: "Edit unsuccessful")
                    self.addLine(newLine: "check to see if the user is registered")
                    self.compilerNewLine()
                }
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK: UI Functionality ignore
    @Published var demos = [
        demoCases(id: 0, buttonDescription: "Register a new user"),
        demoCases(id: 1, buttonDescription: "Login Current User"),
        demoCases(id: 2, buttonDescription: "Edit Current User"),
        demoCases(id: 3, buttonDescription: "Get Current User"),
        demoCases(id: 4, buttonDescription: "Logout current user"),
        demoCases(id: 5, buttonDescription: "Start Scan"),
        demoCases(id: 6, buttonDescription: "Get Discovered Devices"),
        demoCases(id: 7, buttonDescription: "Connect Device"),
        demoCases(id: 8, buttonDescription: "Start Session"),
        demoCases(id: 9, buttonDescription: "Listen to datastream"),
        demoCases(id: 10, buttonDescription: "Stop Session"),
        demoCases(id: 11, buttonDescription: "Get session")
    ]
    
    @Published var statusText = "Choose an option below"
    @Published var compilerText = ""
    @Published var errorMessage = ""
    var line = "----------"
    
    
    //MARK: User intent
    //choosing a demo case
    func demoCaseChosen(chosenCase : demoCases){
        for (index, value) in demos.enumerated(){
            if value.id == chosenCase.id{
                demos[index].chosen.toggle()
                statusText = demos[index].buttonDescription
                
                switch chosenCase.id{
                case 0:
                    sdkRegister()
                case 1:
                    sdkLogin()
                case 2:
                    sdkEditUser()
                case 3:
                    sdkGetUser()
                case 4:
                    sdkLogout()
                case 5:
                    sdkStartScan()
                case 6:
                    sdkGetDiscoveredDevices()
                case 7:
                    sdkConnect()
                case 8:
                    sdkStartSession()
                case 9:
                    sdkGetDeviceListener()
                case 10:
                    sdkStopSession()
                case 11:
                    sdkGetSession()
                    
                default:
                    errorMessage = "ID case not handled yet"
                } 
            }
            else {
                demos[index].chosen = false
            }
        }
    }
    
    
    //MARK: Helper functions
    func addLine(newLine: String){
        compilerText += "\(newLine)\n"
    }
    
    func compilerNewLine(){
        compilerText += "\(line)\n"
    }
    
    func getDemoUser()-> User{
        //To register you need a user object
        let demoUser = User(username: "DemoUser", organization: "Nextiles")
        return demoUser
        //adding metadata to the user object
        //not needed but helpful for analysis
//        demoUser.setAge(age: 21)
//        demoUser.setDob(dob: "01/01/2000")
//        demoUser.setHand(hand: "right")
//        demoUser.setFoot(foot: "left")
//        demoUser.setName(name: "My name")
//        demoUser.setHeight(height: 60)
//        demoUser.setWeight(weight: 100)
//        demoUser.setGender(gender: "male")
//        demoUser.setCountry(country: "united-states")
//        demoUser.setSportAndSkillLevel(sport: "basketball", skillLevel: "expert")
//        demoUser.setSportAndSkillLevel(sport: "tennis", skillLevel: "intermediate")
//        demoUser.setSportAndSkillLevel(sport: "soccer", skillLevel: "amateur")
    }
    
    
    
    //Struct to define a demo case
    struct demoCases: Identifiable{
        let id: Int
        let buttonDescription: String
        var chosen = false
    }
}
