//
//  StatsTrophiesViewController.swift
//  Geoluciole
//
//  Created by Lambert Thibaud on 08/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import UIKit

class StatsTrophiesViewController: ParentViewController,  UICollectionViewDelegateFlowLayout, UICollectionViewDataSource  {

    var collectionData = ["test", "test2", "Test3", "Test4", "Test5", "Test6"]

    override func viewDidLoad() {
        super.viewDidLoad()

        let statView = StatsView()

        self.view.addSubview(statView)
        NSLayoutConstraint.activate([
            statView.topAnchor.constraint(equalTo: self.titleBar.bottomAnchor),
            statView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            statView.heightAnchor.constraint(equalToConstant: view.frame.height * 0.20)
        ])

        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(BadgesCollectionViewCell.self, forCellWithReuseIdentifier: "BadgesCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()

        view.addSubview(statView)
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([

            collectionView.topAnchor.constraint(equalTo: statView.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constantes.PAGE_PADDING_HORIZONTAL),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constantes.PAGE_PADDING_HORIZONTAL),
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func collectionView(_ collectionView: UICollectionView, layout UICollectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 4, height: collectionView.frame.width / 3)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BadgesCollectionViewCell", for: indexPath) as! BadgesCollectionViewCell
        return cell
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}
