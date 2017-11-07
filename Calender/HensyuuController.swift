






//  EditController.swift
//  Calender
//
//  Created by Hazuki♪ on 2/4/17.
//  Copyright © 2017 hazuki. All rights reserved.
//

import UIKit
import RealmSwift
import Photos

class HensyuuController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITextViewDelegate {
    
    @IBOutlet weak var datepicker: UIDatePicker!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet var textView: UITextView!
    @IBOutlet var haikei: UIImageView!
    
    var colorNum:Int = 0
    let colorManager = ColorManeger()
    
    var userDefaults:UserDefaults = UserDefaults.standard
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    
    func textViewShouldReturn(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        if userDefaults.object(forKey: "COLOR") != nil {
            colorNum = userDefaults.object(forKey: "COLOR") as! Int
        }
        haikei.backgroundColor = colorManager.mainColor()[colorNum]
        textField.delegate = self
        textView.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //非表示にする。
        if(textView.isFirstResponder){
            textView.resignFirstResponder()
        }else if(textField.isFirstResponder){
            textField.resignFirstResponder()
        }
        
    }
    
    
    
    
    @IBAction func picture() {
        //        //UIImagePicker Controllerのインスタンスを作る
        //        let imagePickerController: UIImagePickerController = UIImagePickerController()
        //
        //        //フォトライブラリを使う設定をする
        //        imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        //        imagePickerController.delegate = self
        //        imagePickerController.allowsEditing = true
        //
        //
        //      //  imagePickerController= [NSForegroundColorAttributeName : UIColor.greenColor()]
        //
        //        //フォトライブラリを呼び出す
        //        self.present(imagePickerController, animated: true, completion: nil)
        
        let sourceType:UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.photoLibrary
        // カメラが利用可能かチェック
        //if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
        // インスタンスの作成
        let cameraPicker = UIImagePickerController()
        cameraPicker.sourceType = sourceType
        cameraPicker.delegate = self
        self.present(cameraPicker, animated: true, completion: nil)
        
        //}
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
    }
    //フォトライブラリから画像の選択が終わったら呼ばれるメソッド
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //imageに選んだ画像を表示する
        let image: UIImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        
        //そのimageを背景に設定する
        haikei.image = image
        
        //フォトライブラリを閉じる
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapScreen(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func add() {
        
        //アラート
        let alert:UIAlertController = UIAlertController(title: "OK", message: "saved diary",preferredStyle: .alert)
        //OKボタン
        alert.addAction(UIAlertAction(title: "got it",
                                      style: UIAlertActionStyle.default,
                                      handler: {action in
                                        //ボタンが押されたら
                                        
                                        // STEP.1 Realmを初期化
                                        let realm = try! Realm()
                                        
                                        //STEP.2 保存する要素を書く
                                        let diary = Diary()
                                        let calendar = Calendar.current
                                        //                let component = (calendar as NSCalendar).components([NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day, NSCalendar.Unit.hour, NSCalendar.Unit.minute, NSCalendar.Unit.second], from: self.datepicker.date)
                                        //
                                        let component = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self.datepicker.date)
                                        
                                        diary.date = Int("\(component.year!)\(component.month!)\(component.day!)")!
                                        diary.iddate = String(describing: Date())
                                        
                                        diary.main = self.textView.text
                                        diary.title = self.textField.text!
                                        if let photo = self.haikei.image
                                        {
                                            diary.photo = NSData(data: UIImagePNGRepresentation(photo)!) as Data
                                        }
                                        
                                        
                                        //STEP.3 Realmに書き込み
                                        try! realm.write {
                                            realm.add(diary, update: true)
                                        }
                                        
                                        
                                        self.navigationController?.popViewController(animated: true)
                                        self.dismiss(animated: true, completion: nil)
                                        
        }
            )
        )
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func delete () {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    var date: String!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // dateLabel.text = date
        if userDefaults.object(forKey: "COLOR") != nil {
            colorNum = userDefaults.object(forKey: "COLOR") as! Int
            
        }
        haikei.backgroundColor = colorManager.mainColor()[colorNum]
        self.configureObserver()
        
        //        userDefaults.set(diary.title, forKey: "title")
        //        userDefaults.set(String("\(year!),　\(month!),　\(date!)"), forKey: "date")
        //        userDefaults.set(diary.title, forKey: "main")
        //        userDefaults.set(data, forKey: "picture")
        //お手本→取り出したいもの = saveData.object(forKey: "")
        
        if userDefaults.object(forKey: "title") != nil{
            
            textField.text = userDefaults.object(forKey: "title") as! String
            
        }
        
        if userDefaults.object(forKey: "date") != nil {
            
            let dateString = userDefaults.object(forKey: "date")  as! String
            let formatter: DateFormatter = DateFormatter()
            formatter.dateFormat = "yyyy, MM, dd"
            datepicker.date = formatter.date(from: dateString)!
        }
        //     datepicker. = userDefaults.object(forKey: "date")  as! String
        
        
        //日付のdataをStringに変換
        
        if userDefaults.object(forKey: "main") != nil {
        
            textView.text = userDefaults.object(forKey: "main") as! String
        }
        
        if userDefaults.object(forKey:"piture") != nil {
            haikei.image = UIImage(data: userDefaults.object(forKey:"piture") as! Data)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated) //エフェクト関係のパラメタだと思うが、今回は使用しないので、基底クラスを呼び出して、終わり。
        var _: AppDelegate = UIApplication.shared.delegate as! AppDelegate //AppDelegateオブジェクトの呼び出し。as ◯◯はSwiftのキャスト表現
        //appDelegate.ViewVal = textField.text! // TextFieldの値を取得し、値引き渡し用のプロパティにセット
        
        self.removeObserver()
    }
    // Notificationを設定
    func configureObserver() {
        
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notification.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // Notificationを削除
    func removeObserver() {
        
        let notification = NotificationCenter.default
        notification.removeObserver(self)
    }
    
    // キーボードが現れた時に、画面全体をずらす。
    func keyboardWillShow(notification: Notification?) {
        
        if(textView.isFirstResponder){
            let rect = (notification?.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
            let duration: TimeInterval? = notification?.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double
            UIView.animate(withDuration: duration!, animations: { () in
                let transform = CGAffineTransform(translationX: 0, y: -(rect?.size.height)!)
                self.view.transform = transform
                
            })
        }
        
    }
    
    // キーボードが消えたときに、画面を戻す
    func keyboardWillHide(notification: Notification?) {
        
        let duration: TimeInterval? = notification?.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? Double
        UIView.animate(withDuration: duration!, animations: { () in
            
            self.view.transform = CGAffineTransform.identity
        })
    }
    
}