//
//  CartViewController.swift
//  Shopping-App-eCommerce
//
//  Created by Osman Emre Ömürlü on 3.02.2023.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import SDWebImage
import Alamofire


class CartViewController: UIViewController {
    
    //MARK: - Properties
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    private let database = Firestore.firestore()
    private let currentUser = Auth.auth().currentUser
    let currentUserUid = Auth.auth().currentUser?.uid
    
    var totalCartCost: Double = 0
    var cart: [String: Int]? = [:]
    
    static var cartItems: [ProductModel] = []
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        listener()
        tableViewSetup()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        totalCartCost = 0
    }
    
    
    //MARK: - bsi bsi handlers DUZELTILECEK BURASI
    @IBAction func checkoutButtonPressed(_ sender: UIButton) {
        //to-do
    }
    
    //MARK: - Functions
    func tableViewSetup() {
        tableView.register(UINib(nibName: K.TableView.cartTableViewCell, bundle: nil), forCellReuseIdentifier: K.TableView.cartTableViewCell)
        tableView.rowHeight = CGFloat(160)
    }
    
    func fetchItemsFromAPI(productId: String, quantity: Int)  {
        print("api func working")
        AF.request("\(K.Network.baseURL)/\(productId)").response { response in
            switch response.result {
            case .success(_):
                do {
                    let productData = try JSONDecoder().decode(ProductData.self, from: response.data!)
                    CartViewController.cartItems.append(ProductModel(id: productData.id, title: productData.title, price:Float(productData.price), image: productData.image, rate: Float(productData.rating.rate), category: productData.category, description: productData.description, count: productData.rating.count, quantityCount: quantity))
                    
                    //Urunleri fiyatina gore siralar.
                    CartViewController.cartItems.sort(by: { $0.price! < $1.price! })
                    self.totalCartCost += productData.price * Double(quantity)
                    self.totalPriceLabel.text = "$\(self.totalCartCost)"

                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch let error {
                    print("Decoding error: \(error)")
                }
            case .failure(let error):
                DuplicateFuncs.alertMessage(title: "Network error", message: error.localizedDescription, vc: self)
            }
        }
    }
    
    func listener() {
        print("listener working")
        database.collection("users").document(currentUserUid!).addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching documents: \(error!)")
                return
            }
//            guard let data = document.data() else {
//                print("Document data was empty.")
//                return
//            }

            if let data = document.data() {
                print("data: \(data)")
                self.isCartEmptyOnFirestore { isEmpty in
                    if isEmpty {
                        print("isEmpty")
                        self.totalCartCost = 0
                        self.totalPriceLabel.text = "$\(self.totalCartCost)"
                        self.tableView.reloadData()
                    } else {
                        print("isEmpty else")
                        for productId in data.keys {
                            let productQuantity = data[productId]
                            self.fetchItemsFromAPI(productId: productId, quantity: productQuantity as! Int)
                        }
                    }
                }
            } else {
                print("data else")
                self.totalCartCost = 0
            }
            
            print("data else cikisi")
            CartViewController.cartItems = []
            self.totalCartCost = 0
            
//            self.isCartEmptyOnFirestore { isEmpty in
//                if isEmpty {
//                    print("isEmpty")
//                    self.totalCartCost = 0
//                    self.totalPriceLabel.text = "$\(self.totalCartCost)"
//                    self.tableView.reloadData()
//                } else {
//                    print("isEmpty else")
//                    for productId in data.keys {
//                        let productQuantity = data[productId]
//                        self.fetchItemsFromAPI(productId: productId, quantity: productQuantity as! Int)
//                    }
//                }
//            }
        }
    }
    
    func isCartEmptyOnFirestore(completion: @escaping (Bool) -> Void) {
        let docRef = self.database.collection("users").document(self.currentUserUid!)
        docRef.getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                
                if data!.isEmpty {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    @objc func minusButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        let id = CartViewController.cartItems[index].id
        updateProductQuantityOnFirestore(productId: id!, increment: false)
    }
    
    @objc func plusButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        let id = CartViewController.cartItems[index].id
        updateProductQuantityOnFirestore(productId: id!, increment: true)
    }
    
    func updateProductQuantityOnFirestore(productId: Int, increment: Bool) {
        let userRef = database.collection("users").document(currentUserUid!)
        
        userRef.getDocument { document, error in
            guard let document = document else { return }
            let currentQuantity = document.data()!["\(productId)"] as! Int
            let updatedQuantity = currentQuantity
            
            if increment {
                if updatedQuantity < 10 {
                    userRef.updateData(["\(productId)": FieldValue.increment(Int64(1))]) { error in
                        if let _ = error {
                            DuplicateFuncs.alertMessage(title: "ERROR", message: "Product quantity could not be changed", vc: self)
                        }
                    }
                }
            } else {
                if updatedQuantity > 1 {
                    userRef.updateData(["\(productId)": FieldValue.increment(Int64(-1))]) { error in
                        if let _ = error {
                            DuplicateFuncs.alertMessage(title: "ERROR", message: "Product quantity could not be changed", vc: self)
                        }
                    }
                }
            }
        }
    }
}

//MARK: - Extensions
extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count: \(CartViewController.cartItems.count)")
        for item in CartViewController.cartItems {
            print("id: ", item.id!)
        }
        return CartViewController.cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.TableView.cartTableViewCell, for: indexPath) as! CartTableViewCell
        let u = CartViewController.cartItems[indexPath.row]
        cell.productImageView.sd_setImage(with: URL(string: u.image!), placeholderImage: UIImage(named: "placeholderImage.jpg"))
        cell.productPriceLabel.text = "$\(u.price ?? -1)"
        cell.productTitleLabel.text = u.title
        cell.productQuantity.text = "\(String(describing: u.quantityCount!))"
        
        cell.plusButton.tag = indexPath.row
        cell.plusButton.addTarget(self, action: #selector(plusButtonTapped(_:)), for: .touchUpInside)
        
        cell.minusButton.tag = indexPath.row
        cell.minusButton.addTarget(self, action: #selector(minusButtonTapped(_:)), for: .touchUpInside)
        
        return cell
    }
}

extension CartViewController: UITableViewDelegate {
    //Disable cell click behavior
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let productId = CartViewController.cartItems[indexPath.row].id
            print(productId!)
            let docRef = database.collection("users").document(currentUserUid!)
            docRef.updateData(["\(String(describing: productId!))": FieldValue.delete()]) { error in
                if let error = error {
                    DuplicateFuncs.alertMessage(title: "Error", message: "Product could not be deleted.", vc: self)
                    print("Product deletion error: \(error.localizedDescription)")
                } else {
                    DuplicateFuncs.alertMessage(title: "Sucess", message: "Product deleted.", vc: self)
                }
            }
        }
    }
}
