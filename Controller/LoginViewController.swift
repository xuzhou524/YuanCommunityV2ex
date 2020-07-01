//
//  LoginViewController.swift
//  YuanCommunityV2ex
//
//  Created by xuzhou on 2020/06/06.
//  Copyright © 2020年 xuzhou. All rights reserved.
//

import UIKit
import Kingfisher
import SVProgressHUD
import Alamofire

public typealias LoginSuccessHandel = (String) -> Void

class LoginViewController: UIViewController {

    var successHandel:LoginSuccessHandel?

    let userNameTextField:UITextField = {
        let userNameTextField = UITextField()
        userNameTextField.autocorrectionType = UITextAutocorrectionType.no
        userNameTextField.autocapitalizationType = UITextAutocapitalizationType.none
        
        userNameTextField.textColor = XZSwiftColor.leftNodeTintColor
        userNameTextField.font = v2Font(15)
        userNameTextField.keyboardType = .asciiCapable
        userNameTextField.placeholder = "用户名"
        userNameTextField.clearButtonMode = .always

        let userNameIconImageView = UIImageView(image: UIImage.init(named: "ic_account_circle"));
        userNameIconImageView.frame = CGRect(x: 0, y: 0, width: 34, height: 22)
        userNameIconImageView.tintColor = XZSwiftColor.leftNodeTintColor
        userNameIconImageView.contentMode = .scaleAspectFit
        let userNameIconImageViewPanel = UIView(frame: userNameIconImageView.frame)
        userNameIconImageViewPanel.addSubview(userNameIconImageView)
        userNameTextField.leftView = userNameIconImageViewPanel
        userNameTextField.leftViewMode = .always
        return userNameTextField
    }()
    let passwordTextField:UITextField = {
        let passwordTextField = UITextField()
        passwordTextField.textColor = XZSwiftColor.leftNodeTintColor
        passwordTextField.font = v2Font(15)
        passwordTextField.keyboardType = .asciiCapable
        passwordTextField.isSecureTextEntry = true
        passwordTextField.placeholder = "密码"
        passwordTextField.clearButtonMode = .always

        let passwordIconImageView = UIImageView(image: UIImage.init(named: "ic_lock"));
        passwordIconImageView.frame = CGRect(x: 0, y: 0, width: 34, height: 22)
        passwordIconImageView.contentMode = .scaleAspectFit
        passwordIconImageView.tintColor = XZSwiftColor.leftNodeTintColor
        let passwordIconImageViewPanel = UIView(frame: passwordIconImageView.frame)
        passwordIconImageViewPanel.addSubview(passwordIconImageView)
        passwordTextField.leftView = passwordIconImageViewPanel
        passwordTextField.leftViewMode = .always
        return passwordTextField
    }()
    let codeTextField:UITextField = {
        let codeTextField = UITextField()
        codeTextField.textColor = XZSwiftColor.leftNodeTintColor
        codeTextField.font = v2Font(15)
        codeTextField.keyboardType = .asciiCapable
        codeTextField.placeholder = "验证码"
        codeTextField.clearButtonMode = .always
        
        let codeTextFieldImageView = UIImageView(image: UIImage.init(named: "ic_vpn_key"));
        codeTextFieldImageView.frame = CGRect(x: 0, y: 0, width: 34, height: 22)
        codeTextFieldImageView.contentMode = .scaleAspectFit
        codeTextFieldImageView.tintColor = XZSwiftColor.leftNodeTintColor
        let codeTextFieldImageViewPanel = UIView(frame: codeTextFieldImageView.frame)
        codeTextFieldImageViewPanel.addSubview(codeTextFieldImageView)
        codeTextField.leftView = codeTextFieldImageViewPanel
        codeTextField.leftViewMode = .always
        return codeTextField
    }()
    let codeImageView = UIImageView()
    let loginButton = UIButton()
    let cancelButton = UIButton()
    init() {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .fullScreen
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.setupView()
        self.loginButton.addTarget(self, action: #selector(LoginViewController.loginClick(_:)), for: .touchUpInside)
        self.cancelButton.addTarget(self, action: #selector(LoginViewController.cancelClick), for: .touchUpInside)
    }
    override func viewDidAppear(_ animated: Bool) {
    }

    @objc func cancelClick (){
        self.dismiss(animated: true, completion: nil)
    }
    @objc func loginClick(_ sneder:UIButton){
        var userName:String
        var password:String
        if let len = self.userNameTextField.text?.Lenght , len > 0{
            userName = self.userNameTextField.text! ;
        }
        else{
            self.userNameTextField.becomeFirstResponder()
            return;
        }

        if let len =  self.passwordTextField.text?.Lenght , len > 0  {
            password = self.passwordTextField.text!
        }
        else{
            self.passwordTextField.becomeFirstResponder()
            return;
        }
        var code:String
        if let codeText = self.codeTextField.text, codeText.Lenght > 0 {
            code = codeText
        }
        else{
            self.codeTextField.becomeFirstResponder()
            return
        }
        
        V2BeginLoadingWithStatus("正在登录")
        if let onceStr = onceStr , let usernameStr = usernameStr, let passwordStr = passwordStr, let codeStr = codeStr {
            UserModel.Login(userName,
                            password: password,
                            once: onceStr,
                            usernameFieldName: usernameStr,
                            passwordFieldName: passwordStr ,
                            codeFieldName:codeStr,
                            code:code){
                (response:V2ValueResponse<String> , is2FALoggedIn:Bool) -> Void in
                if response.success {
                    V2Success("登录成功")
                    let username = response.value!
                    //保存下用户名
                    XZSettings.sharedInstance[kUserName] = username
                    
                    //将用户名密码保存进keychain （安全保存)
                    YuanCommunUserKeychain.sharedInstance.addUser(username, password: password)
                    
                    //调用登录成功回调
                    if let handel = self.successHandel {
                        handel(username)
                    }
                    
                    //获取用户信息
                    UserModel.getUserInfoByUsername(username,completionHandler: nil)
                    self.dismiss(animated: true){
                        if is2FALoggedIn {
                            let validationVC = ValidationViewController()
                            self.navigationController?.present(validationVC, animated: true, completion: nil);
                        }
                    }
                }
                else{
                    V2Error(response.message)
                    self.refreshCode()
                }
            }
            return;
        }
        else{
            V2Error("不知道啥错误")
        }
        
    }
    
    var onceStr:String?
    var usernameStr:String?
    var passwordStr:String?
    var codeStr:String?
    @objc func refreshCode(){
        
        Alamofire.request(V2EXURL+"signin", headers: MOBILE_CLIENT_HEADERS).responseJiHtml{
            (response) -> Void in
            
            if let jiHtml = response .result.value{
                self.usernameStr = jiHtml.xPath("//*[@id='Wrapper']/div/div[1]/div[2]/form/table/tr[1]/td[2]/input[@class='sl']")?.first?["name"]
                self.passwordStr = jiHtml.xPath("//*[@id='Wrapper']/div/div[1]/div[2]/form/table/tr[2]/td[2]/input[@class='sl']")?.first?["name"]
                self.codeStr = jiHtml.xPath("//*[@id='Wrapper']/div/div[1]/div[2]/form/table/tr[4]/td[2]/input[@class='sl']")?.first?["name"]
                
                
                if let once = jiHtml.xPath("//*[@name='once'][1]")?.first?["value"]{
                    let codeUrl = "\(V2EXURL)_captcha?once=\(once)"
                    self.onceStr = once
                    Alamofire.request(codeUrl).responseData(completionHandler: { (dataResp) in
                        self.codeImageView.image = UIImage(data: dataResp.data!)
                    })
                }
                else{
                    SVProgressHUD.showError(withStatus: "刷新验证码失败")
                }
            }
        }
    }
}

//MARK: - 点击文本框外收回键盘
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

//MARK: - 初始化界面
extension LoginViewController {
    func setupView(){
        self.view.backgroundColor = UIColor.white
        
        self.cancelButton.contentMode = .center
        cancelButton .setImage(UIImage(named: "guanbi"), for: .normal)
        self.view.addSubview(cancelButton)
        cancelButton.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(self.view).offset(64)
            make.left.equalTo(self.view).offset(25)
            make.width.height.equalTo(30)
        }

        let v2exLabel = UILabel()
        v2exLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 25)!;
        v2exLabel.text = "猿社区"
        v2exLabel.textColor = XZSwiftColor.leftNodeTintColor
        self.view.addSubview(v2exLabel);
        v2exLabel.snp.makeConstraints{ (make) -> Void in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.view).offset(120)
        }

        let v2exSummaryLabel = UILabel()
        v2exSummaryLabel.font = v2Font(13);
        v2exSummaryLabel.text = "V2EX - 程序猿的工作社区"
        self.view.addSubview(v2exSummaryLabel);
        v2exSummaryLabel.snp.makeConstraints{ (make) -> Void in
            make.centerX.equalTo(self.view)
            make.top.equalTo(v2exLabel.snp.bottom).offset(10)
        }

        self.view.addSubview(self.userNameTextField);
        self.userNameTextField.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(v2exSummaryLabel.snp.bottom).offset(45)
            make.centerX.equalTo(self.view)
            make.width.equalTo(300)
            make.height.equalTo(45)
        }
        let separator = UIView()
        separator.backgroundColor = XZSwiftColor.sepColor
        self.view.addSubview(separator)
        separator.snp.makeConstraints{ (make) -> Void in
            make.left.right.bottom.equalTo(self.userNameTextField)
            make.height.equalTo(SEPARATOR_HEIGHT)
        }
        
        self.view.addSubview(self.passwordTextField);
        self.passwordTextField.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(self.userNameTextField.snp.bottom).offset(15)
            make.centerX.equalTo(self.view)
            make.width.equalTo(300)
            make.height.equalTo(45)
        }
        let separator1 = UIView()
        separator1.backgroundColor = XZSwiftColor.sepColor
        self.view.addSubview(separator1)
        separator1.snp.makeConstraints{ (make) -> Void in
            make.left.right.bottom.equalTo(self.passwordTextField)
            make.height.equalTo(SEPARATOR_HEIGHT)
        }
        
        self.view.addSubview(self.codeTextField)
        self.codeTextField.snp.makeConstraints { (make) in
            make.top.equalTo(self.passwordTextField.snp.bottom).offset(15)
            make.left.equalTo(passwordTextField)
            make.width.equalTo(180)
            make.height.equalTo(45)
        }
        let separator2 = UIView()
        separator2.backgroundColor = XZSwiftColor.sepColor
        self.view.addSubview(separator2)
        separator2.snp.makeConstraints{ (make) -> Void in
            make.left.right.bottom.equalTo(self.codeTextField)
            make.height.equalTo(SEPARATOR_HEIGHT)
        }
        
        self.codeImageView.backgroundColor = XZSwiftColor.backgroudColor
        self.codeImageView.layer.cornerRadius = 3;
        self.codeImageView.clipsToBounds = true
        self.codeImageView.isUserInteractionEnabled = true
        self.view.addSubview(self.codeImageView)
        self.codeImageView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self.codeTextField)
            make.left.equalTo(self.codeTextField.snp.right).offset(2)
            make.right.equalTo(self.passwordTextField)
        }
        self.codeImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(refreshCode)))
        
        let codeProblem = UILabel()
        codeProblem.alpha = 0.5
        codeProblem.font = v2Font(12)
        codeProblem.text = "验证码不显示?"
        codeProblem.isUserInteractionEnabled = true
        codeProblem.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(codeProblemClick)))
        self.view.addSubview(codeProblem);

        codeProblem.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(self.codeImageView.snp.bottom).offset(14)
            make.right.equalTo(self.codeImageView)
        }
        
        self.loginButton.setTitle("登录", for: .normal)
        self.loginButton.setTitleColor(XZSwiftColor.white, for: .normal)
        self.loginButton.setBackgroundImage(createImageWithColor(XZSwiftColor.leftNodeTintColor), for: .normal)
        self.loginButton.titleLabel!.font = v2Font(16)
        self.loginButton.layer.cornerRadius = 5;
        self.loginButton.layer.masksToBounds = true
        self.view.addSubview(self.loginButton);

        self.loginButton.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(codeProblem.snp.bottom).offset(30)
            make.centerX.equalTo(self.view)
            make.width.equalTo(300)
            make.height.equalTo(45)
        }

        refreshCode()
    }
    
    @objc func codeProblemClick(){
        UIAlertView(title: "验证码不显示？", message: "如果验证码输错次数过多，V2EX将暂时禁止你的登录。", delegate: nil, cancelButtonTitle: "知道了").show()
    }
}
