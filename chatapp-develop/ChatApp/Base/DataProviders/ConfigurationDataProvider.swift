//
//  ConfigurationModel.swift
//  ChatApp
//
//  Created by Stanislav Marynych on 7/22/20.
//  Copyright © 2020 Stanislav Marynych. All rights reserved.
//

import Foundation

protocol ConfigurationDataProviderProtocol {
    func getConfig(completion:([String: String]) -> Void)
}

class ConfigurationDataProvider: ConfigurationDataProviderProtocol {
    func getConfig(completion:([String: String]) -> Void) {
        completion([
            ConfigurationKeys.validationRuleEmail: "^[a-zA-Z0-9.!#$%&*+/=?^_`{}~-]+@([a-zA-Z0-9-]+)[.]([a-zA-Z0-9.-]{2,})$",
            ConfigurationKeys.validationRulePassword: "^[A-Za-z0-9#&%]{9,128}$"
        ])
    }
}
