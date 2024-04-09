//
//  LogoutButton.swift
//  Hi
//
//  Created by Yuma on 2024/04/09.
//

import SwiftUI

struct LogoutButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Rectangle()
                    .frame(height: 50)
                    .foregroundColor(.white)
                Text("ログアウト")
                    .foregroundColor(.red)
                    .bold()
            }
        }
    }
}

#Preview {
    LogoutButton(action: {
        print("ログアウトする！")
    })
}
