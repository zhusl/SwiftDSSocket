//
//  SwiftDSSocketTests.swift
//  SwiftDSSocketTests
//
//  Created by Yi Huang on 7/27/17.
//  Copyright © 2017 Yi Huang. All rights reserved.
//

import XCTest
@testable import SwiftDSSocket

class ConnectAndListen: XCTestCase {
  var client: SwiftDSSocket?
  var server: SwiftDSSocket?
  var accepted: SwiftDSSocket?
  weak var onAcceptExpectation: XCTestExpectation?
  weak var onConnectExpectation: XCTestExpectation?
  let serverAdress = "127.0.0.1"
  let serverPort: UInt16 = 9999
  
  override func setUp() {
    super.setUp()
    SwiftDSSocket.debugMode = true
    client = SwiftDSSocket(delegate: self, delegateQueue: .main, type: .tcp)
    server = SwiftDSSocket(delegate: self, delegateQueue: .main, type: .tcp)
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
    client?.disconnect()
    server?.disconnect()
  }
  
  func testExample() {
    try? server?.accept(onPort: serverPort)
    try? client?.connect(toHost: serverAdress, port: serverPort)
    onConnectExpectation = expectation(description: "Test Connect")
    onAcceptExpectation = expectation(description: "Test Listen")
    
    waitForExpectations(timeout: 1) { (error: Error?) in
      if let error = error {
        XCTFail("failed for error: \(error.localizedDescription)")
      } else {
        SwiftDSSocket.log("Success")
      }
    }
  }
  
}


extension ConnectAndListen: SwiftDSSocketDelegate {
  func socket(sock: SwiftDSSocket, didAcceptNewSocket newSocket: SwiftDSSocket) {
    accepted = newSocket
    SwiftDSSocket.log("@didAcceptNewSocket")
    onAcceptExpectation?.fulfill()
  }
  
  func socket(sock: SwiftDSSocket, didConnectToHost host: String, port: UInt16) {
    SwiftDSSocket.log("@didConnectToHost")
    onConnectExpectation?.fulfill()
    
  }
}
