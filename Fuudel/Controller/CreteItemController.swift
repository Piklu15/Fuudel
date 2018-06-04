//
//  CreteItemController.swift
//  Fuudel
//
//  Created by Piklu on 28/5/18.
//  Copyright © 2018 Zert Interactive. All rights reserved.
//

import UIKit
protocol CreateItemControllerDelegate: class{
    func createItemControllerDidTapOnCreate(_ newItem:FuudelModel)
}

class CreteItemController: UIViewController {

    @IBOutlet weak var productName: AUIAutoGrowingTextView!
    weak var createItemDelegate:CreateItemControllerDelegate?
    
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var productDescriptionTextView: AUIAutoGrowingTextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.productName.maxHeight = 60.0
        self.productDescriptionTextView.maxHeight = 100.0

        // Do any additional setup after loading the view.
    }
    
    @IBAction func submitToCreate(_ sender: UIButton) {

//        guard let price = Double("\(self.priceTextField.text ?? "0.0")") , let productName = self.productName.text , let prouductDescription = self.productDescriptionTextView.text else {
//            return
//        }
        
        guard let productName = productName.text, !productName.isEmpty else{
            showAlertWith(alertTitle: "😉😉😉 !", alertMessage: "Product name field required")
            return
        }
        
        guard let productDescrioption = productDescriptionTextView.text, !productDescrioption.isEmpty else{
            showAlertWith(alertTitle: "😉😉😉 !", alertMessage: "Product description field required")
            return
        }
        
        
        guard let price = Double("\(self.priceTextField.text ?? "0.0")") else {
            showAlertWith(alertTitle: "😉😉😉 !", alertMessage: "Decimal value required for Price Field")
            return
        }

        
        let fuddelItem = FuudelModel(ProductName: productName, SDetails: productDescrioption, Price:price)
        
        self.createItemDelegate?.createItemControllerDidTapOnCreate(fuddelItem)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
           self.dismissController()
        }

        
    }
    
    func dismissController(){
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func showAlertWith(alertTitle:String, alertMessage:String) {
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        let doneAction = UIAlertAction(title: "Done", style: .default) { (action) in
            
        }
        
        alertController.addAction(doneAction)
        
        self .present(alertController, animated: true, completion: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
