//
//  StatsTrophiesViewController.swift
//  Geoluciole
//
//  Created by Lambert Thibaud on 08/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import UIKit

class StatsTrophiesViewController: ParentViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    fileprivate var noBadge: NoBadgeView!
    fileprivate var statView: StatsView!
    fileprivate var collectionView: UICollectionView!
    fileprivate let reuseIdentifier = "BadgesCollectionViewCell"
    fileprivate let itemsPerRow: CGFloat = 3
    fileprivate var loader: LoaderView!
    fileprivate var wrap: UIView!
    fileprivate var badgesData = [Badge]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.statView = StatsView()
        self.statView.translatesAutoresizingMaskIntoConstraints = false
        self.rootView.addSubview(self.statView)

        let label = CustomUILabel()
        label.text = Tools.getTranslate(key: "text_badges")
        label.setStyle(style: .subtitleBold)
        label.translatesAutoresizingMaskIntoConstraints = false
        self.rootView.addSubview(label)

        self.wrap = UIView()
        self.wrap.translatesAutoresizingMaskIntoConstraints = false
        self.rootView.addSubview(self.wrap)

        self.loader = LoaderView(frame: .zero)
        self.loader.translatesAutoresizingMaskIntoConstraints = false
        self.wrap.addSubview(self.loader)

        self.noBadge = NoBadgeView()
        self.noBadge.translatesAutoresizingMaskIntoConstraints = false
        self.wrap.addSubview(self.noBadge)

        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        self.collectionView.register(BadgesCollectionViewCell.self, forCellWithReuseIdentifier: self.reuseIdentifier)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.backgroundColor = .white
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.wrap.addSubview(self.collectionView)

        NSLayoutConstraint.activate([
            self.statView.topAnchor.constraint(equalTo: self.titleBar.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            self.statView.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.PAGE_PADDING),
            self.statView.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.PAGE_PADDING),

            label.topAnchor.constraint(equalTo: self.statView.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            label.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.PAGE_PADDING),
            label.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.PAGE_PADDING),

            self.wrap.topAnchor.constraint(equalTo: label.bottomAnchor, constant: Constantes.FIELD_SPACING_VERTICAL),
            self.wrap.bottomAnchor.constraint(equalTo: self.rootView.bottomAnchor, constant: -Constantes.FIELD_SPACING_VERTICAL),
            self.wrap.leftAnchor.constraint(equalTo: self.rootView.leftAnchor, constant: Constantes.PAGE_PADDING),
            self.wrap.rightAnchor.constraint(equalTo: self.rootView.rightAnchor, constant: -Constantes.PAGE_PADDING),

            self.loader.centerXAnchor.constraint(equalTo: self.wrap.centerXAnchor),
            self.loader.centerYAnchor.constraint(equalTo: self.wrap.centerYAnchor),
            self.loader.widthAnchor.constraint(equalToConstant: Constantes.LOADER_SIZE),
            self.loader.heightAnchor.constraint(equalTo: self.loader.widthAnchor),

            self.collectionView.topAnchor.constraint(equalTo: self.wrap.topAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.wrap.bottomAnchor),
            self.collectionView.leftAnchor.constraint(equalTo: self.wrap.leftAnchor),
            self.collectionView.rightAnchor.constraint(equalTo: self.wrap.rightAnchor),

            self.noBadge.topAnchor.constraint(equalTo: self.wrap.topAnchor),
            self.noBadge.bottomAnchor.constraint(equalTo: self.wrap.bottomAnchor),
            self.noBadge.leftAnchor.constraint(equalTo: self.wrap.leftAnchor),
            self.noBadge.rightAnchor.constraint(equalTo: self.wrap.rightAnchor)
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.statView.setValeurDist()
        self.loadBadges()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.badgesData.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier, for: indexPath) as! BadgesCollectionViewCell
        cell.backgroundColor = UIColor(red: 227 / 255, green: 227 / 255, blue: 227 / 255, alpha: 0.5)
        cell.setImage(name: self.badgesData[indexPath.row].resource)
        cell.layer.cornerRadius = 10

        // Lors du clic on veut afficher un toast
        let badgeInCell = self.badgesData[indexPath.row]
        cell.idBadge = badgeInCell.id
        cell.onClick = { [weak self] _ in
            guard let strongSelf = self else { return }

            strongSelf.rootView.hideAllToasts()
            strongSelf.rootView.makeToast(badgeInCell.description, duration: 1, title: badgeInCell.name)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = Constantes.FIELD_SPACING_HORIZONTAL * (self.itemsPerRow + 1)
        let availableWidth = self.collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / self.itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    fileprivate func loadBadges() {

        // On cache tout sauf le loader
        self.noBadge.isHidden = true
        self.collectionView.isHidden = true

        self.badgesData = [Badge]()

        // Lancement du loader
        self.loader.startAnimating()

        let queue = DispatchQueue(label: "LoadBadges", qos: .utility)

        // On run 0.4 seconde après afin de voir le loader :)
        queue.asyncAfter(deadline: .now() + 0.4) {

            // Récupération des badges qui ont été obtenu
            BadgesTable.getInstance().selectQuery([], where: [WhereCondition(onColumn: BadgesTable.IS_OBTAIN, withCondition: "1")]) { (success, queryResult, error) in

                if let error = error {
                    if Constantes.DEBUG {
                        print("\(#function) ERROR : " + error.localizedDescription)
                    }
                    return
                }

                // Affichages des badges
                DispatchQueue.main.async {
                    self.loader.stopAnimating()

                    if queryResult.isEmpty {
                        self.collectionView.isHidden = true
                        self.noBadge.isHidden = false
                    } else {

                        for badge in queryResult {
                            self.badgesData.append(Badge(badge))
                        }

                        self.noBadge.isHidden = true
                        self.collectionView.isHidden = false
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
}
