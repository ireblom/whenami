import XCTest
import class Foundation.Bundle

final class WhenamiTests: XCTestCase {
    func testNoArgs() throws {
        // Some of the APIs that we use below are available in macOS 10.13 and above.
        guard #available(macOS 10.13, *) else {
            return
        }

        let whenamiBinary = productsDirectory.appendingPathComponent("whenami")

        let process = Process()
        process.executableURL = whenamiBinary

        let outPipe = Pipe()
        process.standardOutput = outPipe
        let errPipe = Pipe()
        process.standardError = errPipe

        try process.run()
        process.waitUntilExit()

        XCTAssertEqual(process.terminationStatus, 0)

        let outData = outPipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: outData, encoding: .utf8)
        let expectedOutput = "now\n"
        XCTAssertEqual(output, expectedOutput)

        let errData = errPipe.fileHandleForReading.readDataToEndOfFile()
        let error = String(data: errData, encoding: .utf8)
        let expectedError = ""
        XCTAssertEqual(error, expectedError)
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
            let intentionallyLeftBlank = ""
            let expectedOutput = """
                                 usage: whenami [-h] [-v]
                                 \(intentionallyLeftBlank)
                                 optional arguments:
                                   -h, --help     show this help message and exit
                                   -v, --version  show version number and exit
                                 \(intentionallyLeftBlank)
                                 """
            XCTAssertEqual(output, expectedOutput)

            let errData = errPipe.fileHandleForReading.readDataToEndOfFile()
            let error = String(data: errData, encoding: .utf8)
            let expectedError = ""
            XCTAssertEqual(error, expectedError)
        }
    }

    func testVersionArgs() throws {
        // Some of the APIs that we use below are available in macOS 10.13 and above.
        guard #available(macOS 10.13, *) else {
            return
        }

        let whenamiBinary = productsDirectory.appendingPathComponent("whenami")

        for versionArgument in ["-v", "--version"] {
            let process = Process()
            process.executableURL = whenamiBinary

            let arguments = [versionArgument]
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
            let expectedOutput = "4.1.2019\n"
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
        let intentionallyLeftBlank = ""
        let expectedError = """
                            usage: whenami [-h] [-v]
                            I'm sorry \(userName). I'm afraid I can't do that.
                              \(arguments[0])
                            \(intentionallyLeftBlank)
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
        ("testVersionArgs", testVersionArgs),
        ("testWrongArgs", testWrongArgs)
    ]
}
