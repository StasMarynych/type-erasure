//
//  ConfiguratorDataProviderTests.swift
//  ChatAppTests
//
//  Created by Stanislav Marynych on 7/28/20.
//  Copyright © 2020 Stanislav Marynych. All rights reserved.
//

import XCTest
@testable import ChatApp

class ConfigurationDataProviderTests: XCTestCase {
    private var dataProvider: ConfigurationDataProviderProtocol?
    
    override func setUpWithError() throws {
        dataProvider = ConfigurationDataProvider()
        
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        dataProvider = nil
        
        try super.tearDownWithError()
    }
    
    func testConfigurationFetching() throws {
        dataProvider?.getConfig { config in
            XCTAssertTrue(config.count > 0)
        }
    }
}
