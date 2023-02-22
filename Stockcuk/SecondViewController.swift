//
//  SecondViewController.swift
//  Stockcuk
//
//  Created by Erkan on 27.11.2022.
//

import UIKit
import CoreData

class SecondViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pricetext: UITextField!
    @IBOutlet weak var typeText: UITextField!
    @IBOutlet weak var numberText: UITextField!
    
    var secilenUrunType = ""
    var secilenUrunUUID : UUID?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pricetext.delegate = self
        numberText.delegate = self
        
        pricetext.keyboardType = .numberPad
        numberText.keyboardType = .numberPad

        // Do any additional setup after loading the view.
        
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(klavyeyikapat))
        view.addGestureRecognizer(gestureRecognizer)
        
        imageView.isUserInteractionEnabled = true
        let imageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gorselSec))
        imageView.addGestureRecognizer(imageGestureRecognizer)
        
    }
    
    @objc func gorselSec(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }
    
    
    
    @objc func klavyeyikapat(){
        view.endEditing(true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func saveButton(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let stockData = NSEntityDescription.insertNewObject(forEntityName: "Stock", into: context)
        
        stockData.setValue(typeText.text, forKey: "type")
        
        if let price = Int(pricetext.text!){
            stockData.setValue(price, forKey: "price")
        }
        if let numbers = Int(numberText.text!){
            stockData.setValue(numbers, forKey: "numbers")
        }
        
        stockData.setValue(UUID(), forKey: "id")
        let data = imageView.image!.jpegData(compressionQuality: 0.5)
        stockData.setValue(data, forKey: "image")
        
            
            
        do{
            try context.save()
            print("Kayıt Edildi")
        }catch{
            print("hata var")
        }
        
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "VeriGirildi"), object: nil)
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
}
