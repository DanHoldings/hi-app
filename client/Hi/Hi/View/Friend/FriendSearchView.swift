//
//  FriendSearchView.swift
//  Hi
//
//  Created by Yuma on 2024/04/12.
//

import SwiftUI

struct FriendSearchView: View {
    @FocusState private var isFocused: Bool
    @State var inputText = ""
    
    var body: some View {
        VStack {
            ZStack {
                BackButton()
                Text("フレンド検索")
                    .font(.title)
                    .bold()
                    .padding()
            }
            // 検索窓
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("フレンドのユーザーIDを入力", text: $inputText)
                    .focused($isFocused)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("閉じる") {
                                isFocused = false
                            }
                        }
                    }
                if isFocused {
                    Button(action: {
                        self.inputText = ""
                    }){
                        Image(systemName: "multiply.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(25)
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(.primary, lineWidth: 1)
            )
            .padding(.horizontal)
            
            Spacer()
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    FriendSearchView()
}