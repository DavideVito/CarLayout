//
//  ViewController.swift
//  DrawRouteOnMapKit
//
//  Created by Aman Aggarwal on 08/03/18.
//  Copyright © 2018 Aman Aggarwal. All rights reserved.
//

import UIKit
import AVFoundation

class MusicaViewController: UIViewController, AVAudioPlayerDelegate {

    var canzoni = Array<Canzone>()
    var canzoniRiprodotte = Array<Canzone>()
    
    @IBOutlet weak var nowPlayingLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        bottonePlay(self)
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        for canzone in canzoni
        {
            canzone.dati = nil
        }
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        bottoneAvanti(self)
    }
    
    
    @IBOutlet weak var textAreaNomeCanzone: UITextView!
    var player: AVAudioPlayer?
    var canzoneCorrente: Canzone?
    var arrivato = TimeInterval()
    
    
    func riproduci(canzone: Canzone) {
        
        print("\n\n==CANZONE CORRENTE==" + canzone.nome + "\n\n")
        self.arrivato = TimeInterval(exactly: 0)!
        canzoniRiprodotte.append(canzone)
        
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            var dati = canzoneCorrente?.dati;
            let file = canzone.nome
            let appDir = FileManager.SearchPathDirectory.documentDirectory
            self.nowPlayingLabel.text = "Sto scaricando " + canzone.nome
            if(dati == nil)
            {
                if let dir = FileManager.default.urls(for: appDir, in: .userDomainMask).first {

                    let fileURL = dir.appendingPathComponent(file)
                    
                    do {
                        dati  = try Data(contentsOf: fileURL)
                        
                    }
                    catch {/* error handling here */}
                }
            }
            
            if(dati == nil)
            {
                dati = try Data(contentsOf: canzone.getPercorso())
                if let dir = FileManager.default.urls(for: appDir, in: .userDomainMask).first {

                    let fileURL = dir.appendingPathComponent(file)

                    //writing
                    do {
                        try dati!.write(to: fileURL)
                    }
                    catch {/* error handling here */}
                }
                
                
                
                
            }
            canzoneCorrente?.dati = dati
            
            player?.delegate = self
            
            player?.stop()
            player = try AVAudioPlayer(data: dati!, fileTypeHint: AVFileType.mp3.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

            guard let player = player else { return }
            self.nowPlayingLabel.text = "Now Playing: " + canzone.nome + " di " + canzone.autore
            player.play()
            NotificationCenter.default.addObserver(self, selector: "playerDidFinishPlaying:", name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player)
            

        } catch let error {
            print(error.localizedDescription)
        }
    }

    @IBAction func bottoneAvanti(_ sender: Any) {
        player?.stop()
        if(indice == self.canzoni.count)
        {
            indice = 0;
            
        }
        
        canzoneCorrente = canzoni[indice]
        indice += 1
        
        riproduci(canzone: canzoneCorrente!)
        
    }
    
    var indice: Int = 0;
    
    @IBAction func bottoneIndietro(_ sender: Any) {
        player!.stop();
        if(indice <= 0)
        {
            return
        }
        if(indice == self.canzoni.count)
        {
            indice -= 1
        }
        indice -= 1;
        canzoneCorrente = canzoni[indice]
        riproduci(canzone: canzoneCorrente!)
        
    }
    
    var alreadydonefetch = false;
    var oldNome: String = "";
    
    @IBAction func bottonePlay(_ sender: Any)
    {
        let testoTextArea = textAreaNomeCanzone.text!
        if(self.canzoni.count == 0 || alreadydonefetch || oldNome != testoTextArea)
        {
            alreadydonefetch = false
            let t =  NetworkManagerRequests.fetchCanzoni(sito: NetworkManagerRequests.sitoMusica + "?nome=\(testoTextArea)")!
            self.oldNome = testoTextArea
            if(t.count == 0)
            {
                let ab = UIAlertController(title: "Sta canzone ancora non l'abbiamo", message: "Non abbiamo trovato questa canzone", preferredStyle: .alert)
                ab.addAction(UIAlertAction(title: "Va bene", style: .cancel, handler: nil))
                self.present(ab, animated: true, completion: nil)
                return
            }
            self.canzoni = t
            indice = 0;
            
            
        }
        
        canzoneCorrente = canzoni[indice]
        indice += 1
        riproduci(canzone: canzoneCorrente!)
        return
            /*
        else
        {
            if(self.player!.isPlaying)
            {
                self.arrivato = (player?.currentTime)!
                player!.stop();
            }
            else
            {
                self.player?.play(atTime: arrivato)
            }
            
        }*/
    }
}
