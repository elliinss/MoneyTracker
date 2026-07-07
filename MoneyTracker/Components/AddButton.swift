//
//  AddButton.swift
//  MoneyTracker
//
//  Created by Ilvina on 07.07.2026.
//

import Foundation
import SwiftUI

struct AddButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .foregroundColor(.white)
                .frame(width: 60, height: 60)
                .background(Color.blue)
                .clipShape(Circle())
        }
    }
}
