//
//  PokemonDetailVC.swift
//  pokedex
//
//  Created by Dylan Hamuy on 10/17/21.
//  Copyright © 2021 Dylan Hamuy. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {

    var pokemon: Pokemon!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pokemonNumLabel: UILabel!
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var hpVal: UILabel!
    @IBOutlet weak var atkVal: UILabel!
    @IBOutlet weak var spatkVal: UILabel!
    @IBOutlet weak var spdVal: UILabel!
    @IBOutlet weak var defVal: UILabel!
    @IBOutlet weak var spdefVal: UILabel!
    @IBOutlet weak var totalVal: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = pokemon.name
        pokemonImage.load(urlString: pokemon.largeimageUrl)
        pokemonNumLabel.text = "#" + String(pokemon.id)
        totalVal.text = String(pokemon.total)
        hpVal.text = String(pokemon.health)
        atkVal.text = String(pokemon.attack)
        spatkVal.text = String(pokemon.specialAttack)
        spdVal.text = String(pokemon.speed)
        defVal.text = String(pokemon.defense)
        spdefVal.text = String(pokemon.specialDefense)
    }
}

extension UIImageView {
    func load(urlString: String) {
        guard let url = URL(string: urlString)else {
            return
        }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}


