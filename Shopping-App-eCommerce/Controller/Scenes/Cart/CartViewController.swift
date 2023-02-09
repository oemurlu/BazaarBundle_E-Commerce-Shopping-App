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
    private let currentUserUid = Auth.auth().currentUser?.uid
    
    var totalCartCost: Double = 0
    
//    static var selectedIndex = 0
    
    static var cartItems: [ProductModel] = []
    
//    var productIdArray: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSetup()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchCartIDFromFirestore()
//        print(productIdArray)
        listener()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        CartViewController.cartItems = []
        totalCartCost = 0
    }
    
    @IBAction func checkoutButtonPressed(_ sender: UIButton) {
        //to-do
    }
    
    
    
    
    //MARK: - Functions
    func tableViewSetup() {
        tableView.register(UINib(nibName: K.TableView.cartTableViewCell, bundle: nil), forCellReuseIdentifier: K.TableView.cartTableViewCell)
        tableView.rowHeight = CGFloat(160)
    }
    
    
    func fetchItemsFromAPI(selectedId: Int, quantity: Int) {
//        print("fetchItemsFromAPI WORKING. FETCHING: \(selectedId)")
        AF.request("\(K.Network.baseURL)/\(selectedId)").response { response in
       switch response.result {
       case .success(_):
           do {
               let productData = try JSONDecoder().decode(ProductData.self, from: response.data!)
                   CartViewController.cartItems.append(ProductModel(id: productData.id, title: productData.title, price:Float(productData.price), image: productData.image, rate: Float(productData.rating.rate), category: productData.category, description: productData.description, count: productData.rating.count))
            
               //Urunleri fiyatina gore siralar.
               CartViewController.cartItems.sort(by: { $0.price! < $1.price! })
               
               //urunlerin fiyatlarini totalCartCost'a ekler.
//               self.totalCartCost += productData.price // * Double(productData.count)
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
    
    func fetchCartIDFromFirestore() {
        CartViewController.cartItems = []
//        print("fetchCartIDFromFirestore WORKING")
        //itemler firestore'dan cekilecek
        database.collection("users").document(currentUserUid!).collection("cart").getDocuments { (querySnapshot, error) in
            if let error = error {
//                print("ERROR FETCHING DATA FROM FIRESTORE")
                DuplicateFuncs.alertMessage(title: "Error", message: error.localizedDescription, vc: self)
            } else {
//                self.productIdArray = []
                for docx in querySnapshot!.documents {
                    let productId = docx.data()["productId"] as! Int
                    let productQuantity = docx.data()["productQuantity"] as! Int
                    
//                    self.productIdArray.append(productId)
                    self.fetchItemsFromAPI(selectedId: productId, quantity: productQuantity)
//                    print("APPEND", docx.data()["productId"] as? Int ?? 0)
//                    print("ARRAY ON FUNC", self.productIdArray)
                }
            }
        }
    }
    
    func updateCart(productId: Int, quantity: Int) {
        //sepette quantity degisirse bu fonksiyon cagiralacak.
        //sepette urun varsa eskisinin ustune ekleme burada mi yapilcak??? = evet update yapcaz.
        //delete yapilirsa da baska bi fonks yazabiliriz daha anlasilir olmasi icin
    }
    
    func updateUI() {
        self.totalPriceLabel.text = "$\(self.totalCartCost)"
        self.tableView.reloadData()
    }
    
    
    func listener() {
        database.collection("users").document(currentUserUid!).collection("cart")
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                let cities = documents.map { $0["productQuantity"]! }
                print("Current cities in CA: \(cities)")
                //ui fiyat guncellemesi
                self.fetchCartIDFromFirestore()
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


