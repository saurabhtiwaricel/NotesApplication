import UIKit
import CoreData

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {

    var notes: [UserNote] = []
    var filteredNotes: [UserNote] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var searchController: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
        searchController.delegate = self

        fetchNotes()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchNotes()
    }

    @IBAction func addTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "ShowDetail", sender: nil)
        
    }

   
    func fetchNotes(searchText: String = "") {
        let request: NSFetchRequest<UserNote> = UserNote.fetchRequest()
        let sort = NSSortDescriptor(key: "createdAt", ascending: false)
        request.sortDescriptors = [sort]

        if !searchText.isEmpty {
            request.predicate = NSPredicate(format: "title CONTAINS[cd] %@ OR content CONTAINS[cd] %@", searchText, searchText)
        }

        do {
            notes = try context.fetch(request)
            filteredNotes = notes
            collectionView.reloadData()

           
            let noDataLabel = UILabel()
            noDataLabel.text = "No notes available"
            noDataLabel.textColor = .gray
            noDataLabel.textAlignment = .center
            collectionView.backgroundView = filteredNotes.isEmpty ? noDataLabel : nil
        } catch {
            print("Failed to fetch notes: \(error)")
        }
    }


    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        fetchNotes(searchText: searchText)
    }


    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        fetchNotes()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredNotes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoteCell", for: indexPath) as? NotesCollectionViewCell
            let note = filteredNotes[indexPath.row]
        cell?.celllbl2.text = note.title
        cell?.celllbl1.text = note.content


        cell?.layer.borderColor = UIColor.gray.cgColor
        cell?.layer.borderWidth = 1.0
        cell?.layer.cornerRadius = 8.0
        cell?.layer.masksToBounds = true

        return cell!
       
    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("show")
        performSegue(withIdentifier: "ShowDetail", sender: filteredNotes[indexPath.row])
    }

  
    func collectionView(_ collectionView: UICollectionView, trailingSwipeActionsConfigurationForItemAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let noteToDelete = filteredNotes[indexPath.row]

        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completionHandler in
            guard let self = self else { return }

            let alert = UIAlertController(title: "Delete Note", message: "Are you sure you want to delete this note?", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                completionHandler(false)
            }
            let confirmAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
                self.context.delete(noteToDelete)

                do {
                    try self.context.save()
                    self.fetchNotes()  // Reload after deletion
                    completionHandler(true)
                } catch {
                    print("Failed to delete note: \(error)")
                    completionHandler(false)
                }
            }

            alert.addAction(cancelAction)
            alert.addAction(confirmAction)

            self.present(alert, animated: true, completion: nil)
        }

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

 
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let note = filteredNotes[indexPath.row]

        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), identifier: nil) { _ in
                let alert = UIAlertController(title: "Delete Note", message: "Are you sure you want to delete this note?", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                let confirmAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
                    self.context.delete(note)
                    do {
                        try self.context.save()
                        self.fetchNotes()
                    } catch {
                        print("Failed to delete note: \(error)")
                    }
                }

                alert.addAction(cancelAction)
                alert.addAction(confirmAction)

                self.present(alert, animated: true, completion: nil)
            }

            return UIMenu(title: "", children: [deleteAction])
        }
    }

  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("segue")
        if let detailVC = segue.destination as? NoteViewController,
           let note = sender as? UserNote {
            detailVC.note = note
        }
    }
}
extension ViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10)
        }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = collectionView.bounds.width
            return CGSize(width: collectionWidth / 2 - 20, height: collectionWidth / 2-10)
    }
}
