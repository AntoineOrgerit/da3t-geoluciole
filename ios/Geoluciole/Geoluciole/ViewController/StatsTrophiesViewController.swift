//
//  StatsTrophiesViewController.swift
//  Geoluciole
//
//  Created by Lambert Thibaud on 08/01/2020.
//  Copyright © 2020 Université La Rochelle. All rights reserved.
//

import UIKit

class StatsTrophiesViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource  {

    var titleBar: TitleBar!

    var collectionData = ["test", "test2", "Test3", "Test4", "Test5", "Test6"]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.titleBar = TitleBar()
        self.titleBar.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.titleBar)

        NSLayoutConstraint.activate([
            self.titleBar.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: 1),
            self.titleBar.heightAnchor.constraint(equalToConstant: Tools.getStatusBarHeight() * 2),
            self.titleBar.topAnchor.constraint(equalTo: self.view.topAnchor),

        ])
        
        let statView = StatsView()

        self.view.addSubview(statView)
        NSLayoutConstraint.activate([
            statView.topAnchor.constraint(equalTo: titleBar.bottomAnchor),
            statView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            statView.heightAnchor.constraint(equalToConstant: view.frame.height * 0.20)
        ])

        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CustomCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()


        view.addSubview(self.titleBar)
        view.addSubview(statView)
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([

            collectionView.topAnchor.constraint(equalTo: statView.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)


    }


    func collectionView(_ collectionView: UICollectionView, layout UICollectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2.5, height: collectionView.frame.width / 3)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
        return cell
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

class CustomCell: UICollectionViewCell {

    private let bg: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "guillaume-briard-lSXpV8bDeMA-unsplash")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(bg)

        NSLayoutConstraint.activate([
            bg.topAnchor.constraint(equalTo: contentView.topAnchor),
            bg.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bg.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bg.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])


    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

