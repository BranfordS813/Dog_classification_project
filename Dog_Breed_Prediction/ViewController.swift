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
    }

    
    @IBOutlet weak var predictionText: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var btn: UIButton!
    
    
    @IBAction func btnClick(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
}

