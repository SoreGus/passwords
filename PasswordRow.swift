import SwiftUI

struct PasswordRow: View {
    let record: PasswordRecord
    let isExpanded: Bool  // Define se a seção está aberta para ajustar o fundo
    
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
     //   .background(isExpanded ? Color.blue.opacity(0.15) : Color.clear) // Ajusta o fundo
        .cornerRadius(8)
    }
}
