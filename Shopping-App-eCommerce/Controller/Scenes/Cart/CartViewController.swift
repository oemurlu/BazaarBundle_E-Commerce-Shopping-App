//
//  BasketViewController.swift
//  Shopping-App-eCommerce
//
//  Created by Osman Emre Ömürlü on 3.02.2023.
//

// 1- product id’lerini cek ve productId’ye append et. (fetchCardIDFromFirestore)
// 2 - productId’de olan id’ler ile api’den verileri cek. cartItems’e nesne olarak ekle.
// 3- cellForRowAt’de cartItems’deki nesneler ile tableViewDoldur.



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
    
    private let database = Firestore.firestore()
    private let currentUser = Auth.auth().currentUser
    private let currentUserUid = Auth.auth().currentUser?.uid
    
    var cartCost: Double?
    var cart: [String : Int]? = [:]
    
    var cartItems: [CartItem] = []
    
    var productIdArray: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSetup()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchCartIDFromFirestore()
//        fetchItemsFromAPI(selectedId: selectedIds)
//        print("cartItems: ", cartItems)
        print(productIdArray)
    }
    
    
    
    @IBAction func checkoutButtonPressed(_ sender: UIButton) {
        //to-do
    }
    
    //MARK: - Functions
    func tableViewSetup() {
        tableView.register(UINib(nibName: K.TableView.cartTableViewCell, bundle: nil), forCellReuseIdentifier: K.TableView.cartTableViewCell)
    }
    
    func fetchItemsFromAPI(selectedId: Int) {
        print("fetchItemsFromAPI WORKING")
        AF.request("\(K.Network.baseURL)/\(selectedId)").response { response in
       switch response.result {
       case .success(_):
           do {
               let productData = try JSONDecoder().decode(ProductData.self, from: response.data!)
               DispatchQueue.main.async {
                   
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
    
    func fetchCartIDFromFirestore() {
        print("fetchCartIDFromFirestore WORKING")
        //itemler firestore'dan cekilecek
        database.collection("users").document(currentUserUid!).collection("cart").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("ERROR FETCHING DATA FROM FIRESTORE")
                DuplicateFuncs.alertMessage(title: "Error", message: error.localizedDescription, vc: self)
            } else {
                self.productIdArray = []
                for docx in querySnapshot!.documents {
                    let productId = docx.data()["productId"] as! Int
                    self.productIdArray.append(productId)
                    self.fetchItemsFromAPI(selectedId: productId)
                    print("APPEND", docx.data()["productId"] as? Int ?? 0)
                    print("ARRAY ON FUNC", self.productIdArray)
//                    for x in self.cartItems {
//                        print(x.productId)
//                        self.fetchItemsFromAPI(selectedId: x.productId)
                        
//                    }

//                    let productId = docx.data()["productId"] as? Int ?? 0
//                    var productQuantity = docx.data()["productQuantity"] as? Int ?? 0
//                    self.cartItems = []
//                    let item = CartItem(productId: productId)
//                    self.cartItems.append(item)
                }
            }
        }
    }
    //Bu kodu yazinca 'for docx in querySnapshot!.documents {' satirinda 'Value of type 'DocumentSnapshot' has no member 'documents'' hatasi aliyorum. Firestore'da bir dokumandaki koleksiyonun icindeki verileri nasil cekerim. Swift dili ile yaziyorum ve turkce yazmani istiyorum.
    
    func updateCart(productId: Int, quantity: Int) {
        //sepette quantity degisirse bu fonksiyon cagiralacak.
        //sepette urun varsa eskisinin ustune ekleme burada mi yapilcak??? = evet update yapcaz.
        //delete yapilirsa da baska bi fonks yazabiliriz daha anlasilir olmasi icin
    }
    
    
}

    //MARK: - Extensions
extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.TableView.cartTableViewCell) as! CartTableViewCell
        let u = cartItems[indexPath.row]
//        for x in cartItems {
//            cell.productPriceLabel.text = x.
//        }
        cell.productImageView.sd_setImage(with: URL(string: ""), placeholderImage: UIImage(named: "placeholderImage.jpg"))
        return cell
    }
    
    
}
