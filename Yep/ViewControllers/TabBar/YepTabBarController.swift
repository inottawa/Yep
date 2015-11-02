//
//  YepTabBarController.swift
//  Yep
//
//  Created by kevinzhow on 15/3/28.
//  Copyright (c) 2015年 Catch Inc. All rights reserved.
//

import UIKit

class YepTabBarController: UITabBarController {

    var previousTab = Tab.Conversations

    struct Listener {
        static let lauchStyle = "YepTabBarController.lauchStyle"
    }

    deinit {
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            appDelegate.lauchStyle.removeListenerWithName(Listener.lauchStyle)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self

        view.backgroundColor = UIColor.whiteColor()

        // 将 UITabBarItem 的 image 下移一些，也不显示 title 了
        /*
        if let items = tabBar.items as? [UITabBarItem] {
            for item in items {
                item.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
                item.title = nil
            }
        }
        */

        if let items = tabBar.items {

            let titles = [
                NSLocalizedString("Chats", comment: ""),
                NSLocalizedString("Contacts", comment: ""),
                NSLocalizedString("Feeds", comment: ""),
                NSLocalizedString("Discover", comment: ""),
                NSLocalizedString("Profile", comment: ""),
            ]

            for i in 0..<items.count {
                let item = items[i]
                item.title = titles[i]
            }
        }

        // 处理启动切换

        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            appDelegate.lauchStyle.bindListener(Listener.lauchStyle) { [weak self] style in
                if style == .Message {
                    self?.selectedIndex = 0
                }
            }
        }
    }
}

// MARK: - UITabBarControllerDelegate

extension YepTabBarController: UITabBarControllerDelegate {

    enum Tab: Int {

        case Conversations
        case Contacts
        case Feeds
        case Discover
        case Profile
    }

    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {

        guard
            let tab = Tab(rawValue: selectedIndex),
            let nvc = viewController as? UINavigationController else {
                return
        }

        // 不相等才继续，确保第一次 tap 不做事

        if tab != previousTab {
            previousTab = tab
            return
        }

        switch tab {

        case .Conversations:
            if let vc = nvc.topViewController as? ConversationsViewController {
                if !vc.conversationsTableView.yep_isAtTop {
                    vc.conversationsTableView.yep_scrollsToTop()
                }
            }

        case .Contacts:
            if let vc = nvc.topViewController as? ContactsViewController {
                if !vc.contactsTableView.yep_isAtTop {
                    vc.contactsTableView.yep_scrollsToTop()
                }
            }

        case .Feeds:
            if let vc = nvc.topViewController as? FeedsViewController {
                if !vc.feedsTableView.yep_isAtTop {
                    vc.feedsTableView.yep_scrollsToTop()
                }
            }

        case .Discover:
            let vc = nvc.topViewController as? DiscoverViewController

        case .Profile:
            let vc = nvc.topViewController as? ProfileViewController

        }

        /*
        if selectedIndex == 1 {
            if let nvc = viewController as? UINavigationController, vc = nvc.topViewController as? ContactsViewController {
                syncFriendshipsAndDoFurtherAction {
                    dispatch_async(dispatch_get_main_queue()) { [weak vc] in
                        vc?.updateContactsTableView()
                    }
                }
            }
        }
        */
    }
}

