//
//  ViewController.swift
//  Dog_Breed_Prediction
//
//  Created by brandonsanford on 11/30/25.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Debug: Check if outlets are connected
        print("viewDidLoad called")
        print("imageView is connected: \(imageView != nil)")
        print("predictionText is connected: \(predictionText != nil)")
        print("btn is connected: \(btn != nil)")
    }

    
    @IBOutlet weak var predictionText: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var btn: UIButton!
    
    
    @IBAction func btnClick(_ sender: Any) {
        
        print("Button clicked!")
        
        // Confirm delegate method for picking an image
        
        // Check if photo library is available
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("ERROR: Photo library is not available")
            return
        }
        
        print("Photo library is available, creating image picker...")
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        print("About to present image picker...")
        
        // Make sure we're on the main thread
        DispatchQueue.main.async {
            self.present(imagePicker, animated: true, completion: {
                print("Image picker presented successfully")
            })
        }
    }
    
    // Impliment two delegate methods for the image picker: imagePickerController and imagePickerControllerDidCancel --> called when user selects imaage from library or cancles selecting image from library
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // Safely unwrap the image instead of force unwrapping
        if let pickedImage = info[.originalImage] as? UIImage {
            imageView.image = pickedImage
            
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}

