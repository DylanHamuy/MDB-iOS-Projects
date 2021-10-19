//
//  FilterViewController.swift
//  pokedex
//
//  Created by Dylan Hamuy on 10/17/21.
//  Copyright © 2021 Dylan Hamuy. All rights reserved.
//

import UIKit


class FilterViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var pokemonArray = [Pokemon]()
    
    @IBOutlet weak var filterTypesCollectionView: UICollectionView!
    var pvc: PokemonViewController!
        
    var possibleTypes = ["Bug", "Grass", "Dark", "Ground", "Dragon", "Ice", "Electric", "Normal", "Fairy", "Poison", "Fighting", "Psychic", "Fire", "Rock", "Flying", "Steel", "Ghost", "Water", "Unknown"]
    var selectedTypes = [String]()
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    @IBOutlet weak var filterLabel: UILabel!
    
    @IBOutlet weak var minAttackPointsLabel: UILabel!
    @IBOutlet weak var atkSlider: UISlider!
    @IBOutlet weak var minDefensePointsLabel: UILabel!
    @IBOutlet weak var defSlider: UISlider!
    @IBOutlet weak var minHealthPointsLabel: UILabel!
    @IBOutlet weak var healthSlider: UISlider!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        atkSlider.maximumValue = 200.0
        defSlider.maximumValue = 100.0
        healthSlider.maximumValue = 100.0
        filterTypesCollectionView.delegate = self
        filterTypesCollectionView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        atkSlider.value = Float(FilterMode.shared.minAtk)
        defSlider.value = Float(FilterMode.shared.minDef)
        healthSlider.value = Float(FilterMode.shared.minHealth)
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedString = indexPath.row
        if selectedTypes.contains(possibleTypes[selectedString]) {
            selectedTypes = selectedTypes.filter(){$0 != possibleTypes[selectedString]}
        } else {
            selectedTypes.append(possibleTypes[indexPath.row])
        }
        filterTypesCollectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return possibleTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! FilterTypeCollectionViewCell
        let currType: String!
        currType = possibleTypes[indexPath.row]
        cell.filterNameLabel.text = currType
        if selectedTypes.contains(currType) {
            let color = cell.backgroundColor?.withAlphaComponent(0.5)
            cell.backgroundColor = color
        } else {
            let color = cell.backgroundColor?.withAlphaComponent(1.0)
            cell.backgroundColor = color
        }
        return cell
    }
    
    
    @IBAction func resetButtonAction(_ sender: Any) {
        selectedTypes = [String]()
        atkSlider.value = 0;
        defSlider.value = 0;
        healthSlider.value = 0;
    }
    
    @IBAction func doneButtonAction(_ sender: Any) {
        FilterMode.shared.minAtk = Int(self.atkSlider.value)
        FilterMode.shared.minDef = Int(self.defSlider.value)
        FilterMode.shared.minHealth = Int(self.healthSlider.value)
        FilterMode.shared.selectedTypes = self.selectedTypes
            dismiss(animated: true, completion: nil)
    }
}
