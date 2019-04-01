import XCTest
import class Foundation.Bundle

final class whenamiTests: XCTestCase {
    func testNoArgs() throws {
        // Some of the APIs that we use below are available in macOS 10.13 and above.
        guard #available(macOS 10.13, *) else {
            return
        }

        let fooBinary = productsDirectory.appendingPathComponent("whenami")

        let process = Process()
        process.executableURL = fooBinary

        let pipe = Pipe()
        process.standardOutput = pipe

        try process.run()
        process.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)

        XCTAssertEqual(output, "now\n")
    }

    func testHelpArgs() throws {
        // Some of the APIs that we use below are available in macOS 10.13 and above.
        guard #available(macOS 10.13, *) else {
            return
        }

        let whenamiBinary = productsDirectory.appendingPathComponent("whenami")

        for helpArgument in ["-h", "--help"] {
            let process = Process()
            process.executableURL = whenamiBinary

            let arguments = [helpArgument]
            process.arguments = arguments
            let outPipe = Pipe()
            process.standardOutput = outPipe
            let errPipe = Pipe()
            process.standardError = errPipe

            try process.run()
            process.waitUntilExit()

            XCTAssertEqual(process.terminationStatus, 0)

            let outData = outPipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(data: outData, encoding: .utf8)
            let expectedOutput = """
                                 usage: whenami [-h]
                                 
                                 optional arguments:
                                   -h, --help  show this help message and exit
                                 
                                 """
            XCTAssertEqual(output, expectedOutput)

            let errData = errPipe.fileHandleForReading.readDataToEndOfFile()
            let error = String(data: errData, encoding: .utf8)
            let expectedError = ""
            XCTAssertEqual(error, expectedError)
        }
    }

    func testWrongArgs() throws {
        // Some of the APIs that we use below are available in macOS 10.13 and above.
        guard #available(macOS 10.13, *) else {
            return
        }

        let whenamiBinary = productsDirectory.appendingPathComponent("whenami")

        let process = Process()
        process.executableURL = whenamiBinary
        let arguments = ["I am sooo invalid!"]
        process.arguments = arguments
        let outPipe = Pipe()
        process.standardOutput = outPipe
        let errPipe = Pipe()
        process.standardError = errPipe

        try process.run()
        process.waitUntilExit()

        XCTAssertEqual(process.terminationStatus, 1)

        let outData = outPipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: outData, encoding: .utf8)
        let expectedOutput = ""
        XCTAssertEqual(output, expectedOutput)

        let errData = errPipe.fileHandleForReading.readDataToEndOfFile()
        let error = String(data: errData, encoding: .utf8)
        let userName = NSUserName()
        let expectedError = """
                            usage: whenami [-h]
                            I'm sorry \(userName). I'm afraid I can't do that.
                              \(arguments[0])

                            """
        XCTAssertEqual(error, expectedError)
    }

    /// Returns path to the built products directory.
    var productsDirectory: URL {
      #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
      #else
        return Bundle.main.bundleURL
      #endif
    }

    static var allTests = [
        ("testNoArgs", testNoArgs),
        ("testHelpArgs", testHelpArgs),
        ("testWrongArgs", testWrongArgs)
    ]
}
