//
//  Database.swift
//  JSONTest
//
//  Created by Victor on 09/02/2019.
//  Copyright © 2019 com.example.LoD. All rights reserved.
//

import SQLite

class Database {
    let fileName = "db.sqlite"
    var createTableString = String()
    var db: OpaquePointer?
    var statement: OpaquePointer?
    var pointer: OpaquePointer?
    
    func createTable(){
        let dbUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(self.fileName)
        
        sqlite3_open(dbUrl.path, &db)
        
        createTableString = "CREATE TABLE IF NOT EXISTS Category(id INTEGER, title TEXT)"
        
        if sqlite3_prepare_v2(db, createTableString, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Category table created.")
            } else {
                print("Category table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(statement)
        
    }
    
    func insert(id: Int, title: String) {
        var insertStatement: OpaquePointer? = nil
        let insertStatementString = "INSERT INTO Category (id, title) VALUES (?, ?);"
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            let id: Int32 = Int32(id)
            let title: NSString = title as NSString
            sqlite3_bind_int(insertStatement, 1, id)
            sqlite3_bind_text(insertStatement, 2, title.utf8String, -1, nil)
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func query() {
        let queryStatementString = "SELECT * FROM Category;"
        var queryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            
            while (sqlite3_step(queryStatement) == SQLITE_ROW) {
                let id = sqlite3_column_int(queryStatement, 0)
                let queryResultCol1 = sqlite3_column_text(queryStatement, 1)
                let title = String(cString: queryResultCol1!)
                print("Query Result:")
                print("\(id) | \(title)")
            }
            
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
    }
    
    func deleteAllRows() {
        let deleteStatementStirng = "DELETE FROM Category"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        
        sqlite3_finalize(deleteStatement)
    }
    
}
