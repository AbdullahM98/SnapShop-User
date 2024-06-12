//
//  AddressCell.swift
//  SnapShopApp-User
//
//  Created by husayn on 06/06/2024.
//

import SwiftUI
struct AddressCell: View {
    var address : AddressProfileDetails
    var insideCard: Bool
    var onDeleteClick : () -> Void?
    var onUpdateClick : (AddressForUpdate) -> Void?
    @State private var showingBottomSheet = false
    @State private var settingsDetents = PresentationDetent.height(UIScreen.screenHeight*0.5 + 20)
    
    
    var body: some View {
        VStack(alignment:.leading,spacing: 20){
            if let customerAddress = address.address1 {
                if !customerAddress.isEmpty{
                    HStack{
                        Text("Address: ")
                            .foregroundColor(.gray)
                        Text("\(address.address1 ?? "")")
                        Spacer()
                        if insideCard == false && !(address.default ?? false) {
                            HStack{
                                Button {
                                    onDeleteClick()
                                } label: {
                                    Image(systemName:"minus.circle.fill").resizable().aspectRatio(contentMode: .fit)
                                        .frame(width: 24, height: 24) .foregroundColor(.black)
                                }.padding(.trailing,6)
                                
                                Button {
                                    print("Edit")
                                    showingBottomSheet.toggle()
                                    
                                } label: {
                                    Image(systemName: "pencil.circle.fill").resizable().aspectRatio(contentMode: .fit)
                                        .frame(width: 24, height: 24) .foregroundColor(.black)
                                }.sheet(isPresented: $showingBottomSheet) {
                                    EditAddress(onSaveClick: { updatedAddress in
                                        onUpdateClick(updatedAddress)
                                        showingBottomSheet.toggle()
                                    }, onCancelClick: {
                                        showingBottomSheet.toggle()
                                        
                                    },customerAddress: address)
                                    .presentationDetents([.height(UIScreen.screenHeight*0.5 + 20)], selection: $settingsDetents)
                                }
                                
                            }
                        } else {
                            Text("default")
                                .font(.system(size:16))
                                .foregroundColor(.white)
                                .padding(.horizontal,8)
                                .padding(.vertical,2)
                                .background(Color.black)
                                .cornerRadius(8)
                        }
                        
                    }.padding(.horizontal,16)
                }
            }
            if let city = address.city{
                if !city.isEmpty{
                    HStack{
                        Text("City: ")
                            .foregroundColor(.gray)
                        Text("\(address.city ?? "")")
                    }.padding(.horizontal,16)
                }
                
            }
            if let country = address.country {
                if !country.isEmpty{
                    HStack{
                        Text("Country: ")
                            .foregroundColor(.gray)
                        Text("\(address.country ?? "")")
                    }.padding(.horizontal,16)
                }
                
            }
            if let zip = address.zip {
                if !zip.isEmpty{
                    HStack{
                        Text("Zip Code: ")
                            .foregroundColor(.gray)
                        Text("\(zip)")
                    }.padding(.horizontal,16)
                }
                
            }
            if let phone = address.phone {
                if !phone.isEmpty{
                    HStack{
                        Text("Phone Number: ")
                            .foregroundColor(.gray)
                        Text("\(address.phone ?? "")")
                    }.padding(.horizontal,16)
                    
                }
                
            }
        }
        .padding(.vertical,20).overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(address.default ?? false ? Color.green : Color.black, lineWidth: 1).shadow(radius: 5)
        }.padding()
        
    }
}

struct AddressCell_Previews: PreviewProvider {
    static var previews: some View {
        AddressCell(address: AddressProfileDetails(id: 0, customer_id: 0, first_name: "husayn", last_name: "abdulaziz", company: "iti", address1: "elamar sory", address2: "elzohor", city: "portsaid", province: "", country: "Egypt", zip: "45475", phone: "+201285340330", name: "husayn", province_code: "4545", country_code: "+20", country_name: "Egypt", default: true), insideCard: false, onDeleteClick: {}, onUpdateClick: {_ in})
    }
}
