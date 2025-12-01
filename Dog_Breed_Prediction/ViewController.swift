//
//  ViewController.swift
//  Dog_Breed_Prediction
//
//  Created by brandonsanford on 11/30/25.
//

import UIKit
// import CoreML frameword --> dogBreed
import CoreML
// import CoreVideo for CVPixelBufferLo
import CoreVideo

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Debug: Check if outlets are connected --> error checking assisted with Cursor.Ai
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
    
    // declare model variable for the Core ML model
    var model:dogBreed!
    
    // Initialize model with viewWillAppear() method
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let modelURL = Bundle.main.url(forResource: "dogBreed", withExtension: "mlpackage") else {
            fatalError("Couldn't find the model file.")
        }
        model = try! dogBreed(contentsOf: modelURL)
    }
    
    // Impliment two delegate methods for the image picker: imagePickerController and imagePickerControllerDidCancel --> called when user selects imaage from library or cancles selecting image from library
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // Safely unwrap the image instead of force unwrapping
        if let pickedImage = info[.originalImage] as? UIImage {
            imageView.image = pickedImage
            
            // Resize image: The model only takes in images of size 224x224; the image needs to bresized.
            
            //  Convert the selected image to size 224x224
            UIGraphicsBeginImageContextWithOptions (CGSize(width: 277,
            height: 277), true, 2.0)
            pickedImage.draw(in: CGRect(x: 0, y: 0, width: 277,
            height: 277))
            
            // Store the new image in the form of a pixel buffer
            let newImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            let attrs = [kCVPixelBufferCGImageCompatibilityKey:
            kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey:
            kCFBooleanTrue] as CFDictionary
            var pixelBuffer : CVPixelBuffer?
            let status = CVPixelBufferCreate(kCFAllocatorDefault,
            Int(newImage.size.width), Int(newImage.size.height),
            kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
            guard (status == kCVReturnSuccess) else {
                return
            }
            
            // Convert pixels in the device into a dependent RGB color space
            CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
            let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
            let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
            
            // Store the pixel data in CGContext
            let context = CGContext(data: pixelData, width:
            Int(newImage.size.width), height: Int(newImage.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace,
            bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
            
            // Scale the image as per requirement lines
            context?.translateBy(x: 0, y: newImage.size.height)
            context?.scaleBy(x: 1.0, y: -1.0)
            
            // Update the final image buffer
            UIGraphicsPushContext(context!)
            newImage.draw(in: CGRect(x: 0, y: 0, width: newImage.size.width, height: newImage.size.height))
            UIGraphicsPopContext()
            CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
            
        // After image processing, the model is then called to predict the image (specifically the predicted ouput)
            
            // Predict image label
            guard let prediction = try? model.prediction(resnet50_input:
            pixelBuffer!) else{
                predictionText.text = "Can't Predict!"
                return
            }
        // output image predition
            predictionText.text = "Dog Breed: \(prediction.classLabel)."
        }
        
        self.dismiss(animated: true, completion: nil)
        
        
       
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
}

