//
//  SettingViewModel.swift
//  Hi
//
//  Created by Yuma on 2024/04/19.
//

import Foundation
import Combine

class SettingViewModel: ObservableObject {
    @Published var name = ""
    @Published var userID = ""
    
    let userDefaultsHelper = UserDefaultsHelper()
    private var cancellables: Set<AnyCancellable> = []
    
    func onAppear() {
        name = userDefaultsHelper.getStringData(key: "name")
        userID = userDefaultsHelper.getStringData(key: "userName")
    }
    
    func putUserData(){
        let changeUser = setChangeUserData()
        print(changeUser)
        SettingModel.putUserData(userchangeDto: changeUser, id: changeUser._id)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("成功した")
                    break
                case .failure(let error):
                    print(error.errorDescription)
                }
            }, receiveValue: { data in
                print(data)
            })
            .store(in: &cancellables)
    }
    
    func setChangeUserData() -> UserChangeDto {
        let id = userDefaultsHelper.getStringData(key: "id")
        let email = userDefaultsHelper.getStringData(key: "email")
        let name = userDefaultsHelper.getStringData(key: "name")
        let userName = userDefaultsHelper.getStringData(key: "userName")
        let getUpAt = userDefaultsHelper.getStringData(key: "wakeUpTime")
        let daysToAlarm = userDefaultsHelper.getArrayData(key: "dayOfWeekSelected") as? [Bool] ?? []
        let changeUserData = UserChangeDto(_id: id, email: email, userName: userName,
                                              name: name, getUpAt: getUpAt, daysToAlarm: daysToAlarm )
        
        return changeUserData
    }
    
}
