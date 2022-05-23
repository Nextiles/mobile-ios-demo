//
//  DemoView.swift
//  nextiles-demo
//
//  Created by Work on 5/17/22.
//

import SwiftUI
import NextilesSDK

struct DemoView: View {
    
    @StateObject var viewModel = DemoViewModel()
    
    var body: some View {
        
        ZStack {
            //Background color
            LinearGradient(
                colors: [
                    Color(red: 0.358, green: 0.358, blue: 0.358),
                    Color(red: 0.117, green: 0.11, blue: 0.11)
                        ],
                startPoint: .top,
                endPoint: .bottom)
            
            
            VStack {
                
                Spacer()
                
                //Logo image
                Styling.getLogo()
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 22)
                    .padding(.top, 40)
                
                //current status
                Text(viewModel.statusText)
                    .font(Styling.Fonts.headline01)
                    .foregroundColor(.white)
                
                //Demo cases to choose from
                ScrollView(.vertical){
                    
                    VStack (spacing: 30) {
                        
                        ForEach(viewModel.demos) { testCase in
                            DemoViewButtons(
                                tapped: testCase.chosen,
                                buttonName: testCase.buttonDescription)
                                .onTapGesture {
                                    viewModel.demoCaseChosen(
                                        chosenCase: testCase)
                                }
                        }
                    }
                    .padding(.vertical)
                }
                
                Spacer()
                CompilerView(
                    compilerText: $viewModel.compilerText)
            }
        }
        .ignoresSafeArea()
    }
}

struct DemoViewButtons: View {
    
    var tapped: Bool
    var buttonName: String
    
    var body: some View{
        
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .stroke(.yellow, lineWidth: 1)
                .padding(.horizontal, 30)
                .frame(height: 40)
            
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.yellow)
                .padding(.horizontal, 30)
                .frame(height: 40)
                .opacity(tapped ? 0.1 : 0)
            
            Text(buttonName)
                .foregroundColor(.white)
                .font(Styling.Fonts.headline03)
            
        }
    }
}



struct DemoView_Previews: PreviewProvider {
    static var previews: some View {
        DemoView()
    }
}
