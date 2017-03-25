//
//  DatabaseManager.swift
//  ContactBackup
//
//

import UIKit

class DatabaseManager: NSObject
{
    var db:OpaquePointer? = nil
    var statement: OpaquePointer? = nil
    internal let SQLITE_STATIC = unsafeBitCast(0, to: sqlite3_destructor_type.self)
    internal let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    
     func GetDatabasepath()->String
     {
        let documents = try!FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let filePath = documents.appendingPathComponent("ContactBackup.sqlite")
        print("File path \(filePath.path)")
        return filePath.path
     }
    func OpenDatabase()->Bool
    {
        var success : Bool = false
       if sqlite3_open(self.GetDatabasepath(),&db) == SQLITE_OK
        {
            success = true
            print("Databse Open")
        }
        else
       {
         success = false
         print("Databse not open")
        
       }
        return success
    }
    func CloseDatabse()-> Bool
    {
        var success : Bool = false
        
        if sqlite3_close(db) == SQLITE_OK
        {
            success = true
            print("Close Database")
        }
        else
        {
            success = false
            print("Error  in closing Databsae")
        }
        return success
    }
    func CreateDatabse()->Bool
    {
        var success : Bool = false
        if FileManager.default.fileExists(atPath: self.GetDatabasepath()) == false
        {
            if self.OpenDatabase()
            {
                let CreateTable = "create table if not exists ContactList(Contact_id integer primary key,FirstName text,Address text,City text,ZipCode text, MobilNum text,OtherMobNum text,WorkNum text,Email text,Remark text,Profile_id text,Identifier text,Image text,SYNC text)"
                if sqlite3_exec(db,CreateTable, nil, nil, nil) == SQLITE_OK
                {
                    success = true
                    print("Databse Create")
                }
                else
                {
                    success = false
                    let errorMsg = sqlite3_errmsg(db)
                    print("Create Table error \(errorMsg)")
                }
            }
            else
            {
                success = false
            }
        }
        else
        {
            success = true
            print("Databse Already  Create")
        }
        
        self .CloseDatabse()
        return success
    }
    
    func Insert(_ models:NSMutableArray)->Bool
    {
        var success : Bool = false
        var insert_statement: OpaquePointer? = nil
        
        
            
            for i in 0  ..< models.count 
            {
                let object = models[i] as! Person_Model
                
                if AvailbleProfile(object.profile_id)
                {
                    if self.OpenDatabase()
                    {
                        if sqlite3_prepare_v2(db, "insert into ContactList (FirstName,Address,City,ZipCode,MobilNum,OtherMobNum,WorkNum,Email,Remark,Profile_id,Identifier,Image,SYNC) values (?,?,?,?,?,?,?,?,?,?,?,?,?)", -1, &insert_statement, nil) == SQLITE_OK
                        {
                            sqlite3_bind_text(insert_statement, 1,object.FirstName , -1, SQLITE_TRANSIENT)
                            // sqlite3_bind_text(statement, 2,object.lastName , -1, SQLITE_TRANSIENT)
                            sqlite3_bind_text(insert_statement, 2,object.Address , -1, SQLITE_TRANSIENT)
                            sqlite3_bind_text(insert_statement, 3,object.City , -1, SQLITE_TRANSIENT)
                            sqlite3_bind_text(insert_statement, 4,object.ZipCode , -1, SQLITE_TRANSIENT)
                            sqlite3_bind_text(insert_statement, 5,object.MobNum , -1, SQLITE_TRANSIENT)
                            sqlite3_bind_text(insert_statement, 6,object.OtherMobNum , -1, SQLITE_TRANSIENT)
                            sqlite3_bind_text(insert_statement, 7,object.WorkNum , -1, SQLITE_TRANSIENT)
                            sqlite3_bind_text(insert_statement, 8,object.email , -1, SQLITE_TRANSIENT)
                            sqlite3_bind_text(insert_statement, 9,object.remarks , -1, SQLITE_TRANSIENT)
                            sqlite3_bind_text(insert_statement, 10,object.profile_id , -1, SQLITE_TRANSIENT)
                            sqlite3_bind_text(insert_statement, 11,object.identifier, -1, SQLITE_TRANSIENT)
                            sqlite3_bind_text(insert_statement, 12,object.image, -1, SQLITE_TRANSIENT)
                            sqlite3_bind_text(insert_statement, 13, object.SYNC, -1, SQLITE_TRANSIENT)
                            
                            if sqlite3_step(insert_statement) == SQLITE_DONE
                            {
                                success = true
                                print("Insert Data success")
                            }
                            else
                            {
                                let errmsg = String(cString: sqlite3_errmsg(db))
                                print("failure inserting : \(errmsg)")
                                success = false
                            }
                        }
                        else
                        {
                            let errmsg = String(cString: sqlite3_errmsg(db))
                            print("error preparing insert: \(errmsg)")
                            success = false
                        }
                        sqlite3_finalize(insert_statement)
                        self.CloseDatabse()
                        
                    }
                    else
                    {
                        success = false
                        print("Error in  opening Databse")
                    }

                }
                else
                {
                   success = UpdateContact_usingProfile(object)
                }
                
                
            }
    return success
}
    
    func Select(_ SelectQuery:String)->NSMutableArray
    {
        let model :NSMutableArray = []
         var select_statement: OpaquePointer? = nil
        if OpenDatabase()
        {
            if sqlite3_prepare_v2(db, SelectQuery, -1, &select_statement, nil) == SQLITE_OK
            {
                while sqlite3_step(select_statement) == SQLITE_ROW
                {
                    let obj = Person_Model()
                   /* obj.contact_id = String(cString: UnsafePointer<Int8>(sqlite3_column_text(select_statement, 0)))
                    obj.FirstName = String(cString: UnsafePointer<Int8>(sqlite3_column_text(select_statement, 1)))
                    //obj.lastName = String.fromCString(UnsafePointer<Int8>(sqlite3_column_text(statement, 2)))!
                    obj.Address = String(cString: UnsafePointer<Int8>(sqlite3_column_text(select_statement, 2)))
                    obj.City = String(cString: UnsafePointer<Int8>(sqlite3_column_text(select_statement, 3)))
                    obj.ZipCode = String(cString: UnsafePointer<Int8>(sqlite3_column_text(select_statement, 4)))
                    obj.MobNum = String(cString: UnsafePointer<Int8>(sqlite3_column_text(select_statement, 5)))
                    obj.OtherMobNum = String(cString: UnsafePointer<Int8>(sqlite3_column_text(select_statement, 6)))
                    obj.WorkNum = String(cString: UnsafePointer<Int8>(sqlite3_column_text(select_statement, 7)))
                    obj.email = String(cString: UnsafePointer<Int8>(sqlite3_column_text(select_statement, 8)))
                    obj.remarks = String(cString: UnsafePointer<Int8>(sqlite3_column_text(select_statement, 9)))
                    obj.profile_id = String(cString: UnsafePointer<Int8>(sqlite3_column_text(select_statement, 10)))
                    obj.identifier = String(cString: UnsafePointer<Int8>(sqlite3_column_text(select_statement, 11)))
                    obj.image = String(cString: UnsafePointer<Int8>(sqlite3_column_text(select_statement, 12)))
                    obj.SYNC = String(cString: UnsafePointer<Int8>(sqlite3_column_text(select_statement, 13))) */
                    
                    obj.contact_id = String(cString:(sqlite3_column_text(select_statement, 0)))
                    obj.FirstName = String(cString:(sqlite3_column_text(select_statement, 1)))
                    //obj.lastName = String.fromCString(UnsafePointer<Int8>(sqlite3_column_text(statement, 2)))!
                    obj.Address = String(cString:(sqlite3_column_text(select_statement, 2)))
                    obj.City = String(cString:(sqlite3_column_text(select_statement, 3)))
                    obj.ZipCode = String(cString:(sqlite3_column_text(select_statement, 4)))
                    obj.MobNum = String(cString:(sqlite3_column_text(select_statement, 5)))
                    obj.OtherMobNum = String(cString:(sqlite3_column_text(select_statement, 6)))
                    obj.WorkNum = String(cString:(sqlite3_column_text(select_statement, 7)))
                    obj.email = String(cString: (sqlite3_column_text(select_statement, 8)))
                    obj.remarks = String(cString: (sqlite3_column_text(select_statement, 9)))
                    obj.profile_id = String(cString:(sqlite3_column_text(select_statement, 10)))
                    obj.identifier = String(cString:(sqlite3_column_text(select_statement, 11)))
                    obj.image = String(cString: (sqlite3_column_text(select_statement, 12)))
                    obj.SYNC = String(cString:(sqlite3_column_text(select_statement, 13)))
                    
                    model.add(obj)
                }
            }
            else
            {
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("error preparing select: \(errmsg)")
            }
        }
        else
        {
            print("Error in  opening Databse")
        }
        
       sqlite3_finalize(select_statement)
        return model
    }
    
    func UpdateContact(_ models : NSMutableArray)->Bool
    {
        var update_statement: OpaquePointer? = nil
        var success : Bool = false
        for i in 0  ..< models.count 
        {
            let object = models[i] as! Person_Model
            
            if self.OpenDatabase()
            {
                if sqlite3_prepare_v2(db, "update ContactList set FirstName =?,Address = ?,City = ?,ZipCode = ?,MobilNum = ?,OtherMobNum = ?,WorkNum = ?,Email = ?,Remark = ?,Image = ?,SYNC = ? where Contact_id =\(object.contact_id)", -1, &update_statement, nil) == SQLITE_OK
                {
                    sqlite3_bind_text(update_statement, 1,object.FirstName , -1, SQLITE_TRANSIENT)
                    //            sqlite3_bind_text(update_statement, 2,object.lastName , -1, SQLITE_TRANSIENT)
                    sqlite3_bind_text(update_statement, 2,object.Address , -1, SQLITE_TRANSIENT)
                    sqlite3_bind_text(update_statement, 3,object.City , -1, SQLITE_TRANSIENT)
                    sqlite3_bind_text(update_statement, 4,object.ZipCode , -1, SQLITE_TRANSIENT)
                    sqlite3_bind_text(update_statement, 5,object.MobNum , -1, SQLITE_TRANSIENT)
                    sqlite3_bind_text(update_statement, 6,object.OtherMobNum , -1, SQLITE_TRANSIENT)
                    sqlite3_bind_text(update_statement, 7,object.WorkNum , -1, SQLITE_TRANSIENT)
                    sqlite3_bind_text(update_statement, 8,object.email , -1, SQLITE_TRANSIENT)
                    sqlite3_bind_text(update_statement, 9,object.remarks , -1, SQLITE_TRANSIENT)
                    sqlite3_bind_text(update_statement, 10,object.image , -1, SQLITE_TRANSIENT)
                    sqlite3_bind_text(update_statement, 11,object.SYNC, -1, SQLITE_TRANSIENT)
                    
                    if sqlite3_step(update_statement) == SQLITE_DONE
                    {
                        success = true
                        print("Update Data success")
                    }
                    else
                    {
                        let errmsg = String(cString: sqlite3_errmsg(db))
                        print("failure Updating : \(errmsg)")
                        success = false
                    }
                }
                else
                {
                    let errmsg = String(cString: sqlite3_errmsg(db))
                    print("error preparing Update: \(errmsg)")
                    success = false
                }
                
            }
            else
            {
                success = false
                print("Error in  opening Databse")
            }
             CloseDatabse()
             sqlite3_finalize(update_statement)
        }

      return success
 }
    func DeleteContact(_ contact_id :String)->Bool
    {
         var success : Bool = false
        var Delete_statement: OpaquePointer? = nil
        if OpenDatabase()
        {
            if sqlite3_prepare_v2(db, "delete from ContactList where Contact_id = '\(contact_id)'", -1, &Delete_statement, nil) == SQLITE_OK
            {
                
                if sqlite3_step(Delete_statement) == SQLITE_DONE
                {
                    success = true
                    print("Delete Data success")
                }
                else
                {
                    let errmsg = String(cString: sqlite3_errmsg(db))
                    print("failure Delete : \(errmsg)")
                    success = false
                }
            }
            else
            {
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("error preparing Delete: \(errmsg)")
                success = false
            }

        }
        else
        {
            success = false
            print("Error in  opening Databse")
        }
        sqlite3_finalize(Delete_statement)
        CloseDatabse()
        return success
    }
    
    func AvailbleProfile(_ profileId : String)-> Bool
    {
        var succsess : Bool = false
        var avail_statement: OpaquePointer? = nil
        if self.OpenDatabase()
        {
            let tempString : String
            tempString = "'"+profileId+"'"
            let  query : String = "select * from ContactList where Profile_id = "+tempString
            
            
            if sqlite3_prepare_v2(db,query, -1, &avail_statement, nil) == SQLITE_OK
            {
              if sqlite3_step(avail_statement) == SQLITE_ROW
                {
                   succsess = false
                }
                else
                {
                   succsess = true
                }
            }
            else
            {
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("error preparing select: \(errmsg)")
                succsess = false
            }
        }
        else
        {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error preparing select: \(errmsg)")
            succsess = false
        }
        sqlite3_finalize(avail_statement)
        self.CloseDatabse()
        
     return succsess
    }
   
    func UpdateSync(_ models : BaseModel)->Bool
    {
        let object = models as! Person_Model
        var success : Bool = false
        var update_statement: OpaquePointer? = nil
        if self.OpenDatabase()
        {
            if sqlite3_prepare_v2(db, "update ContactList set SYNC = 1 where Profile_id =\(object.profile_id)", -1, &update_statement, nil) == SQLITE_OK
            {
                
                if sqlite3_step(update_statement) == SQLITE_DONE
                {
                    success = true
                    print("Update Data success")
                }
                else
                {
                    let errmsg = String(cString: sqlite3_errmsg(db))
                    print("failure Updating : \(errmsg)")
                    success = false
                }
            }
            else
            {
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("error preparing Update: \(errmsg)")
                success = false
            }
        }
        else
        {
            success = false
            print("Error in  opening Databse")
        }
        sqlite3_finalize(update_statement)
        CloseDatabse()
        return success
    }
    
    func GetContactTobeUpload()->NSMutableArray
    {
        let model :NSMutableArray = []
         var select_statement: OpaquePointer? = nil
        if self.OpenDatabase()
        {
            if sqlite3_prepare_v2(db, "select * from ContactList where SYNC = 0", -1, &select_statement, nil) == SQLITE_OK
            {
                while sqlite3_step(select_statement) == SQLITE_ROW
                {
                    let obj = Person_Model()
                   /* obj.contact_id = String(cString: UnsafePointer<Int8>(sqlite3_column_text(select_statement, 0)))
                    obj.FirstName = String(cString: UnsafePointer<Int8>(sqlite3_column_text(select_statement, 1)))
                   // obj.lastName = String.fromCString(UnsafePointer<Int8>(sqlite3_column_text(statement, 2)))!
                    obj.Address = String(cString: UnsafePointer<Int8>(sqlite3_column_text(select_statement, 2)))
                    obj.City = String(cString: UnsafePointer<Int8>(sqlite3_column_text(select_statement, 3)))
                    obj.ZipCode = String(cString: UnsafePointer<Int8>(sqlite3_column_text(select_statement, 4)))
                    obj.MobNum = String(cString: UnsafePointer<Int8>(sqlite3_column_text(select_statement,5)))
                    obj.OtherMobNum = String(cString: UnsafePointer<Int8>(sqlite3_column_text(select_statement, 6)))
                    obj.WorkNum = String(cString: UnsafePointer<Int8>(sqlite3_column_text(select_statement, 7)))
                    obj.email = String(cString: UnsafePointer<Int8>(sqlite3_column_text(select_statement, 8)))
                    obj.remarks = String(cString: UnsafePointer<Int8>(sqlite3_column_text(select_statement, 9)))
                    obj.profile_id = String(cString: UnsafePointer<Int8>(sqlite3_column_text(select_statement, 10)))
                    obj.identifier = String(cString: UnsafePointer<Int8>(sqlite3_column_text(select_statement, 11)))
                    obj.image = String(cString: UnsafePointer<Int8>(sqlite3_column_text(select_statement, 12)))
                    obj.SYNC = String(cString: UnsafePointer<Int8>(sqlite3_column_text(select_statement, 13)))*/
                    
                    obj.contact_id = String(cString:(sqlite3_column_text(select_statement,0)))
                    obj.FirstName = String(cString:(sqlite3_column_text(select_statement, 1)))
                    // obj.lastName = String.fromCString(UnsafePointer<Int8>(sqlite3_column_text(statement, 2)))!
                    obj.Address = String(cString: (sqlite3_column_text(select_statement, 2)))
                    obj.City = String(cString:(sqlite3_column_text(select_statement, 3)))
                    obj.ZipCode = String(cString: (sqlite3_column_text(select_statement, 4)))
                    obj.MobNum = String(cString: (sqlite3_column_text(select_statement,5)))
                    obj.OtherMobNum = String(cString: (sqlite3_column_text(select_statement, 6)))
                    obj.WorkNum = String(cString: (sqlite3_column_text(select_statement, 7)))
                    obj.email = String(cString: (sqlite3_column_text(select_statement, 8)))
                    obj.remarks = String(cString: (sqlite3_column_text(select_statement, 9)))
                    obj.profile_id = String(cString: (sqlite3_column_text(select_statement, 10)))
                    obj.identifier = String(cString: (sqlite3_column_text(select_statement, 11)))
                    obj.image = String(cString: (sqlite3_column_text(select_statement, 12)))
                    obj.SYNC = String(cString:(sqlite3_column_text(select_statement, 13)))
                    
                    model.add(obj)
                }
            }
            else
            {
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("error preparing select: \(errmsg)")
            }
        }
        else
        {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error preparing select: \(errmsg)")
        }
        sqlite3_finalize(select_statement)
        self.CloseDatabse()
        return model
   
    }
    
    func UpdateContact_usingProfile(_ models : BaseModel)->Bool
    {
        
        let object = models  as! Person_Model
        var success : Bool = false
        var update_statement: OpaquePointer? = nil
        if OpenDatabase()
        {
            if sqlite3_prepare_v2(db, "update ContactList set FirstName =?,Address = ?,City = ?,ZipCode = ?,MobilNum = ?,OtherMobNum = ?,WorkNum = ?,Email = ?,Remark = ?,Image = ? where Profile_id =\(object.profile_id)", -1, &update_statement, nil) == SQLITE_OK
            {
                sqlite3_bind_text(update_statement, 1,object.FirstName , -1, SQLITE_TRANSIENT)
                //sqlite3_bind_text(statement, 2,object.lastName , -1, SQLITE_TRANSIENT)
                sqlite3_bind_text(update_statement, 2,object.Address , -1, SQLITE_TRANSIENT)
                sqlite3_bind_text(update_statement, 3,object.City , -1, SQLITE_TRANSIENT)
                sqlite3_bind_text(update_statement, 4,object.ZipCode , -1, SQLITE_TRANSIENT)
                sqlite3_bind_text(update_statement, 5,object.MobNum , -1, SQLITE_TRANSIENT)
                sqlite3_bind_text(update_statement, 6,object.OtherMobNum , -1, SQLITE_TRANSIENT)
                sqlite3_bind_text(update_statement, 7,object.WorkNum , -1, SQLITE_TRANSIENT)
                sqlite3_bind_text(update_statement, 8,object.email , -1, SQLITE_TRANSIENT)
                sqlite3_bind_text(update_statement, 9,object.remarks , -1, SQLITE_TRANSIENT)
                sqlite3_bind_text(update_statement, 10,object.image , -1, SQLITE_TRANSIENT)
                
                if sqlite3_step(update_statement) == SQLITE_DONE
                {
                    success = true
                    print("Update Data success")
                }
                else
                {
                    let errmsg = String(cString: sqlite3_errmsg(db))
                    print("failure Updating : \(errmsg)")
                    success = false
                }
            }
            else
            {
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("error preparing Update: \(errmsg)")
                success = false
            }

        }
        else
        {
            success = false
            print("Error in  opening Databse")
        }
        
        
        sqlite3_finalize(update_statement)
        CloseDatabse()
        return success
    }
    func ClearTableData()-> Bool
    {
        var success : Bool = false
         var clear_statement: OpaquePointer? = nil
        if OpenDatabase()
        {
            if sqlite3_prepare_v2(db, "delete from ContactList", -1, &clear_statement, nil) == SQLITE_OK
            {
                
                if sqlite3_step(clear_statement) == SQLITE_DONE
                {
                    success = true
                    print("Delete Data success")
                }
                else
                {
                    let errmsg = String(cString: sqlite3_errmsg(db))
                    print("failure Delete : \(errmsg)")
                    success = false
                }
            }
            else
            {
                let errmsg = String(cString: sqlite3_errmsg(db))
                print("error preparing Delete: \(errmsg)")
                success = false
            }
            
        }
        else
        {
            success = false
            print("Error in  opening Databse")
        }
        sqlite3_finalize(clear_statement)
        CloseDatabse()
        return success
    }

}
