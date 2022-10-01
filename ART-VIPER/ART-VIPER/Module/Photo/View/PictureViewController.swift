//
//  PictureViewController.swift
//  ART-VIPER
//
//  Created by Nguyen Minh Tam on 30/09/2022.
//

import UIKit
import RxSwift
import Photos

class PictureViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var pictureCollectionView: UICollectionView!
    
    // MARK: - Properties
    private lazy var photos = PictureViewController.loadPhotos()
    private lazy var imageManager = PHCachingImageManager()
    private let selectedPhotosSubject = PublishSubject<UIImage>()
    var selectedPhotos: Observable<UIImage> {
      return selectedPhotosSubject.asObservable()
    }
    static func loadPhotos() -> PHFetchResult<PHAsset> {
      let allPhotosOptions = PHFetchOptions()
      allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
      return PHAsset.fetchAssets(with: allPhotosOptions)
    }
    private lazy var thumbnailSize: CGSize = {
        let cellSize = (self.pictureCollectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize
      return CGSize(width: cellSize.width * UIScreen.main.scale,
                    height: cellSize.height * UIScreen.main.scale)
    }()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.registerCell()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.selectedPhotosSubject.onCompleted()
    }
    
    // MARK: - Functions
    private func setupUI() {
        self.pictureCollectionView.delegate = self
        self.pictureCollectionView.dataSource = self
    }
    
    private func registerCell() {
        self.pictureCollectionView.register(UINib(nibName: "PhotoCell", bundle: nibBundle), forCellWithReuseIdentifier: "PhotoCell")
    }

}

// MARK: - UICollectionViewDataSource
extension PictureViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let asset = photos.object(at: indexPath.item)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell

        cell.representedAssetIdentifier = asset.localIdentifier
        imageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
          if cell.representedAssetIdentifier == asset.localIdentifier {
            cell.imageView.image = image
          }
        })

        return cell
    }
    
}

// MARK: - UICollectionViewDelegate
extension PictureViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let asset = photos.object(at: indexPath.item)

        if let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell {
          cell.flash()
        }

        imageManager.requestImage(for: asset, targetSize: view.frame.size, contentMode: .aspectFill, options: nil, resultHandler: { [weak self] image, info in
          guard let this = self, let image = image, let info = info else { return }
            
            if let isThumbnail = info[PHImageResultIsDegradedKey as NSString] as?
              Bool, !isThumbnail {
              this.selectedPhotosSubject.onNext(image)
            }
          
        })
    }
}
