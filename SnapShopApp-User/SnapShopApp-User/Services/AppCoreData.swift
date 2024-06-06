//
//  AppCoreData.swift
//  SnapShopApp-User
//
//  Created by Abdullah Essam on 05/06/2024.
//

import Foundation
import CoreData
class AppCoreData{
   static let shared = AppCoreData()
    var container:NSPersistentContainer
   private init() {
        self.container = NSPersistentContainer(name: "AppModel")
        container.loadPersistentStores(completionHandler: {
            (description,error) in
            if let error = error {
                print("Error loading CoreData\(error)")
            }
        })
    }
    
    var context: NSManagedObjectContext {
          return container.viewContext
      }
      
    
       func insertCustomer(customer: Customer) {
           // Ensure the entities are correctly set
           guard let customerEntity = NSEntityDescription.entity(forEntityName: "Customer_Entity", in: context),
                 let addressEntity = NSEntityDescription.entity(forEntityName: "Address_Entity", in: context) else {
               print("Failed to create entity descriptions.")
               return
           }

           let newCustomer = NSManagedObject(entity: customerEntity, insertInto: context)
           
           newCustomer.setValue(customer.first_name, forKey: "first_name")
           newCustomer.setValue(customer.last_name, forKey: "last_name")
           newCustomer.setValue(customer.email, forKey: "email")
           newCustomer.setValue(customer.phone, forKey: "phone")
          
           
           for address in customer.addresses! {
               let newAddress = NSManagedObject(entity: addressEntity, insertInto: context)
               
               newAddress.setValue(address.address1, forKey: "address_desc")
               newAddress.setValue(address.city, forKey: "city")
               newAddress.setValue(address.phone, forKey: "phone")
               newAddress.setValue(address.zip, forKey: "zip_code")
               newAddress.setValue(address.last_name, forKey: "last_name")
               newAddress.setValue(address.first_name, forKey: "first_name")
               newAddress.setValue(address.country, forKey: "country")
               
               // Set the relationship
               newAddress.setValue(newCustomer, forKey: "customer")
           }
           
           do {
               try context.save()
               print("Customer inserted successfully.")
           } catch {
               print("Failed inserting customer: \(error)")
           }
       }
    
    func fetchCustomers() -> [Customer] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Customer_Entity")
        
        do {
            let customerEntities = try context.fetch(fetchRequest)
            var customers: [Customer] = []
            
            for customerEntity in customerEntities {
                guard let firstName = customerEntity.value(forKey: "first_name") as? String,
                      let lastName = customerEntity.value(forKey: "last_name") as? String,
                      let email = customerEntity.value(forKey: "email") as? String,
                      let phone = customerEntity.value(forKey: "phone") as? String,
                      let addressesSet = customerEntity.value(forKey: "adresses") as? Set<NSManagedObject> else {
                    continue
                }
                
                var addresses: [Address] = []
                
                for addressEntity in addressesSet {
                    guard let address1 = addressEntity.value(forKey: "address_desc") as? String,
                          let city = addressEntity.value(forKey: "city") as? String,
                          let addressPhone = addressEntity.value(forKey: "phone") as? String,
                          let zip = addressEntity.value(forKey: "zip_code") as? String,
                          let addressLastName = addressEntity.value(forKey: "last_name") as? String,
                          let addressFirstName = addressEntity.value(forKey: "first_name") as? String,
                          let country = addressEntity.value(forKey: "country") as? String else {
                        continue
                    }
                    
                    let address = Address(phone: phone, country: country, zip: zip, address1: address1, first_name: firstName, last_name: lastName, city: city)
                    
                    addresses.append(address)
                }
                
                let customer = Customer(phone: phone, password: "", last_name: lastName, addresses: addresses, email: email, first_name: firstName)
                
                customers.append(customer)
            }
            
            return customers
        } catch {
            print("Failed fetching customers: \(error)")
            return []
        }
    }
   }


