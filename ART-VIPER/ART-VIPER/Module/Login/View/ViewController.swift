//
//  ViewController.swift
//  ART-VIPER
//
//  Created by Nguyen Minh Tam on 23/09/2022.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var addItemButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var photoButton: UIButton!
    
    // MARK: - Properties
    private let bag = DisposeBag()
    private let images = BehaviorRelay<[UIImage]>(value: [])
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.implementRx()
    }

    // MARK: - Functions
    private func implementRx() {
        self.addItemButton.rx.tap.subscribe { [weak self] _ in
            guard let this = self, let personImage = UIImage(systemName: "person.crop.circle.fill") else { return }
            
            let newImages = this.images.value + [personImage]
            this.images.accept(newImages)
        }.disposed(by: self.bag)
        
        self.saveButton.rx.tap.subscribe { [weak self] _ in
            guard let this = self, let image = this.images.value.first else { return }
            
            PictureTaker.save(image).subscribe { id in
                this.title = id
            }.disposed(by: this.bag)

        }.disposed(by: self.bag)
        
        self.clearButton.rx.tap.subscribe { [weak self] _ in
            guard let this = self else { return }
            
            this.images.accept([])
        }.disposed(by: self.bag)
        
        self.photoButton.rx.tap.subscribe { [weak self] _ in
            guard let this = self else { return }
            
            let targetVC = PictureViewController()
            targetVC.selectedPhotos.subscribe(onNext: { newImage in
                
                this.images.accept(this.images.value + [newImage])
                    
            }).disposed(by: this.bag)
            
            this.navigationController?.pushViewController(targetVC, animated: true)
            
        }.disposed(by: self.bag)
        
        self.images.subscribe { [weak self] photos in
            guard let this = self, let photos = photos.element else { return }

            this.iconImageView.image = photos.collage(size: this.iconImageView.frame.size)
            this.updateUI(photos: photos)
        }.disposed(by: self.bag)
        
    }
    
    private func updateUI(photos: [UIImage]) {
        self.saveButton.isEnabled = photos.count > 0 && photos.count % 2 == 0
        self.clearButton.isEnabled = photos.count > 0
        self.addItemButton.isEnabled = photos.count < 6
        self.title = photos.count > 0 ? "\(photos.count) photos" : "Collage"
    }

}

