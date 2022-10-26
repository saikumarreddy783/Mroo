//
//  MountDetailDataSource.swift
//  Habitica
//
//  Created by Phillip Thelen on 17.04.18.
//  Copyright © 2018 HabitRPG Inc. All rights reserved.
//

import Foundation
import Habitica_Models

struct MountStableItem {
    var mount: MountProtocol?
    var owned: Bool
}

class MountDetailDataSource: BaseReactiveCollectionViewDataSource<MountStableItem> {
    
    private let stableRepsository = StableRepository()
    var types = ["drop", "premium"]
    
    init(searchEggs: Bool, searchKey: String) {
        super.init()
        sections.append(ItemSection<MountStableItem>(title: L10n.Stable.standard))
        sections.append(ItemSection<MountStableItem>(title: L10n.Stable.premium))
        var query = ""
        if searchKey.contains("-") {
            query = "key == '\(searchKey)'"
        } else if searchEggs {
            query = "egg == '\(searchKey)'"
        } else {
            query = "potion == '\(searchKey)'"
        }
        disposable.add(stableRepsository.getOwnedMounts(query: "key CONTAINS '\(searchKey)'")
            .map({ data -> [String: Bool] in
                var ownedMounts = [String: Bool]()
                data.value.forEach({ (ownedMount) in
                    ownedMounts[ownedMount.key ?? ""] = ownedMount.owned
                })
                return ownedMounts
            })
            .combineLatest(with: stableRepsository.getMounts(query: query)
                .map({ mounts in
                    return mounts.value.filter({ (mount) -> Bool in
                        return self.types.contains(mount.type ?? "")
                        })
                }))
            .on(value: {[weak self](ownedMounts, mounts) in
                self?.sections[0].items.removeAll()
                self?.sections[1].items.removeAll()
                mounts.forEach({ (mount) in
                    let item = MountStableItem(mount: mount, owned: ownedMounts[mount.key ?? ""] ?? false)
                    if mount.type == "premium" {
                        self?.sections[1].items.append(item)
                    } else {
                        self?.sections[0].items.append(item)
                    }
                })
                if self?.visibleSections.count == 1 {
                    self?.visibleSections[0].title = nil
                }
                self?.collectionView?.reloadData()
            }).start())
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        if let mountItem = item(at: indexPath), let mountCell = cell as? MountDetailCell {
            mountCell.configure(mountItem: mountItem)
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let reuseIdentifier = (kind == UICollectionView.elementKindSectionFooter) ? "SectionFooter" : "SectionHeader"
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        if kind == UICollectionView.elementKindSectionHeader {
            let label = view.viewWithTag(1) as? UILabel
            label?.text = visibleSections[indexPath.section].title
            label?.textColor = ThemeService.shared.theme.secondaryTextColor
            let countLabel = view.viewWithTag(2) as? UILabel
            countLabel?.textColor = ThemeService.shared.theme.ternaryTextColor
            view.viewWithTag(3)?.backgroundColor = ThemeService.shared.theme.offsetBackgroundColor
            let ownedCount = visibleSections[indexPath.section].items.filter { $0.owned }.count
            let totalCount = visibleSections[indexPath.section].items.count
            countLabel?.text = "\(ownedCount)/\(totalCount)"
            
            view.shouldGroupAccessibilityChildren = true
            view.isAccessibilityElement = true
            view.accessibilityLabel = visibleSections[indexPath.section].title ?? "" + " " + L10n.Accessibility.xofx(ownedCount, totalCount)
        }
        
        return view
    }
}
