//
//  DemoViewModel.swift
//  nextiles-demo
//
//  Created by Work on 5/17/22.
//

import Foundation
import NextilesSDK
import SwiftUI

class DemoViewModel: ObservableObject {
    
    
    func demoCaseChosen(chosenCase : demoCases){
        
        for (index, value) in demos.enumerated(){
            
            if value.id == chosenCase.id{
                demos[index].chosen.toggle()
                statusText = demos[index].buttonDescription
            }
            else {
                demos[index].chosen = false
            }
            
        }
        
        
    }
    
    
    
    @Published var demos = [
        demoCases(id: 0, buttonDescription: "Register a new user"),
        demoCases(id: 1, buttonDescription: "Login Current User"),
        demoCases(id: 2, buttonDescription: "Edit Current User"),
        demoCases(id: 3, buttonDescription: "Get Current User"),
        demoCases(id: 4, buttonDescription: "Start Scan"),
        demoCases(id: 5, buttonDescription: "Get Discovered Devices"),
        demoCases(id: 6, buttonDescription: "Connect Device"),
        demoCases(id: 7, buttonDescription: "Start Session"),
        demoCases(id: 8, buttonDescription: "Stop Session"),
        demoCases(id: 9, buttonDescription: "Get Session")
    ]
    
    @Published var statusText = "Choose an option below"
    
    
    struct demoCases: Identifiable{
        let id: Int
        let buttonDescription: String
        var chosen = false
    }
}
