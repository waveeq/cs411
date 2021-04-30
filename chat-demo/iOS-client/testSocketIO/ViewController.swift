//
//  ViewController.swift
//  testSocketIO
//
//  Created by Mochammad Dikra Prasetya on 2021/04/30.
//

import Foundation
import SocketIO
import UIKit

class ViewController: UIViewController {

  static let clientName = "mobile_app"
  static let clientRoom = 1

  var manager : SocketManager!
  var socket: SocketIOClient!

  var messagesTextView = UITextView()

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.

    let button = UIButton()
    view.addSubview(button)

    button.setTitle("Send Text", for: .normal)
    button.addTarget(self, action: #selector(sendText(_:)), for: .touchUpInside)
    button.backgroundColor = .systemGreen

    let layoutGuide = view.safeAreaLayoutGuide

    button.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      button.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: 8),
      button.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor),
      button.widthAnchor.constraint(equalToConstant: 200),
      button.heightAnchor.constraint(equalToConstant: 48),
    ])

    view.addSubview(messagesTextView)
    messagesTextView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      messagesTextView.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 12),
      messagesTextView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 8),
      messagesTextView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: 8),
      messagesTextView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: 8)
    ])

    connectSocketIO()
  }


  func connectSocketIO() {
    manager = SocketManager(socketURL: URL(string: "http://127.0.0.1:5000")!, config: [.log(true), .compress])
    socket = manager.socket(forNamespace: "/chat")

    socket.on("connect") { data, ack in
      self.socket.emit("joined", JoinedData(name: Self.clientName, room: Self.clientRoom))
    }

    socket.on("status") { data, ack in
      self.addDataToTextView(data)
    }

    socket.on("message") { data, ack in
      self.addDataToTextView(data)
    }

    socket.connect()
  }

  @objc func sendText(_ sender: Any?) {
    socket.emit("text", MessageData(name: Self.clientName, room: Self.clientRoom, msg: "test message"))
  }

  func addDataToTextView(_ data: [Any]) {
    guard let dict = data.first as? [String:Any] else { return }

    if let messageString = dict["msg"]! as? String {
      var text: String = self.messagesTextView.text ?? ""
      text.append(messageString + "\n")
      self.messagesTextView.text = text
    }
  }
}


struct MessageData: SocketData {
  let name: String
  let room: Int
  let msg: String

  func socketRepresentation() -> SocketData {
    return ["name": name, "room": room, "msg": msg]
  }
}

struct JoinedData: SocketData {
  let name: String
  let room: Int

  func socketRepresentation() -> SocketData {
    return ["name": name, "room": room]
  }
}
