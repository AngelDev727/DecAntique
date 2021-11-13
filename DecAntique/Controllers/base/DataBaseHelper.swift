//
//  DataBaseHelper.swift
//  DecAntique
//
//  Created by Dalal AlSaidi on 03/04/1443 AH.
//

import UIKit
import CoreData

class DataBaseHelper {
    
    static let shared = DataBaseHelper()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: - user table
    func saveUser(email: String, name: String, password: String, type: String) -> String {
        
        if getOneUser(id: nil, email: email) != nil {
            return "User email aleady exist"
        }
        
        do {
            let userInstance = Users(context: context)
            userInstance.email      = email
            userInstance.user_name  = name
            userInstance.password   = password
            userInstance.id         = Int32(Date().timeIntervalSince1970)
            userInstance.user_type  = type
            
            try context.save()
            print("User was saved")
            
            return "success \(userInstance.id)"
        } catch {
            print(error.localizedDescription)
            return error.localizedDescription
        }
    }
    
    func getOneUser(id: Int32?, email: String?) -> UserModel? {
        
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
            let fetchingData = try context.fetch(fetchRequest) as! [Users]
            for one in fetchingData {
                
                let dbId        = one.id
                let dbUsername  = one.user_name
                let dbEmail     = one.email
                let pdbPWD      = one.password
                let type        = one.user_type!
                
                if id != nil && id == dbId {
                    return UserModel(id: dbId, username: dbUsername, email: dbEmail, type: type, password: pdbPWD, token: nil)
                }
                
                if email != nil && email == dbEmail {
                    return UserModel(id: dbId, username: dbUsername, email: dbEmail, type: type, password: pdbPWD, token: nil)
                }
            }
            
            return nil
        } catch {
            print("Error while fetching the users")
            return nil
        }
        
    }
    
    func getAllUsers() -> [UserModel]? {
        var result = [UserModel]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        
        do {
            let fetchingData = try context.fetch(fetchRequest) as! [Users]
            for one in fetchingData {
                
                let id          = one.id
                let username    = one.user_name
                let email       = one.email
                let password    = one.password
                let type        = one.user_type!
                
                result.append(UserModel(id: id, username: username, email: email, type: type, password: password, token: nil))
            }
        } catch {
            print("Error while fetching the image")
            return nil
        }
        
        return result
    }
    
    func updatePassword(id: Int32, password: String) -> String? {
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
            fetchRequest.predicate = NSPredicate(format: "id = %d", id)
            
            let fetchingData = try context.fetch(fetchRequest) as! [Users]
            let objUpdate = fetchingData[0] as NSManagedObject
            objUpdate.setValue(password, forKey: "password")
            
            do {
                try context.save()
                return "success"
            } catch {
                return nil
            }
        } catch {
            print("Error while fetching the users")
            return nil
        }
    }
    
    func updateProfile(id: Int32, name: String, email: String) -> String {
        guard let users = getAllUsers() else {
            return "Something went wrong"
        }
        for one in users {
            if one.id != id && one.email == email {
                return "User email aleady exist"
            }
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        fetchRequest.predicate = NSPredicate(format: "id = %d", id)
        
        do {
            let fetchingData = try context.fetch(fetchRequest) as! [Users]
            let objUpdate = fetchingData[0] as NSManagedObject
            objUpdate.setValue(name, forKey: "user_name")
            objUpdate.setValue(email, forKey: "email")
            
            do {
                try context.save()
                return "success"
            } catch {
                return "Something went wrong"
            }
        } catch {
            return "Something went wrong"
        }
    }
    
    func deleteUser(user_id: Int32) -> String {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        fetchRequest.predicate = NSPredicate(format: "id = %d", user_id)
        
        do {
            let fetchedItems = try context.fetch(fetchRequest)
            for item in fetchedItems{
                context.delete(item as! NSManagedObject)
            }
            try context.save()
            
            return "success"
        } catch {
            print(error.localizedDescription)
            return error.localizedDescription
        }
    }
    
    // MARK: - product table
    func saveProduct(data: ProductModel) -> String {
        let productInstance = Product(context: context)
        productInstance.id      = Int32(Date().timeIntervalSince1970)
        productInstance.photo   = data.photo
        productInstance.product_name = data.product_name
        productInstance.des     = data.description
        productInstance.price   = data.price
        productInstance.created_at = Date()
            
        do {
            try context.save()
            return "success"
        } catch {
            return error.localizedDescription
        }
    }
    
    func getAllProducts(user_id: Int32?) -> [ProductModel]? {
        var result = [ProductModel]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
        
        do {
            let dbData = try context.fetch(fetchRequest) as! [Product]
            
            for one in dbData {
                let p_id    = one.id
                let p_photo = one.photo
                let p_price = one.price
                let p_name  = one.product_name
                let p_des   = one.des
                var added_cart = false
                if let uId = user_id {
                    added_cart = getCartDataByProduct(user_id: uId, product_id: p_id) != nil
                }
                
                result.append(ProductModel(id: p_id, product_name: p_name!, price: p_price, description: p_des!, flag: added_cart, photo: p_photo))
            }
        } catch {
            return nil
        }
        
        return result
    }
    
    func getCartDataByProduct(user_id: Int32, product_id: Int32) -> Carts? {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Carts")
        let converstationKeyPredicate = NSPredicate(format: "user_id = %d", user_id)
        let messageKeyPredicate = NSPredicate(format: "product_id = %d", product_id)
        let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [converstationKeyPredicate, messageKeyPredicate])
        fetchRequest.predicate = andPredicate
        do {
            let fetchingData = try context.fetch(fetchRequest) as! [Carts]
            
            return fetchingData.count > 0 ? fetchingData[0] : nil
        } catch {
            return nil
        }
    }
    
    func getCartListByUser(user_id: Int32) -> [ProductModel]? {
        var result = [ProductModel]()
        
        var fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Carts")
        fetchRequest.predicate = NSPredicate(format: "user_id = %d", user_id)
        do {
            let fetchingData = try context.fetch(fetchRequest) as! [Carts]
            for one in fetchingData {
                let product_id = one.product_id
                
                fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
                fetchRequest.predicate = NSPredicate(format: "id = %d", product_id)
                
                let productsData = try context.fetch(fetchRequest) as! [Product]
                let p_id    = productsData[0].id
                let p_photo = productsData[0].photo
                let p_price = productsData[0].price
                let p_name  = productsData[0].product_name
                let p_des   = productsData[0].des
                
                result.append(ProductModel(id: p_id, product_name: p_name!, price: p_price, description: p_des!, flag: true, photo: p_photo))
            }
        } catch {
            return nil
        }
        
        return result
    }
    
    func removeProduct(product_id: Int32) -> String {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
        fetchRequest.predicate = NSPredicate(format: "id = %d", product_id)
        
        let cartRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Carts")
        
        do {
            let fetchedItems = try context.fetch(fetchRequest)
            for item in fetchedItems{
                context.delete(item as! NSManagedObject)
                
                cartRequest.predicate = NSPredicate(format: "product_id = %d", (item as! NSManagedObject).value(forKey: "id") as! Int32)
                let fetchedCartItems = try context.fetch(cartRequest)
                for one in fetchedCartItems {
                    context.delete(one as! NSManagedObject)
                }
            }
            try context.save()
            
            return "success"
        } catch {
            print(error.localizedDescription)
            return error.localizedDescription
        }
    }
    
    // MARK: - carts table
    func addCart(product_id: Int32, user_id: Int32) -> String {
        let cartInstance = Carts(context: context)
        cartInstance.id         = Int32(Date().timeIntervalSince1970)
        cartInstance.product_id = product_id
        cartInstance.user_id    = user_id
        
        do {
            try context.save()
            print("cart was saved")
            
            return "success \(cartInstance.id)"
        } catch {
            print(error.localizedDescription)
            return error.localizedDescription
        }
    }
    
    func removeCart(product_id: Int32, user_id: Int32) -> String {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Carts")
        let converstationKeyPredicate = NSPredicate(format: "user_id = %d", user_id)
        let messageKeyPredicate = NSPredicate(format: "product_id = %d", product_id)
        let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [converstationKeyPredicate, messageKeyPredicate])
        fetchRequest.predicate = andPredicate
        
        do {
            let fetchedItems = try context.fetch(fetchRequest)
            for item in fetchedItems{
                context.delete(item as! NSManagedObject)
            }
            try context.save()
            
            return "success"
        } catch {
            print(error.localizedDescription)
            return error.localizedDescription
        }
    }
    
}
