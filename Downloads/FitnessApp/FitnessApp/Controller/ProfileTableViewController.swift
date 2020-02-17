//
//  ProfileTableViewController.swift
//  
//
//  Created by Mitko on 1/24/20.
//

import UIKit
import Firebase
import FirebaseStorage
class ProfileTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var profilePicture: UIImageView!
    let picker = UIImagePickerController()
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser?.email
    var profileImageURL : String = ""
    
    
    override func viewDidLoad() {
            super.viewDidLoad()
            updateUI()
            setProfileImage()
        }
        

        
        @IBAction func changeProfilePicture(_ sender: UIButton) {
            picker.delegate = self
            picker.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
            present(picker, animated: true, completion: nil)
            self.present(picker, animated: true)
        }
    
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            picker.allowsEditing = true
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                profilePicture.image = image
                uploadPhoto()
            }
            
            dismiss(animated: true, completion: nil)
            
            setProfileImage()
        }
        
        func uploadPhoto() {
            guard let image = profilePicture.image, let data = image.jpegData(compressionQuality: 1.0) else {
                return
            }
            
            let imageName = UUID().uuidString
            let imageReference = Storage.storage().reference().child("images").child(imageName)
            
            imageReference.putData(data, metadata: nil) { (metadata, err) in
                if let err = err {
                    print(err)
                }
                imageReference.downloadURL { (url, err) in
                    if let err = err {
                        print(err)
                    }
                    guard let url = url else {
                        
                        return
                    }
                    
                    let userReference = self.db.collection(Constants.CollectionNames.users).document(self.user!)
                    let documentID = userReference.documentID
                    let urlString = url.absoluteString
                    
                    let data = [
                        "profileImage" : [
                            "imageUid": documentID,
                            "imageURL": urlString
                        ]
                        
                    ]
                    print(urlString)
                    userReference.setData(data, merge: true)
                    UserDefaults.standard.set(documentID, forKey: "imageURL")
                }
            }
        }
        
    func setProfileImage() {
        guard let imageURLString = UserDefaults.standard.value(forKey: "imageURL") as? URL else {
            let profileImageRef = db.collection(Constants.CollectionNames.users).document(user!)
            profileImageRef.getDocument { (document, error) in
                if let doc = document,let e = error {
                    self.profileImageURL = doc.get("imageURL") as! String
                    
            }
                
            }
            return
            
        }
        print(profileImageURL)
//        print(imageURLString)
//        profilePicture.image = downloadImage(from: imageURLString)
    }
    
    func getData(from url: URL, completion: @escaping(Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    
     func downloadImage(from url: URL) -> UIImage{
        print(url)
        var image = UIImage()
        getData(from: url) { data, response, error in
        guard let data = data, error == nil else { return }
        DispatchQueue.main.async() {
            image = UIImage(data: data)!
        }
        }
        return image
    }
        
        
        func updateUI() {
            profilePicture.layer.cornerRadius = profilePicture.frame.height / 2
        }
        
    
        @IBAction func logOut(_ sender: Any) {
            let auth = Auth.auth()
            
            
        }
    
        override func numberOfSections(in tableView: UITableView) -> Int {
            // #warning Incomplete implementation, return the number of sections
            return 1
        }

        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // #warning Incomplete implementation, return the number of rows
            return 5
        }
    
    }





    

 
