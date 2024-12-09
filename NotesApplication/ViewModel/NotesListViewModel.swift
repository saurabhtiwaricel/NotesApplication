
import Foundation


class NotesListViewModel {

   
    private var allNotes: [UserNote] = []
    var filteredNotes: [UserNote] = []

    var notesCount: Int {
        return filteredNotes.count
    }

    func noteAt(index: Int) -> UserNote {
        return filteredNotes[index]
    }

   

}
