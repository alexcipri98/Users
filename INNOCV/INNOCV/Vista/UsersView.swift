//
//  UsersView.swift
//  INNOCV
//
//  Created by Alex on 10/10/22.
//

import SwiftUI

struct UsersView: View {
    @State var users:[User] = Array()
    let connection:ConexionRest = ConexionRest()
    
    var body: some View {
        if users == []{
            HStack{
                ProgressView().padding()
                Text("Cargando datos de los usuarios")
            }.padding().onAppear{
                
                connection.loadData(){result in
                    users = result
                }
                
            }
        }else{
            SubUsersView(users: $users, connection: connection)
        }
    }
}

struct SubUsersView:View{
    @Binding var users:[User]
    let connection:ConexionRest
    var body : some View{
        NavigationView{
            List{
                ForEach(users, id: \.self) { item in
                    
                    HStack{
                        
                        Text("Id: \(item.id)").padding()
                        
                        VStack(alignment: .leading, spacing: 1.0){
                            Text("Name: \(item.name)")
                            Text("Birthdate: \(getBirthDate(birth:item.birthdate))")
                        }
                        Spacer()
                        Image(systemName: "trash.fill")
                            .foregroundColor(Color.red)
                            .onTapGesture{
                                connection.delete(id: item.id)
                                users.removeAll(where: {$0.id == item.id})
                            }
                    
                    }
                }
            }.navigationTitle("Users").font(.system(size: 12, weight: .bold, design: .rounded))
        }
    }
    
    func getBirthDate(birth:Date) -> String{
        let auxDate = String(describing:birth)
        let positions = auxDate.components(separatedBy: " ")
        return positions[0]
    }
    
}
