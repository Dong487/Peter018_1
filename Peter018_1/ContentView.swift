//
//  ContentView.swift
//  Peter018_1
//
//  Created by DONG SHENG on 2022/7/30.
//

// 使用 .offset 搭配 DragGesture() 有時候在抓取當下 會有不協調的畫面
// 所以改用 .position 

import SwiftUI



struct ContentView: View {
    
//    @State var offset: CGSize = .zero
    @State var location: CGPoint = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
    
    
    var body: some View {
        
        ZStack {
            
//            Color.yellow.ignoresSafeArea()
            
            Rectangle()
                .frame(width: 100,height: 100)
                .position(location)
                .gesture(
                    DragGesture()
                        .onChanged{ value  in
//                            if value.location.x <= 50 {
////                                self.location.x = 50
//                            }
                            withAnimation(.easeInOut){
                                self.location = value.location
                            }
                        }
                )
            
            
        }
//        .frame(width: 500, height: 300)
//        .background(.yellow)
//        .frame(width: UIScreen.main.bounds.width, height:  UIScreen.main.bounds.width / 2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
