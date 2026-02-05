//
//  String+Ext.swift
//  Tic-tac-toe
//
//  Created by Alexander Ognerubov on 05.02.2026.
//

import UIKit

extension String {
    func width(boundingHeight height: CGFloat? = nil, font: UIFont) -> CGFloat {
        return ceil(
            NSString(string: self).boundingRect(
                with: CGSize(
                    width: CGFloat.greatestFiniteMagnitude,
                    height: height ?? CGFloat.greatestFiniteMagnitude),
                options: [
                    .usesFontLeading,
                    .usesLineFragmentOrigin
                ],
                attributes: [.font: font],
                context: nil
            ).width
        )
    }
}
