import SwiftUI

struct PasswordRowView: View {
    let record: PasswordRecord
    let isExpanded: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(record.domain)
                    .font(.headline)
                Text(record.username)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Text("\(record.accessHistory.count) accesses")
                .font(.caption)
                .foregroundColor(.blue)
        }
        .padding(.vertical, 8)
        .cornerRadius(8)
    }
}
