//
//  CommentView.swift
//  client
//
//  Created by Emircan Duman on 05.12.24.
//

import SwiftUI

struct CommentView: View {
    @Binding var viewModel: DetailPintPointViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(viewModel.pinPoint.comments, id: \.id) { comment in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(comment.username)
                            .font(.headline)
                            .foregroundColor(Color.accent)
                        Text(comment.timeStamp, style: .time)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
 
                    Text(comment.message)
                        .font(.body)

                }
                .padding(.vertical, 4)
            }
        }
        .padding(.vertical)
    }
}
