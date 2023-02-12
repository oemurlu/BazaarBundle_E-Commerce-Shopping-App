//
//  CartViewController.swift
//  Shopping-App-eCommerce
//
//  Created by Osman Emre Ömürlü on 3.02.2023.
//

//listener eklencek, quantity degisirse


import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import SDWebImage
import Alamofire


class CartViewController: UIViewController {

    //MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    let database = Firestore.firestore()
    private let currentUser = Auth.auth().currentUser
    let currentUserUid = Auth.auth().currentUser?.uid
    
    var totalCartCost: Double = 0
    var cart: [String: Int]? = [:]
    
    static var cartItems: [ProductModel] = []

    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSetup()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchCardProductsFromFirestore()
        
//        updateCart(productId: 2, quantity: 1)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        CartViewController.cartItems = []
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
    
    func fetchItemsFromAPI(cart: [String: Int]?)  {
        print("api func working")
        if let cart = cart {
            for (id, quantity) in cart {
                AF.request("\(K.Network.baseURL)/\(id)").response { response in
                    switch response.result {
                    case .success(_):
                        do {
                            let productData = try JSONDecoder().decode(ProductData.self, from: response.data!)
                            CartViewController.cartItems.append(ProductModel(id: productData.id, title: productData.title, price:Float(productData.price), image: productData.image, rate: Float(productData.rating.rate), category: productData.category, description: productData.description, count: productData.rating.count))
                            
                            DispatchQueue.main.async {
                                self.totalCartCost += productData.price * Double(quantity)
                                self.totalPriceLabel.text = "$\(self.totalCartCost)"
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
        }
    }
    
    func fetchCardProductsFromFirestore() {
        let userRef = database.collection("users").document(currentUserUid!)
        userRef.getDocument { (snapshot, error) in
            if let snapshot = snapshot, snapshot.exists {
                if let data = snapshot.data() {
                    for (key, value) in data {
                        if let value = value as? Int {
                            self.cart?[key] = value
//                            print(self.cart!)
                            self.fetchItemsFromAPI(cart: [key : value])
                        } else {
                            fatalError("The value for key: \(key) is not an Int")
                        }
                    }
                } else {
                    print("The document is empty")
                    DuplicateFuncs.alertMessage(title: "Caution", message: "Your cart is empty.", vc: self)
                }
            } else {
                DuplicateFuncs.alertMessage(title: "Server Error", message: "connection issue", vc: self)
            }
        }
    }
    
    
//    func listener() {
//
//        database.collection("users").document(currentUserUid!)
//            .addSnapshotListener { documentSnapshot, error in
//                guard let document = documentSnapshot else {
//                    print("Error fetching documents: \(error!)")
//                    return
//                }
//                guard let data = document.data() else {
//                    print("Document data was empty.")
//                    return
//                }
//                print("Current data: \(data)")
//
//                //ui guncellenmeli listener tetiklenince
//                CartViewController.cartItems = []
//                self.totalCartCost = 0
//
//            }
//    }
    
    
//    func getProductIndexPath(productId: Int) -> IndexPath {
//        let index = CartViewController.cartItems.firstIndex { product in
//            product.id == productId
//        }
//        if let index = index {
//            return IndexPath(row: index, section: 0)
//        }
//        return IndexPath()
//    }
    
    
//    func updateCart(productId: Int, quantity: Int) {
//        guard let currentUser = currentUser else { return }
//
//        let userRef = database.collection("users").document(currentUserUid!)
//
//        if quantity > 0 {
//            userRef.setData(["cart.\(productId)" : quantity]) { error in
//                if let error = error {
//                    print("yeni error: \(error.localizedDescription)")
//                } else {
//                    print("yeni success")
//                }
//            }
//        } else {
//            userRef.updateData(["cart.\(productId)" : FieldValue.delete()]) { error in
//                if let error = error {
////                    self.delegate?.didOccurError(error)
//                } else {
////                    self.delegate?.didUpdateCartSuccessful(quantity: 0)
//                }
//            }
//        }
//
//    }
    
}

    //MARK: - Extensions
extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CartViewController.cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.TableView.cartTableViewCell, for: indexPath) as! CartTableViewCell
        let u = CartViewController.cartItems[indexPath.row]
        cell.productImageView.sd_setImage(with: URL(string: u.image!), placeholderImage: UIImage(named: "placeholderImage.jpg"))
        cell.productPriceLabel.text = "$\(u.price ?? -1)"
        cell.productTitleLabel.text = u.title
        cell.productQuantity.text = "\(cell.quantity)"
        return cell
    }
}



