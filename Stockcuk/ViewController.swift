//
//  ViewController.swift
//  Stockcuk
//
//  Created by Erkan on 27.11.2022.
//

import UIKit
import CoreData


class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, UISearchResultsUpdating {

    
    
    
    var stockList = [Stock]()
    var sabit = 0
    var idLists = [UUID]()
    var typeLists = [String]()
    var secilenUrun = ""
    var secilenUUID : UUID?
    let searchController = UISearchController()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(artiButton))
        
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        //title = "Search"
        //searchController.searchResultsUpdater = self
        //navigationItem.searchController = searchController
        //tableView.deleteRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        //self.deleteData()
        fetchStock()
        
    }
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else{
            return
        }
        print(text)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(fetchStock), name: NSNotification.Name(rawValue: "VeriGirildi"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(fetchStock), name: NSNotification.Name(rawValue: "Veri2Girildi"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(fetchStock), name: NSNotification.Name(rawValue: "Veri3Girildi"), object: nil)
    }
    
    

    
    @objc func fetchStock(){
        typeLists.removeAll(keepingCapacity: false)
        idLists.removeAll(keepingCapacity: false)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Stock")
        fetchRequest.returnsObjectsAsFaults = false
        
        do{
            let sonuclar = try context.fetch(fetchRequest)
            for sonuc in sonuclar as! [NSManagedObject]{
                if let type = sonuc.value(forKey: "type") as? String{
                    typeLists.append(type)
                }
                if  let id = sonuc.value(forKey: "id") as? UUID{
                    idLists.append(id)
                }
                    
            }
            tableView.reloadData()
            
        }catch{
            print("hata var")
        }
        
        
    }
    
    
    
    @objc func artiButton(){
        secilenUrun = ""
        performSegue(withIdentifier: "toSecondVC", sender: nil)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return typeLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        //let stockData = stockList[indexPath.row]
        //cell.labelCell.text = stockData.type
        cell.labelCell.text = typeLists[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toDetailsVC"{
            let destinationVC = segue.destination as! DetailsViewController
            destinationVC.secilenUrunType = secilenUrun
            destinationVC.secilenUrunUUID = secilenUUID
            destinationVC.TypeLists = typeLists
        }
        
    }
    func deleteData() {
        let appDel:AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let context:NSManagedObjectContext = appDel.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Stock")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchRequest)
            for managedObject in results {
                if let managedObjectData: NSManagedObject = managedObject as? NSManagedObject {
                    context.delete(managedObjectData)
                }
            }
        } catch let error as NSError {
            print("Deleted all my data in myEntity error : \(error) \(error.userInfo)")
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        secilenUrun = typeLists[indexPath.row]
        secilenUUID = idLists[indexPath.row]
        
        print(indexPath.row)
        print(indexPath)
        print(secilenUUID)
        
        
        print(secilenUUID)
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let uuidString = idLists[indexPath.row].uuidString
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Stock")
            fetchRequest.predicate = NSPredicate(format: "id = %@", uuidString)
            fetchRequest.returnsObjectsAsFaults = false
            
            
            do{
                let sonuclar = try context.fetch(fetchRequest)
                if sonuclar.count > 0{
                    for sonuc in sonuclar as! [NSManagedObject]{
                        if sonuc.value(forKey: "id") is UUID{
                            context.delete(sonuc)
                            typeLists.remove(at: indexPath.row)
                            idLists.remove(at: indexPath.row)
                            self.tableView.reloadData()
                            
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
            
        }
    }
    
    
}

