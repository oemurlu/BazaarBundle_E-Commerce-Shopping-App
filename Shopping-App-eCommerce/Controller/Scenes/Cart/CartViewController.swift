//
//  CartViewController.swift
//  Shopping-App-eCommerce
//
//  Created by Osman Emre Ömürlü on 3.02.2023.
//

import UIKit
import Firebase
import SDWebImage
import Alamofire

class CartViewController: UIViewController {
    
    //MARK: - Properties
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyCartView: UIView!
    
    private let database = Firestore.firestore()
    private let currentUserUid = Auth.auth().currentUser?.uid
    
    private var totalCartCost: Double = 0
    private var cart: [String: Int]? = [:]
    private var isQuantityButtonTapped = false

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
    
    //MARK: - Interaction handlers
    @IBAction func checkoutButtonPressed(_ sender: UIButton) {
        //to-do
    }
    
    //MARK: - Functions
    func tableViewSetup() {
        tableView.register(UINib(nibName: K.TableView.cartTableViewCell, bundle: nil), forCellReuseIdentifier: K.TableView.cartTableViewCell)
        tableView.rowHeight = CGFloat(160)
    }
    
    func cartBadge(count: Int) {
        if let tabBarController = self.tabBarController {
            if let tabBarItem = tabBarController.tabBar.items?[1] {
                tabBarItem.badgeValue = "\(count)"
            }
        }
    }
    
    func fetchItemsFromAPI(productId: String, quantity: Int)  {
        AF.request("\(K.Network.baseURL)/\(productId)").response { response in
            switch response.result {
            case .success(_):
                do {
                    let productData = try JSONDecoder().decode(ProductData.self, from: response.data!)
                    CartViewController.cartItems.append(ProductModel(id: productData.id, title: productData.title, price:Float(productData.price), image: productData.image, rate: Float(productData.rating.rate), category: productData.category, description: productData.description, count: productData.rating.count, quantityCount: quantity))
                    
                    //Urunleri fiyatina gore siralar.
                    CartViewController.cartItems.sort(by: { $0.price! < $1.price! })
                    
                    //Urun fiyatlarini kac adet ise ona gore totalCartCost'a ekler.
                    self.totalCartCost += productData.price * Double(quantity)
                    let formattedTotalCartCost = String(format: "%.2f", self.totalCartCost)
                    self.totalPriceLabel.text = "$\(formattedTotalCartCost)"
                    
                    //Cart badge
                    self.cartBadge(count: CartViewController.cartItems.count)

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
        database.collection("users").document(currentUserUid!).addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching documents: \(error!)")
                return
            }

            if let data = document.data() {
                self.isCartEmptyOnFirestore { isEmpty in
                    if isEmpty {
                        self.emptyCartView.isHidden = false
                        self.emptyCartView.alpha = 1.0

                        self.tableView.isHidden = true
                        self.tableView.alpha = 0
                        
                        self.totalCartCost = 0
                        let formattedTotalCartCost = String(format: "%.2f", self.totalCartCost)
                        self.totalPriceLabel.text = "$\(formattedTotalCartCost)"
                        self.tableView.reloadData()
                        
                        self.cartBadge(count: 0)
                       
                    } else {
                        self.emptyCartView.isHidden = true
                        
                        self.tableView.isHidden = false
                        self.tableView.alpha = 1.0
                        
                        for productId in data.keys {
                            let productQuantity = data[productId]
                            self.fetchItemsFromAPI(productId: productId, quantity: productQuantity as! Int)
                        }
                    }
                    self.tableView.reloadData()
                }
            } else {
                self.totalCartCost = 0
            }
            
            CartViewController.cartItems = []
            self.totalCartCost = 0
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
    
    //Fonksiyon seri art arda basislarda fatal error (out of range) sebebiyle "Debouncing" mekanizmasi haline getirildi.
    //Bu sayede hizli, cift, art arda tiklamalardan kaynakli sorunlarin onune gecildi.
    @objc func minusButtonTapped(_ sender: UIButton) {
        if isQuantityButtonTapped {
            return
        }
        isQuantityButtonTapped = true
        
        let index = sender.tag
        let id = CartViewController.cartItems[index].id
        updateProductQuantityOnFirestore(productId: id!, increment: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isQuantityButtonTapped = false
        }
    }

    @objc func plusButtonTapped(_ sender: UIButton) {
        if isQuantityButtonTapped {
            return
        }
        isQuantityButtonTapped = true
        
        let index = sender.tag
        let id = CartViewController.cartItems[index].id
        updateProductQuantityOnFirestore(productId: id!, increment: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isQuantityButtonTapped = false
        }
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
        return CartViewController.cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.TableView.cartTableViewCell, for: indexPath) as! CartTableViewCell
        let u = CartViewController.cartItems[indexPath.row]
        cell.productImageView.sd_setImage(with: URL(string: u.image!), placeholderImage: UIImage(systemName: "photo.on.rectangle.angled"))
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
            let docRef = database.collection("users").document(currentUserUid!)
            docRef.updateData(["\(String(describing: productId!))": FieldValue.delete()]) { error in
                if let error = error {
                    DuplicateFuncs.alertMessage(title: "Error", message: "Product could not be deleted", vc: self)
                    print("Product deletion error: \(error.localizedDescription)")
                } else {
                    DuplicateFuncs.alertMessage(title: "Success", message: "Product deleted", vc: self)
                }
            }
        }
    }
}
