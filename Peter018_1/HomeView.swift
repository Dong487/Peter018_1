//
//  HomeView.swift
//  Peter018_1
//
//  Created by DONG SHENG on 2022/7/31.
//

// 待增加 Text的範圍限制

import SwiftUI

class HomveViewModel: ObservableObject{
    
//    @Published var imageString: String = "Image1"
    @Published var imageArray: [String] = ["Image1", "Image2" , "Image3" , "Image4"]
    @Published var showImage: [Bool] = [false ,true, false,false,false] // 若 將 Image存一個Array count: 可以 imageArray.count + 1 ([0空著]) -> 圖片張數 = count - 1
    @Published var changeAction: String = "next"
    
    @Published var textContent: String = "在這裡輸入文字"
    @Published var fontSize: CGFloat = 50
    @Published var fontColor: Color = Color(red: 1 ,green: 1 ,blue: 0.5)

    
    // 兼初始化
    func reset(){
        
        self.showImage = [Bool](repeating: false, count: self.imageArray.count + 1)
        self.showImage[1] = true
        
    }
    
    // 點擊 相片     "上一張" <-> "下一張"
    func changeImage(change: String){
        if change == "next"{
            self.changeAction = "next"
            // 判斷是哪一項 Bool 為 true
            // (在第幾項 , value)
            for (index ,bool) in showImage.enumerated(){
                if bool == true{
                    
                    // 判斷是不是到最後一項
                    guard showImage.count != index + 1 else { return }
                    print(index)
                    self.showImage[index + 1].toggle()
                    self.showImage[index].toggle()
                    
                    
                }
            }
        } else if change == "previous"{
            self.changeAction = "previous"
            for (index ,bool) in showImage.enumerated(){
                if bool == true{
                    
                    // 判斷是不是到最後一項
                    guard index != 1 else { return }
                    
                    print(index)
                    self.showImage[index - 1].toggle()
                    self.showImage[index].toggle()

                }
            }
        }
    }
}

struct HomeView: View {
    
    @StateObject private var viewModel = HomveViewModel()
    @State var location: CGPoint = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 3.5)
    
//    @State var rect: CGRect = CGRect(x: 0, y: 0, width: 10, height: 10)

    var body: some View {
        GeometryReader { geo in
            ZStack{
                Image("Background1")
                
                
                    VStack(spacing: 30){
                        
                        Text("X : \(location.x)")
                        Text("Y : \(location.y)")
    //
//                        let globalFrame = geo.frame(in: CoordinateSpace.global)
                        
//                        let g = geo.frame(in: .named("image"))
    //                    let locationFrame = geo.frame(in: CoordinateSpace.local)
//                        Text("Global Center: \(globalFrame.width)")
//                        Text("\(g)")
    //                    Text("Local Center : \(locationFrame.width)")

    
                        
                        MainView(
                            image: viewModel.imageArray,
                            textContent: viewModel.textContent,
                            fontSize: viewModel.fontSize,
                        fontColor: viewModel.fontColor)
                        .coordinateSpace(name: "image")
                        
                        EditView
                    
                }
                    
            }
            .frame(width: UIScreen.main.bounds.width ,height: UIScreen.main.bounds.height)
            
            .onAppear {
                viewModel.reset()
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

extension HomeView{
    
    @ViewBuilder
    private func MainView(image: [String] ,textContent: String ,fontSize: CGFloat ,fontColor: Color) -> some View{
        ZStack{
            Color.white
            
            ZStack {
                ForEach(image.indices ,id: \.self){ index in
                    
                    if viewModel.showImage[index + 1] == true {
                        Text("\(index)")
//
                        if viewModel.changeAction == "next"{
                            Image(image[index])
                                .resizable()
                                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: index == 1 ? .leading : .leading)))
                                .padding(.horizontal)
                                .padding(.vertical ,16)
                                .padding(.bottom)
                        } else if viewModel.changeAction == "previous"{
                            Image(image[index])
                                .resizable()
                                .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: index == 4 ? .trailing : .trailing)))
                                .padding(.horizontal)
                                .padding(.vertical ,16)
                                .padding(.bottom)
                        }
                        
                    }
                }
            }
                
            Text(textContent)
                .font(.system(size: fontSize))
                .foregroundColor(fontColor)
                .shadow(color: .black, radius: 1, x: 1, y: 1)
                .shadow(color: .white, radius: 1.3, x: 1.2, y: 1.2)
                .shadow(color: .white, radius: 1.5, x: 1.2, y: 0)
                .position(location)
//                .background(
//                    GeometryReader { i -> Color in
//                        let g = i.frame(in: CoordinateSpace.global)
//                        let s = i.frame(in: .named("image"))
//                        print(g)
//                        print(s)
//
//                        return Color.purple
//                    }
//                )
                .gesture(
                    DragGesture()
                        .onChanged{ value  in
                            if value.location.x >= UIScreen.main.bounds.width / 2 - 75 {
                       
                                withAnimation(.easeInOut){
                                    self.location = value.location
                                    
                                }
                            } else {
                                
                            }
                        }
                )
           
            

        }
        .frame(width: UIScreen.main.bounds.width - 100, height: UIScreen.main.bounds.width - 100)
    }
    
    private var EditView : some View{
        VStack(spacing: 12){
            HStack{
                TextField("\(viewModel.textContent)", text: $viewModel.textContent)
                    .padding()
                    .background(.gray.opacity(0.3))
                    .frame(width: UIScreen.main.bounds.width / 2)
                    .overlay {
                        HStack{
                            Spacer()
                            Image(systemName: "rectangle.and.pencil.and.ellipsis")
                                .foregroundColor(.white)
                        }
                        .padding()
                    }
                ColorPicker("", selection: $viewModel.fontColor,supportsOpacity: true)
                    .padding()
                    .cornerRadius(15)
                    .frame(width: 35)
            }
            
            // 圖片選擇
            HStack{
//                Spacer()
                
                Text("圖片 :")
                    .font(.headline)
                
//                Spacer()
                
                Button {
                    withAnimation(.easeInOut){
                        viewModel.changeImage(change: "previous")
                    }
                } label: {
                    Image(systemName: "chevron.backward.square.fill")
                        
                }
                
//                Text("\(viewModel.imageArray[])")
                
                Spacer()
                
                Button {
                    withAnimation(.easeInOut){
                        viewModel.changeImage(change: "next")
                    }
                } label: {
                    Image(systemName: "chevron.forward.square.fill")
                        
                }
            }
            .font(.largeTitle)
            .tint(.brown)
            .frame(width: UIScreen.main.bounds.width - 150)
            
            // 更改字體大小
            HStack{
                Text("字體大小 :")
                    .font(.headline)
                Button {
                    withAnimation(.easeInOut){
                        guard viewModel.fontSize >= 9 else { return }
                        viewModel.fontSize -= 1
                    }
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .shadow(color: .white.opacity(0.7), radius: 1, x: 0.7, y: 0.7)
                        .shadow(color: .white.opacity(0.35), radius: 2, x: 1.2, y: 1.2)
                        
                }
//                Text("圖片\(viewModel.showImage)")
                
                Spacer()
                
                Button {
                    withAnimation(.easeInOut){
                        viewModel.fontSize += 1
                    }
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .shadow(color: .white.opacity(0.7), radius: 1, x: 0.7, y: 0.7)
                        .shadow(color: .white.opacity(0.35), radius: 2, x: 1.2, y: 1.2)
                        
                }
            }
            .font(.largeTitle)
            .tint(.brown)
            .frame(width: UIScreen.main.bounds.width - 150)
            
            Button {
                 let image = MainView(
                    image: viewModel.imageArray,
                    textContent: viewModel.textContent,
                    fontSize: viewModel.fontSize,
                    fontColor: viewModel.fontColor).snapshot()
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    
            } label: {
                Text("保存至相簿")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .background(.brown)
                    .cornerRadius(15)
                    .shadow(color: .black.opacity(0.7), radius: 1, x: 0.7, y: 0.7)
                    .shadow(color: .black.opacity(0.35), radius: 2, x: 1.2, y: 1.2)
                
                    
            }

        }
    }
}


extension View{
    // 截圖用
    func snapshot() -> UIImage{
        // 在iOS 15 有點小Bug 所以要加上 .ignoresSafeArea()
        let controller = UIHostingController(rootView: self.ignoresSafeArea())
        let view = controller.view
        
        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .green // 背景色
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        
        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}
