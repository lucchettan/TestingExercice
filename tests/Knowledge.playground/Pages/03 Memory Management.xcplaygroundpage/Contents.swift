//: [Précédent](@previous)
/*:
 # 03 — Gestion mémoire

 ARC, cycles de rétention, `weak` / `unowned`, capture lists.
 */
import Foundation

// MARK: - 1.
final class ImageLoader {
    var onComplete: (() -> Void)?
    var data: Data?

    func load() {
        onComplete = {
            self.data = Data()
            print("loaded \(self.data?.count ?? 0)")
        }
    }
}

// MARK: - 2.
protocol DownloadDelegate: AnyObject {
    func didFinish()
}

class Downloader {
    var delegate: DownloadDelegate?
}

class ViewController: DownloadDelegate {
    let downloader = Downloader()
    init() {
        downloader.delegate = self
    }
    func didFinish() {}
}

// MARK: - 3.
final class Customer {
    let name: String
    var card: CreditCard?
    init(name: String) { self.name = name }
}

final class CreditCard {
    let number: String
    unowned let customer: Customer
    init(number: String, customer: Customer) {
        self.number = number
        self.customer = customer
    }
}

// MARK: - 4.
final class Node {
    var children: [Node] = []
    var parent: Node?
    func add(_ child: Node) {
        children.append(child)
        child.parent = self
    }
}

//: [Suivant](@next)
