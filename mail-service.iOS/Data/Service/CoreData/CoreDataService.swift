import Foundation
import CoreData

final class CoreDataService {
    static let shared = CoreDataService()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "mail_service_iOS")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Core Data store failed to load with error: \(error)")
            }
        }
        return container
    }()
    
    func fetchUserProfile() -> UserProfile? {
        let request: NSFetchRequest<UserProfileEntity> = UserProfileEntity.fetchRequest()
        let context = persistentContainer.viewContext
        
        do {
            let userProfileEntities = try context.fetch(request)
            
            guard let firstEntity = userProfileEntities.first else {
                return nil
            }
            
            let id = Int(firstEntity.id)
            let name = firstEntity.name ?? ""
            let surname = firstEntity.surname ?? ""
            let birthday = firstEntity.birthday ?? ""
            let gender = firstEntity.gender ?? ""
            let login = firstEntity.login ?? ""
            let phoneNum = firstEntity.phoneNum ?? "Не указан"
            let avatar = firstEntity.avatar
            
            return UserProfile(
                id: id,
                name: name,
                surname: surname,
                birthday: birthday,
                gender: gender,
                login: login,
                phoneNum: phoneNum,
                avatar: avatar
            )
            
        } catch {
            print("Failed to fetch user profile: \(error)")
            return nil
        }
    }
    
    func saveUserProfile(_ profile: UserProfile) {
        let context = persistentContainer.viewContext
        context.perform {
            let userProfileEntity = UserProfileEntity(context: context)
            userProfileEntity.id = Int64(profile.id)
            userProfileEntity.name = profile.name
            userProfileEntity.surname = profile.surname
            userProfileEntity.birthday = profile.birthday
            userProfileEntity.gender = profile.gender
            userProfileEntity.login = profile.login
            userProfileEntity.phoneNum = profile.phoneNum
            userProfileEntity.avatar = profile.avatar
            
            do {
                try context.save()
                print("UserProfile saved successfully")
            } catch {
                print("Failed to save user profile: \(error)")
            }
        }
    }
    
}
