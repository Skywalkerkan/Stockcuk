//
//  DetailsViewController.swift
//  Stockcuk
//
//  Created by Erkan on 27.11.2022.
//

import UIKit
import CoreData
class DetailsViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var typeText: UITextField!
    
    @IBOutlet weak var numberText: UITextField!
    @IBOutlet weak var priceText: UITextField!
    
    
    var secilenUrunType = ""
    var secilenUrunUUID : UUID?
    var IdLists = [UUID]()
    var TypeLists = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberText.delegate = self
        numberText.keyboardType = .numberPad
        priceText.delegate = self
        priceText.keyboardType = .numberPad
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(klavyeyikapat))
        view.addGestureRecognizer(gestureRecognizer)
        
        if secilenUrunType != ""{
            if let uuidString = secilenUrunUUID?.uuidString{
                let appdelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appdelegate.persistentContainer.viewContext
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Stock")
                fetchRequest.predicate = NSPredicate(format: "id = %@", uuidString)
                fetchRequest.returnsObjectsAsFaults = false
                
                do{
                    let sonuclar = try context.fetch(fetchRequest)
                    if sonuclar.count > 0{
                        for sonuc in sonuclar as! [NSManagedObject]{
                            if let type = sonuc.value(forKey: "type"){
                                typeText.text = type as? String
                            }
                            if let price = sonuc.value(forKey: "price") as? Int{
                                priceText.text = String(price)
                            }
                            if let number = sonuc.value(forKey: "numbers") as? Int{
                                numberText.text = String(number)
                            }
                            if let data = sonuc.value(forKey: "image") as? Data{
                                let image = UIImage(data: data)
                                imageView.image = image
                            }
                            
                            
                            
                        }
                    }
                }catch{
                    print("hata")
                }
                
                
                
            }
        }else{
            numberText.text = ""
            priceText.text = ""
            typeText.text = ""
            
        }

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @objc func klavyeyikapat(){
        view.endEditing(true)
    }
    
    
    
    @IBAction func numberAddButton(_ sender: Any) {
        let sayi = Int(numberText.text!)
        numberText.text = String(sayi! + 1)
        
    }
    
    
    @IBAction func numberSubstractButton(_ sender: Any) {
        let sayi = Int(numberText.text!)
        numberText.text = String(sayi! - 1)
    }
    
    @IBAction func numberADDButton(_ sender: Any) {
        let sayi = Int(priceText.text!)
        priceText.text = String(sayi! + 1)
    }
    
    
    @IBAction func numberSUButton(_ sender: Any) {
        let sayi = Int(priceText.text!)
        priceText.text = String(sayi! - 1)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        print(secilenUrunUUID!.uuidString)
        let uuidString = secilenUrunUUID!.uuidString
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let stockData = NSEntityDescription.insertNewObject(forEntityName: "Stock", into: context)
        //let stockData = NSEntityDescription.entity(forEntityName: "Stock", in: context)
       // let stooockData =
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Stock")
        fetchRequest.predicate = NSPredicate(format: "id = %@", uuidString)
        fetchRequest.returnsObjectsAsFaults = false
        
        do{
            let sonuclar = try context.fetch(fetchRequest)
            if sonuclar.count > 0{
                for sonuc in sonuclar as! [NSManagedObject]{    //ÜSTÜNE NASIL YAZABİLİRİM SOR ?
                    if sonuc.value(forKey: "id") is UUID{
                        context.delete(sonuc)
                        do{
                            try context.save()
                        }catch{
                            
                        }
                        break
                    }
                }
            }
        }catch{
            print("hata")
        }
 
        
        
        stockData.setValue(typeText.text, forKey: "type")
        if let price = Int(priceText.text!){
            stockData.setValue(price, forKey: "price")
        }
        if let number = Int(numberText.text!){
            stockData.setValue(number, forKey: "numbers")
        }
        stockData.setValue(UUID(), forKey: "id")
        let data = imageView.image?.jpegData(compressionQuality: 0.5)
        stockData.setValue(data, forKey: "image")
        
        
        
        
        
        do{
            try context.save()
            print("Kayıt Edildi")
        }catch{
            print("hata var")
        }
            
        //NotificationCenter
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Veri2Girildi"), object: nil)
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
    
    @IBAction func deleteButton(_ sender: Any) {
        //print(secilenUrunUUID!)
        let uuidString = secilenUrunUUID!.uuidString
        print(uuidString)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Stock")
        fetchRequest.predicate = NSPredicate(format: "id = %@", uuidString)
        fetchRequest.returnsObjectsAsFaults = false
        print(secilenUrunType)
        print(secilenUrunUUID!)
        print(TypeLists)
        do{
            let sonuclar = try context.fetch(fetchRequest)
            if sonuclar.count > 0{
                for sonuc in sonuclar as! [NSManagedObject]{
                    if sonuc.value(forKey: "id") is UUID{
                        context.delete(sonuc)
                        do{
                            try context.save()
                        }catch{
                            
                        }
                        break
                    }
                }
            }
        }catch{
            print("hata")
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Veri3Girildi"), object: nil)
        self.navigationController?.popViewController(animated: true)
        

        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toDetailsVC"{
            print("aaaaaa")
            let destinationVC = segue.destination as! ViewController
            destinationVC.secilenUrun = secilenUrunType
            destinationVC.secilenUUID = secilenUrunUUID
            destinationVC.self.tableView.reloadData()
        }
        
    }
    
    

    
    
}
