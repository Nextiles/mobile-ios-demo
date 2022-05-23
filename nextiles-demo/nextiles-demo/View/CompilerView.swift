//
//  CompilerView.swift
//  nextiles-demo
//
//  Created by Work on 5/17/22.
//

import SwiftUI

struct CompilerView: View {
    
    @State var compilerStatus = "Compiler"
    @Binding var compilerText: String
    
    var body: some View {
        ZStack (alignment: .leading) {
            
            //Background color
            RoundedRectangle(cornerRadius: 25)
                .fill(Styling.compilerBackgroundColor)
            
            
            //Content
            VStack (alignment: .leading){
                Text(compilerStatus)
                    .foregroundColor(.white)
                    .bold()
                    .padding(.top)
                    .padding(.leading)
                
                //console box
                ZStack (alignment: .leading){
                    //background color
                    Rectangle()
                        .fill(Styling.compilerBackgroundColor)
                    //content
                    ScrollView(.vertical){
                        Text(compilerText)
                            .foregroundColor(.white)
                            .font(Styling.Fonts.body02)
                    }
                    .padding(.leading)
                }
                Spacer()
            }
        }
        .frame(height: UIScreen.main.bounds.height / 4)
    }
}

struct CompilerView_Previews: PreviewProvider {
    
    @State static var text = "-----"
    
    static var previews: some View {
        CompilerView(compilerText: $text)
    }
}
