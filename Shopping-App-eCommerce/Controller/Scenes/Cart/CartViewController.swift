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
//        fetchCartProductsFromFirestore()
        updateCart(productId: 2, quantity: 1)
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
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        let silinecekDocument = CartViewController.cartItems[indexPath.row].id
//        database.collection("users").document(currentUserUid!).collection("cart").document("\(silinecekDocument!)").delete { error in
//            if let error = error {
//                DuplicateFuncs.alertMessage(title: "ERROR", message: "Error removing document", vc: self)
//            } else {
////                CartViewController.cartItems.remove(at: indexPath.row)
////                tableView.deleteRows(at: [indexPath], with: .automatic)
//                CartViewController.cartItems = []
//                DuplicateFuncs.alertMessage(title: "Successfull", message: "Product successfully removed", vc: self)
//            }
//        }
//    }
//
    
    func fetchItemsFromAPI(selectedId: Int, quantity: Int)  {
        print("fetchItemsFromAPI WORKING. FETCHING: \(selectedId)")
        AF.request("\(K.Network.baseURL)/\(selectedId)").response { response in
       switch response.result {
       case .success(_):
           do {
               let productData = try JSONDecoder().decode(ProductData.self, from: response.data!)
                   CartViewController.cartItems.append(ProductModel(id: productData.id, title: productData.title, price:Float(productData.price), image: productData.image, rate: Float(productData.rating.rate), category: productData.category, description: productData.description, count: productData.rating.count))
            
               //Urunleri fiyatina gore siralar.
               CartViewController.cartItems.sort(by: { $0.price! < $1.price! })
               
               //urunlerin fiyatlarini totalCartCost'a ekler.
               self.totalCartCost += productData.price * Double(quantity)
               
               DispatchQueue.main.async {
                   self.updateUI()
               }
               } catch
               let error {
                   print("DECODING ERROR:",error)
               }
            case .failure(let error):
            print("NETWORK ERROR: ",error)
           }
       }
    }
    
    
//    func fetchCartProductsFromFirestore() {
//        print("fetchCartProductsFromFirestore calisiyor..")
//        database.collection("users").document(currentUserUid!).collection("cart").getDocuments { (querySnapshot, error) in
//            if let error = error {
//                print("error getting documents: \(error)")
//                DuplicateFuncs.alertMessage(title: "Server Error", message: error.localizedDescription, vc: self)
//            } else {
//                for document in querySnapshot!.documents {
////                    print("\(document.documentID) ==>> \(document.data())")
//                    if let productId = document.data()["productID"] as? Int, let productQuantity = document.data()["productQuantity"] as? Int {
//                        print("prr: \(productId) ve pq: \(productQuantity)")
////                        self.fetchItemsFromAPI(selectedId: productId, quantity: productQuantity)
//
////                        self.listener(productID: productId, productQuantity: productQuantity)
//                    } else {
//                        print("prr error")
//                    }
//                }
//            }
//        }
//    }
    
    


    func updateUI() {
        self.totalPriceLabel.text = "$\(self.totalCartCost)"
        self.tableView.reloadData()
    }
    
    
    func listenerOnSnapshot() {
        database.collection("users").document(currentUserUid!).collection("cart")
    }
    
    
    
    func listener() {
        
        database.collection("users").document(currentUserUid!)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                }
                print("Current data: \(data)")
                
                //ui guncellenmeli listener tetiklenince
                CartViewController.cartItems = []
                self.totalCartCost = 0

            }
    }
    
    //MARK: - GetProductIndexPath
    
    func getProductIndexPath(productId: Int) -> IndexPath {
        let index = CartViewController.cartItems.firstIndex { product in
            product.id == productId
        }
        if let index = index {
            return IndexPath(row: index, section: 0)
        }
        return IndexPath()
    }
    
    
    func updateCart(productId: Int, quantity: Int) {
        guard let currentUser = currentUser else { return }
        
        let userRef = database.collection("users").document(currentUserUid!)
        
        if quantity > 0 {
            userRef.setData(["cart.\(productId)" : quantity]) { error in
                if let error = error {
                    print("yeni error: \(error.localizedDescription)")
                } else {
                    print("yeni success")
                }
            }
        } else {
            userRef.updateData(["cart.\(productId)" : FieldValue.delete()]) { error in
                if let error = error {
//                    self.delegate?.didOccurError(error)
                } else {
//                    self.delegate?.didUpdateCartSuccessful(quantity: 0)
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
        cell.productImageView.sd_setImage(with: URL(string: u.image!), placeholderImage: UIImage(named: "placeholderImage.jpg"))
        cell.productPriceLabel.text = "$\(u.price ?? -1)"
        cell.productTitleLabel.text = u.title
        
        return cell
    }
}



