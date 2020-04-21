//
//  chatViewController.swift
//  grocery-go
//
//  Created by Basil Arif on 2020-04-21.
//  Copyright © 2020 Basil Arif. All rights reserved.
//

import Foundation
import UIKit
import MessageKit
import Firebase
import Photos
import InputBarAccessoryView

extension UIScrollView {
    
    var isAtBottom: Bool {
        return contentOffset.y >= verticalOffsetForBottom
    }
    
    var verticalOffsetForBottom: CGFloat {
        let scrollViewHeight = bounds.height
        let scrollContentSizeHeight = contentSize.height
        let bottomInset = contentInset.bottom
        let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
        return scrollViewBottomOffset
    }
    
}

final class chatViewController: MessagesViewController {
    
    private let db = Firestore.firestore()
    private var reference: CollectionReference?
    
    private var messages: [message] = []
    private var messageListener: ListenerRegistration?
    
    private let user: User
    private let channel: channel

    
    deinit {
        messageListener?.remove()
    }
    
    init(user: User, channel: channel) {
        self.user = user
        self.channel = channel
        super.init(nibName: nil, bundle: nil)
        
        title = channel.name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        guard let id = channel.id else {
            navigationController?.popViewController(animated: true)
            return
        }
        reference = db.collection(["channels", id, "thread"].joined(separator: "/"))
        
        messageListener = reference?.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
                return
            }
            
            snapshot.documentChanges.forEach { change in
                self.handleDocumentChange(change)
            }
        }

        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
    }
    
    // MARK: - Helpers
    
    private func save(_ message: message) {
        reference?.addDocument(data: message.representation) { error in
            if let e = error {
                print("Error sending message: \(e.localizedDescription)")
                return
            }
            
            self.messagesCollectionView.scrollToBottom()
        }
    }
    
    private func insertNewMessage(_ message: message) {
        guard !messages.contains(message) else {
            return
        }
        
        messages.append(message)
        messages.sort()
        
        let isLatestMessage = messages.index(of: message) == (messages.count - 1)
        let shouldScrollToBottom = messagesCollectionView.isAtBottom && isLatestMessage
        
        messagesCollectionView.reloadData()
        
        if shouldScrollToBottom {
            DispatchQueue.main.async {
                self.messagesCollectionView.scrollToBottom(animated: true)
            }
        }
    }
    
    private func handleDocumentChange(_ change: DocumentChange) {
        guard var message = message(document: change.document) else {
            return
        }
        
        switch change.type {
        case .added:
//            if let url = message.downloadURL {
//                downloadImage(at: url) { [weak self] image in
//                    guard let `self` = self else {
//                        return
//                    }
//                    guard let image = image else {
//                        return
//                    }
//
//                    message.image = image
//                    self.insertNewMessage(message)
//                }
//            } else {
//                insertNewMessage(message)
//            }
            insertNewMessage(message)
            
        default:
            break
        }
    }
    
}

// MARK: - MessagesDisplayDelegate

extension chatViewController: MessagesDisplayDelegate {
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .green : .blue
    }
    
    func shouldDisplayHeader(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> Bool {
        return false
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(corner, .curved)
    }
    
}

// MARK: - MessagesLayoutDelegate

extension chatViewController: MessagesLayoutDelegate {
    
    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return .zero
    }
    
    func footerViewSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize(width: 0, height: 8)
    }
    
    func heightForLocation(message: MessageType, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        return 0
    }
    
}

// MARK: - MessagesDataSource

extension chatViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        return Sender(senderId: user.uid, displayName: "basil")
        //return Sender(id: user.uid, displayName: "basil")
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(
            string: name,
            attributes: [
                .font: UIFont.preferredFont(forTextStyle: .caption1),
                .foregroundColor: UIColor(white: 0.3, alpha: 1)
            ]
        )
    }
    
}

// MARK: - MessageInputBarDelegate

extension chatViewController: InputBarAccessoryViewDelegate {
    
    func messageInputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let msg = message(user: user, content: text)
        
        save(msg)
        inputBar.inputTextView.text = ""
    }
    
}
