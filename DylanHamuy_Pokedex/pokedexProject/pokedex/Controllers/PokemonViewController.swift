//
//  PokemonViewController.swift
//  pokedex
//
//  Created by Dylan Hamuy on 10/15/21.
//  Copyright © 2021 Dylan Hamuy. All rights reserved.
//

import UIKit

class PokemonViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var pokeCollectionView: UICollectionView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var filterButton: UIButton!
    let dataSource: [Pokemon] = PokemonGenerator.getPokemonArray()
    var filteredPokemon = PokemonGenerator.getPokemonArray()
    var nameArray = [String]()
    var urlArray = [String]()
    var currIndex: Int = 0
    var inSearchMode = false
    var poke: Pokemon!
    var isRowMode = false
    var originalRowWidth: CGFloat = 0.0
    
    var minAtk = 0
    var minDef = 0
    var minHealth = 0
    
    
    var selectedTypes = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pokeCollectionView.delegate = self
        pokeCollectionView.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateFilter()
        pokeCollectionView.reloadData()
    }
        

    func updateFilter() {
        let minAtk = FilterMode.shared.minAtk
        let minDef = FilterMode.shared.minDef
        let minHealth = FilterMode.shared.minHealth
        let selectedTypes = FilterMode.shared.selectedTypes
        filteredPokemon = dataSource.filter({
            $0.attack > minAtk && $0.defense > minDef && $0.health > minHealth })
        if selectedTypes.count > 0 {
            filteredPokemon = filteredPokemon.filter({
                $0.types.contains(where: {selectedTypes.contains($0.rawValue) })})
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        poke = filteredPokemon[indexPath.row]
        performSegue(withIdentifier: "PokemonDetailVC", sender: self)
    }
    
    @IBAction func filterButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "filterViewSegue", sender: self)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredPokemon.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        let currPoke: Pokemon!
        currPoke = filteredPokemon[indexPath.row]
        cell.pokemonNameLabel.text = String(currPoke.id) + ": " + currPoke.name
        cell.configurePFP(with: currPoke.imageUrl)
        return cell
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            updateFilter()
            pokeCollectionView.reloadData()
            view.endEditing(true)
        } else {
            let lower = searchBar.text!.lowercased()
            updateFilter()
            filteredPokemon = filteredPokemon.filter({$0.name.lowercased().contains(lower)})
            pokeCollectionView.reloadData()
        }
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? PokemonDetailVC else { return }
        vc.pokemon = self.poke
        
        guard let vc1 = segue.destination as? FilterViewController else { return }
        vc1.pokemonArray = self.filteredPokemon
    }
    
    @IBAction func indexChanged(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
            case 0:
                isRowMode = false
                pokeCollectionView.collectionViewLayout.invalidateLayout()
                break
            
            case 1:
                isRowMode = true
                pokeCollectionView.collectionViewLayout.invalidateLayout()
                break
                
            default:
                break
        }
    }
    
    
func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    if isRowMode {
        return CGSize(width: self.view.frame.width, height: 150)
    }
    return CGSize(width: (self.view.frame.width / 2) - 20 , height: (self.view.frame.width / 2) - 20)
    }
     
}

