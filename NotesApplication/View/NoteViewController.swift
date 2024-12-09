import UIKit
import CoreData

class NoteViewController: UIViewController {

    @IBOutlet weak var datelbl: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var titleTextField: UITextField!

    var note: UserNote? 
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureView()
    }

    private func configureView() {
        
        if let note = note {
            titleTextField.text = note.title
            contentTextView.text = note.content
            if let createdAt = note.createdAt {
                datelbl.text = formatDate(createdAt)
            }
        } else {
            datelbl.text = formatDate(Date())
        }
    }

    @IBAction func saveButtonTapped(_ sender: Any) {
        saveNote()
    }

    private func saveNote() {
        if note == nil {
            // Create a new note if none exists
            note = UserNote(context: context)
            note?.createdAt = Date()
        }

        // Update note details
        note?.title = titleTextField.text ?? "Untitled"
        note?.content = contentTextView.text ?? ""

        // Save to Core Data
        do {
            try context.save()
            navigationController?.popViewController(animated: true)
        } catch {
            print("Failed to save note: \(error)")
        }
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
