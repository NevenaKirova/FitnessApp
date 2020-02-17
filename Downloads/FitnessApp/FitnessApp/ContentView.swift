//
//  ContentView.swift
//  NevenaKirova71827
//
//  Created by Nevena Kirova on 29.11.19.
//  Copyright © 2019 Nevena Kirova. All rights reserved.
//

import SwiftUI
import Firebase

struct ContentView: View {
    
    @ObservedObject var data = getData()
    
    var body: some View {
       
        NavigationView{
            
            ZStack(alignment: .top){
                
                GeometryReader{_ in
                    
                    // Home View....
                    Text("Home")
                    
                }.background(Color("Color").edgesIgnoringSafeArea(.all))
                
                CustomSearchBar(data: self.$data.datas).padding(.top)
                
            }.navigationBarTitle("")
            .navigationBarHidden(true)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct CustomSearchBar : View {
    
    @State var txt = ""
    @Binding var data : [dataType]
    
    var body : some View{
        
        VStack(spacing: 0){
            
            HStack{
                
                TextField("Search", text: self.$txt)
                
                if self.txt != ""{
                    
                    Button(action: {
                        
                        self.txt = ""
                        
                    }) {
                        
                        Text("Cancel")
                    }
                    .foregroundColor(.black)
                    
                }

            }.padding()
            
            if self.txt != ""{
                
                if  self.data.filter({$0.name.lowercased().contains(self.txt.lowercased())}).count == 0{
                    
                    Text("No Results Found").foregroundColor(Color.black.opacity(0.5)).padding()
                }
                else{
                    
                List(self.data.filter{$0.name.lowercased().contains(self.txt.lowercased())}){i in
                            
                    NavigationLink(destination: Detail(data: i)) {
                        
                        Text(i.name)
                    }
                            
                        
                    }.frame(height: UIScreen.main.bounds.height / 5)
                }

            }
            
            
        }
    }
}

class getData : ObservableObject{
    
    @Published var datas = [dataType]()
    
    init() {
        
        let db = Firestore.firestore()
        
        db.collection("users").getDocuments { (snap, err) in
            
            if err != nil{
                
                print((err?.localizedDescription)!)
                return
            }
            
            for i in snap!.documents{
                
                let id = i.documentID
                let age = i.get("age") as! Int
                let profession = i.get("profession") as! String
                let username = i.get("username") as! String
                
                self.datas.append(dataType(id: id, age: age, profession: profession, username: username))
            }
        }
    }
}

struct dataType : Identifiable {
    
    var id : String
    var age : Int
    var profession : String
    var username : String
}

struct Detail : View {
    
    var data : dataType
    
    var body : some View{
        
        Text(data.username)
    }
}

