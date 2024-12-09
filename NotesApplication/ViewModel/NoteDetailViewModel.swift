import Foundation


class NoteDetailViewModel {

    
    var note: UserNote?

    var title: String {
        return note?.title ?? ""
    }

    var content: String {
        return note?.content ?? ""
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: note?.createdAt ?? Date())
    }

   
}
