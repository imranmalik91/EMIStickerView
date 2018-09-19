//
//  EmiStickerView.swift
//  StickerDemo
//
//  Created by GWL on 30/08/18.
//  Copyright © 2018 GWL. All rights reserved.
//

import UIKit

struct Sticker {
    
    var name:String?
    
    var sticker:UIImage?
}
///This class helps to add multiple stickers on any view with couple line of code.It provide's Zooming , Rotating , and Scaling of Sticker.User can remove it by tapping close button on top right corener that disabled after 3 second's after each tap on sticker.
class EmiStickerView: UIView , UIGestureRecognizerDelegate{
    
    private var localTouchPosition : CGPoint?
    private var identity = CGAffineTransform.identity
    
    private var closeButton:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("X", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(closeButtonDidTap(_:)), for: .touchUpInside)
        return button
    }()
    
    private var stickerImageView:UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    var stickerImage:UIImage?{
        didSet{
            stickerImageView.image = stickerImage
        }
    }
    
    private var isCloseButtonVisible = false
    private let padding:CGFloat = 20.0
    
    
    //MARK:-
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    //MARK:- All setup goes here for image view
    private func setup(){
        
        addSubview(stickerImageView)
        stickerImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding).isActive = true
        stickerImageView.topAnchor.constraint(equalTo: topAnchor, constant: padding).isActive = true
        stickerImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: padding).isActive = true
        stickerImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding).isActive = true
        
        
        addSubview(closeButton)
        closeButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        closeButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        closeButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        

        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 8
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(scale))
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(rotate))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        
        pinchGesture.delegate = self
        rotationGesture.delegate = self
        
        addGestureRecognizer(pinchGesture)
        addGestureRecognizer(rotationGesture)
        addGestureRecognizer(tapGesture)
        
        showCloseButton()
        hideCloseButton()
    }
    
    
    
    //MARK:- Function to remove imageView from its superview
    @objc private func closeButtonDidTap(_ sender:UIButton){
        removeFromSuperview()
    }
    
    private func hideCloseButton(){
        if isCloseButtonVisible {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.closeButton.isHidden = true
                self.isCloseButtonVisible = false
                self.layer.borderWidth = 0
            }
        }
    }
    
    private func showCloseButton(){
        self.closeButton.isHidden = false
        isCloseButtonVisible = true
        self.layer.borderWidth = 1
    }
    
    @objc func tap(_ gesture: UITapGestureRecognizer) {
        if isCloseButtonVisible {
            hideCloseButton()
        }else{
            showCloseButton()
            hideCloseButton()
        }
    }
    
    
    
    //MARK:- Function to handle scaling of imageview
    @objc func scale(_ gesture: UIPinchGestureRecognizer) {
        switch gesture.state {
        case .began:
            identity = transform
        case .changed,.ended:
            transform = identity.scaledBy(x: gesture.scale, y: gesture.scale)
        case .cancelled:
            break
        default:
            break
        }
    }
    
    //MARK:- Function to handle rotation of imageview
    @objc func rotate(_ gesture: UIRotationGestureRecognizer) {
        transform = transform.rotated(by: gesture.rotation)
    }
    
    
    //MARK:- Gesture Recognizer delegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    //MARK:- Function to handle moving of imageview
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        let touch = touches.first
        guard let location = touch?.location(in: self.superview) else { return }
        // Store localTouchPosition relative to center
        self.localTouchPosition = CGPoint(x: location.x - self.center.x, y: location.y - self.center.y)
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        let touch = touches.first
        guard let location = touch?.location(in: self.superview), let localTouchPosition = self.localTouchPosition else{
            return
        }
        self.center = CGPoint(x: location.x - localTouchPosition.x, y: location.y - localTouchPosition.y)
    }
    //MARK:-

}
