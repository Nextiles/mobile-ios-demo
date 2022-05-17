//
//  CompilerView.swift
//  nextiles-demo
//
//  Created by Work on 5/17/22.
//

import SwiftUI

struct CompilerView: View {
    
    @State var compilerStatus = "Compiling"
    @State var compilerText = "---------------"
    @State var compilerError = "Error"
    
    var body: some View {
        ZStack (alignment: .leading) {
            
            //Background color
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.358, green: 0.358, blue: 0.358),
                            Color(red: 0.117, green: 0.11, blue: 0.11)
                                ],
                        startPoint: .top,
                        endPoint: .bottom)
                )
            
            
            //Content
            VStack (alignment: .leading){
                Text(compilerStatus)
                    .foregroundColor(.white)
                    .bold()
                    .padding(.top)
                    .padding(.leading)
                
                ScrollView(.vertical){
                    Text(compilerText)
                        .foregroundColor(.white)
                        .bold()
                    
                    Text(compilerError)
                        .foregroundColor(.red)
                        .bold()
                }
                
                Spacer()
            }
        }
        .frame(height: UIScreen.main.bounds.height / 4)
    }
}

struct CompilerView_Previews: PreviewProvider {
    static var previews: some View {
        CompilerView()
    }
}
