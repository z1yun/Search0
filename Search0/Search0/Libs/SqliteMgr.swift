//
//  SqliteMgr.swift
//  Search0
//
//  Created by shbaek on 6/9/25.
//
import Foundation
import SQLite3

/// 검색 기록을 저장하기 위해 Sqlite를 사용한다.
/// column -> idx: INT AUTOINCREMENT,  text : 검색어,  regdt: 검색 시간 TimeInterval since 1970
class SqliteMgr {
    private var db: OpaquePointer?
    private let dbName = "search.db"
    private let tableName = "search_history"

    static let shared = SqliteMgr()
    
    init() {
//        guard openDatabase() else {
//            return nil
//        }
//        if !createTable() {
//            return nil
//        }
        _ = createTable()
        _ = openDatabase()
    }
    
    deinit {
        sqlite3_close(db)
    }
    
    /// Open DB
    private func openDatabase() -> Bool {
        let fileManager = FileManager.default
        let docDir = try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let dbPath = docDir.appendingPathComponent(dbName).path
        
        if sqlite3_open(dbPath, &db) != SQLITE_OK {
            print("Failed to open DB")
            return false
        }
        return true
    }
    
    ///  Create Table
    private func createTable() -> Bool {
        let createSQL = """
        CREATE TABLE IF NOT EXISTS \(tableName) (
            idx INTEGER PRIMARY KEY AUTOINCREMENT,
            search_word TEXT NOT NULL,
            regdt INTEGER NOT NULL
        );
        """
        
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, createSQL, -1, &statement, nil) != SQLITE_OK {
            print("Create table prepare error: \(errorMessage())")
            return false
        }
        
        defer { sqlite3_finalize(statement) }
        
        if sqlite3_step(statement) != SQLITE_DONE {
            print("Create table step error: \(errorMessage())")
            return false
        }
        
        return true
    }
    
    /// 데이터 추가.
    func insert(searchWord: String, regdt: Int) -> Bool {
        let insertSQL = "INSERT INTO \(tableName) (search_word, regdt) VALUES (?, ?);"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, insertSQL, -1, &statement, nil) != SQLITE_OK {
            print("Insert prepare error: \(errorMessage())")
            return false
        }
        
        sqlite3_bind_text(statement, 1, (searchWord as NSString).utf8String, -1, nil)
        sqlite3_bind_int(statement, 2, Int32(regdt))
        
        defer { sqlite3_finalize(statement) }
        
        if sqlite3_step(statement) != SQLITE_DONE {
            print("Insert step error: \(errorMessage())")
            return false
        }
        
        return true
    }
    
    /// 전체 데이터.
    func selectAll() -> [(idx: Int, text: String, regdt: Int)] {
        let selectSQL = "SELECT idx, search_word, regdt FROM \(tableName) ORDER BY idx DESC;"
        var statement: OpaquePointer?
        var results: [(Int, String, Int)] = []
        
        if sqlite3_prepare_v2(db, selectSQL, -1, &statement, nil) != SQLITE_OK {
            print("Select prepare error: \(errorMessage())")
            return results
        }
        
        defer { sqlite3_finalize(statement) }
        
        while sqlite3_step(statement) == SQLITE_ROW {
            let idx = Int(sqlite3_column_int(statement, 0))
            let word = String(cString: sqlite3_column_text(statement, 1))
            let regdt = Int(sqlite3_column_int(statement, 2))
            results.append((idx, word, regdt))
        }
        
        return results
    }
    
    /// row 삭제
    func delete(idx: Int) -> Bool {
        let deleteSQL = "DELETE FROM \(tableName) WHERE idx = ?;"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, deleteSQL, -1, &statement, nil) != SQLITE_OK {
            print("Delete prepare error: \(errorMessage())")
            return false
        }
        
        sqlite3_bind_int(statement, 1, Int32(idx))
        
        defer { sqlite3_finalize(statement) }
        
        if sqlite3_step(statement) != SQLITE_DONE {
            print("Delete step error: \(errorMessage())")
            return false
        }
        
        return true
    }
    
    /// 전체 row 삭제
    func deleteAll() -> Bool {
        let deleteSQL = "DELETE FROM \(tableName);"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, deleteSQL, -1, &statement, nil) != SQLITE_OK {
            print("Delete All prepare error: \(errorMessage())")
            return false
        }
        
        defer { sqlite3_finalize(statement) }
        
        if sqlite3_step(statement) != SQLITE_DONE {
            print("Delete All step error: \(errorMessage())")
            return false
        }
        
        return true
    }
    
    // MARK: - Error Message
    func errorMessage() -> String {
        if let err = sqlite3_errmsg(db) {
            return String(cString: err)
        }
        return "Unknown error"
    }
}

