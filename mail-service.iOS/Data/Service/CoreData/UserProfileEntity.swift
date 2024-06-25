////
////  UserProfileEntity.swift
////  mail-service.iOS
////
////  Created by HITSStudent on 24.06.2024.
////
//
//import Foundation
//import CoreData
//
//@objc(UserProfileEntity)
//public class UserProfileEntity: NSManagedObject {
//    @NSManaged public var id: Int64
//    @NSManaged public var name: String
//    @NSManaged public var surname: String
//    @NSManaged public var birthday: String
//    @NSManaged public var gender: String
//    @NSManaged public var login: String
//    @NSManaged public var phoneNum: String?
//    @NSManaged public var avatar: String?
//}
//
//extension UserProfileEntity {
//    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserProfileEntity> {
//        return NSFetchRequest<UserProfileEntity>(entityName: "UserProfileEntity")
//    }
//}
//
//extension UserProfileEntity: Identifiable {}
//
