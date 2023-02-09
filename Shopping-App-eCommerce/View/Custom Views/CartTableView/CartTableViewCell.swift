//
//  CartTableViewCell.swift
//  Shopping-App-eCommerce
//
//  Created by Osman Emre Ömürlü on 4.02.2023.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productQuantity: UILabel!
    
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    
    var quantity = 1 {
        didSet {
            if quantity <= 1 {
                quantity = 1
            } else if quantity > 10 {
                quantity = 10
            }
            self.productQuantity.text = String(quantity)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        quantity = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func minusButtonPressed(_ sender: UIButton) {
        quantity -= 1
//        productQuantity.text = "\(quantity)"
    }
    
    @IBAction func plusButtonPressed(_ sender: UIButton) {
        quantity += 1
//        productQuantity.text = "\(quantity)"
        //firestoredaki quantuty++
    }
    
    
}







////Ben tableViewCell'deki quantity miktari degisince, bu degisen urunun id'sini ve quantity miktarini 'updateCart' fonksiyonunda cagirmayi dusundum. Boylece totalCartCost miktarini guncellemek istiyorum. Bunu nasil yapabilirim? illaki 'updateCart' fonksiyonunu kullanmaya gerek yok. Fonksiyon kullanmadan da yapilabiliyorsa yapar misin? Turkce yazarsan sevinirim.
//
////Boyle bir custom ui xib dosyam var.
//class CartTableViewCell: UITableViewCell {
//
//    @IBOutlet weak var productImageView: UIImageView!
//    @IBOutlet weak var productTitleLabel: UILabel!
//    @IBOutlet weak var productPriceLabel: UILabel!
//    @IBOutlet weak var productQuantity: UILabel!
//
//    private var quantity = 1 {
//        didSet {
//            if quantity <= 1 {
//                quantity = 1
//            } else if quantity > 10 {
//                quantity = 10
//            }
//            productQuantity.text = String(quantity)
//        }
//    }
//}

////Bu alttaki de CartViewController dosyasi.
//import UIKit
//import Firebase
//import FirebaseAuth
//import FirebaseFirestore
//import SDWebImage
//import Alamofire
//
//
//class CartViewController: UIViewController {
//
//    //MARK: - Properties
//    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var totalPriceLabel: UILabel!
//
//    private let database = Firestore.firestore()
//    private let currentUser = Auth.auth().currentUser
//    private let currentUserUid = Auth.auth().currentUser?.uid
//
////    var cartCost: Double?
////    var cart: [String : Int]? = [:]
//
//    var totalCartCost: Double = 0
//
//    static var cartItems: [ProductModel] = []
//
//    var productIdArray: [Int] = []
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        tableViewSetup()
//
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        fetchCartIDFromFirestore()
//        print(productIdArray)
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        CartViewController.cartItems = []
//    }
//
//    @IBAction func checkoutButtonPressed(_ sender: UIButton) {
//        //to-do
//    }
//
//    //MARK: - Functions
//    func tableViewSetup() {
//        tableView.register(UINib(nibName: K.TableView.cartTableViewCell, bundle: nil), forCellReuseIdentifier: K.TableView.cartTableViewCell)
//        tableView.rowHeight = CGFloat(160)
//    }
//
//
//    func fetchItemsFromAPI(selectedId: Int) {
//        print("fetchItemsFromAPI WORKING. FETCHING: \(selectedId)")
//        AF.request("\(K.Network.baseURL)/\(selectedId)").response { response in
//       switch response.result {
//       case .success(_):
//           do {
//               let productData = try JSONDecoder().decode(ProductData.self, from: response.data!)
//                   CartViewController.cartItems.append(ProductModel(id: productData.id, title: productData.title, price:Float(productData.price), image: productData.image, rate: Float(productData.rating.rate), category: productData.category, description: productData.description, count: productData.rating.count))
//
//               //Urunleri fiyatina gore siralar.
//               CartViewController.cartItems.sort(by: { $0.price! < $1.price! })
//
//               DispatchQueue.main.async {
//                   self.tableView.reloadData()
//                   self.totalCartCost += productData.price
//                   self.totalPriceLabel.text = "$\(self.totalCartCost)"
//               }
//               } catch
//               let error {
//                   print("DECODING ERROR:",error)
//               }
//            case .failure(let error):
//            print("NETWORK ERROR: ",error)
//           }
//       }
//    }
//
//    func fetchCartIDFromFirestore() {
//        print("fetchCartIDFromFirestore WORKING")
//        //itemler firestore'dan cekilecek
//        database.collection("users").document(currentUserUid!).collection("cart").getDocuments { (querySnapshot, error) in
//            if let error = error {
//                print("ERROR FETCHING DATA FROM FIRESTORE")
//                DuplicateFuncs.alertMessage(title: "Error", message: error.localizedDescription, vc: self)
//            } else {
//                self.productIdArray = []
//                for docx in querySnapshot!.documents {
//                    let productId = docx.data()["productId"] as! Int
//                    self.productIdArray.append(productId)
//                    self.fetchItemsFromAPI(selectedId: productId)
//                    print("APPEND", docx.data()["productId"] as? Int ?? 0)
//                    print("ARRAY ON FUNC", self.productIdArray)
//                }
//            }
//        }
//    }
//
//    func updateCart(productId: Int, quantity: Int) {
//        //sepette quantity degisirse bu fonksiyon cagiralacak.
//        //sepette urun varsa eskisinin ustune ekleme burada mi yapilcak??? = evet update yapcaz.
//        //delete yapilirsa da baska bi fonks yazabiliriz daha anlasilir olmasi icin
//    }
//}
//
//    //MARK: - Extensions
//extension CartViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return CartViewController.cartItems.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: K.TableView.cartTableViewCell, for: indexPath) as! CartTableViewCell
//        let u = CartViewController.cartItems[indexPath.row]
//        cell.productImageView.sd_setImage(with: URL(string: u.image!), placeholderImage: UIImage(named: "placeholderImage.jpg"))
//        cell.productPriceLabel.text = "$\(u.price ?? -1)"
//        cell.productTitleLabel.text = u.title
//        return cell
//    }
//
//
//}
//
//
//
