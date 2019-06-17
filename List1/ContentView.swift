//
//  ContentView.swift
//  List1
//
//  Created by Jorge Garcia on 6/17/19.
//  Copyright © 2019 Jorge Garcia. All rights reserved.
//

import Combine
import SwiftUI

class DataSource: BindableObject{
    let didChange = PassthroughSubject<Void, Never>()
    var pictures = [String]()
    
    init() {
        let fm = FileManager.default
        
        if let path = Bundle.main.resourcePath,
            let items = try? fm.contentsOfDirectory(atPath: path){
            for item in items {
                if item.hasPrefix("nssl") {
                    pictures.append(item)
                }
            }
        }
        didChange.send(())
    }
}
struct DetailView : View {
//    state is for swiftUI only available inside the view
    @State private var hidesNavigationBar = false
    var selectedImage: String
    
    var body: some View {
        let img = UIImage(named: selectedImage)!
        return Image(uiImage: img)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .navigationBarTitle(Text(selectedImage),displayMode: .inline)
            .navigationBarHidden(hidesNavigationBar)
        .tapAction {
            self.hidesNavigationBar.toggle()
        }
    }
    
}

struct ContentView : View {
    @ObjectBinding var dataSource = DataSource()
    
    var body: some View {
        NavigationView{
        List(dataSource.pictures.identified(by: \.self))
            { picture in
                NavigationButton(destination:
                DetailView(selectedImage: picture),
                                 isDetail: true){
        Text(picture)
            }
            }.navigationBarTitle(Text("Types of Storms"))
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
