//
//  ToastView.swift
//  whatpokemon
//
//  Created by Jose Chirinos Odio on 28/12/25.
//

import SwiftUI

struct ToastView: View {
    let message: String
    let type: ToastType
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
            Text(message)
                .font(.subheadline)
        }
        .padding()
        .background(backgroundColor)
        .foregroundColor(.white)
        .cornerRadius(10)
        .shadow(radius: 10)
    }
    
    private var iconName: String {
        switch type {
        case .error: return "exclamationmark.triangle.fill"
        case .warning: return "exclamationmark.circle.fill"
        case .info: return "info.circle.fill"
        }
    }
    
    private var backgroundColor: Color {
        switch type {
        case .error: return .red
        case .warning: return .orange
        case .info: return .blue
        }
    }
}
