import PhotoEditorSDK

/// This controller applies advanced customizations that require replacing built-in classes with custom subclasses.
@objcMembers @objc class CustomizationController: NSObject {

  /// The shared controller used to customize PhotoEditor SDK.
  static let shared = CustomizationController()

  /// Applies the customizations to the SDK.
  ///
  /// In here, the default `PhotoEditViewController` is exchanged with a
  /// custom `CustomPhotoEditViewController` and the default `MenuCollectionViewCell` is exchanged
  /// with a custom `CustomMenuCollectionViewCell` that allows to display a premium feature indicator.
  func apply() {
    do {
      try PESDK.replaceClass(PhotoEditViewController.self, with: CustomPhotoEditViewController.self)
      try PESDK.replaceClass(MenuCollectionViewCell.self, with: CustomMenuCollectionViewCell.self)
    } catch let error {
      print("Customizations could not be applied, due to:", error.localizedDescription)
    }
  }

  /// A custom implementation of the `PhotoEditViewController`.
  class CustomPhotoEditViewController: PhotoEditViewController {

    /// The tools that are premium features and would need to be separately unlocked.
    let premiumToolControllers: [PhotoEditToolController.Type] = [StickerToolController.self, FilterToolController.self]

    /// Override the delegate function in order to add a premium feature indicator for `premiumToolControllers`.
    override func menuViewController(_ menuViewController: MenuViewController, willShow menuItem: MenuItem, in cell: UICollectionViewCell, at index: Int) {
      super.menuViewController(menuViewController, willShow: menuItem, in: cell, at: index)

      guard let cell = cell as? MenuCollectionViewCell else { return }

      if let toolMenuItem = menuItem as? ToolMenuItem {
        if premiumToolControllers.contains(where: {$0 == toolMenuItem.toolControllerClass}) {
          let premiumLabel = UILabel()
          premiumLabel.frame = CGRect(x: 0, y: 0, width: 25, height: 15)
          premiumLabel.text = "Pro"
          premiumLabel.textAlignment = .center
          premiumLabel.font = UIFont.boldSystemFont(ofSize: 11)
          premiumLabel.backgroundColor = UIColor.black
          premiumLabel.textColor = UIColor.white
          premiumLabel.layer.masksToBounds = true
          premiumLabel.layer.cornerRadius = 5

          cell.iconImageView.addSubview(premiumLabel)
        }
      }
    }

    /// Override the delegate function in order to show an alert controller for `premiumToolControllers`.
    override func menuViewController(_ menuViewController: MenuViewController, didSelect menuItem: MenuItem) {
      if let toolMenuItem = menuItem as? ToolMenuItem {
        if premiumToolControllers.contains(where: {$0 == toolMenuItem.toolControllerClass}) {
          presentPremiumAlert {
            super.menuViewController(menuViewController, didSelect: menuItem)
          }
        } else {
          super.menuViewController(menuViewController, didSelect: menuItem)
        }
      }
    }

    /// Presents an `UIAlertController` indicating that the selected feature is a
    /// premium feature and requires to be unlocked before use.
    private func presentPremiumAlert(completion: @escaping() -> Void?) {
      let premiumAlert = UIAlertController(title: "Demonstration purpose", message: "You can customize the editor to your needs - e.g. lock certain features for non-premium users.", preferredStyle: .alert)
      premiumAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (_) in
        completion()
      }))
      present(premiumAlert, animated: true, completion: nil)
    }
  }

  /// A custom implementation of the `MenuCollectionViewCell` that allows
  /// to display a premium indicator.
  class CustomMenuCollectionViewCell: MenuCollectionViewCell {

    override func prepareForReuse() {
      super.prepareForReuse()

      for subview in iconImageView.subviews {
        subview.removeFromSuperview()
      }
    }
  }
}
