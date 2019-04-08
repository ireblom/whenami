import Foundation

let kVersion = "4.1.2019"

if CommandLine.arguments.count > 1 {
    let executable = URL(fileURLWithPath: CommandLine.arguments[0]).lastPathComponent
    let usage = "usage: \(executable) [-h] [-v]"

    let arguments = CommandLine.arguments[1...CommandLine.arguments.count - 1]
    if arguments.count == 1 {
        let argument = arguments.first?.trimmingCharacters(in: .whitespacesAndNewlines)

        if argument == "-h" || argument == "--help" {
            print(usage)
            print()
            print("optional arguments:")
            print("  -h, --help     show this help message and exit")
            print("  -v, --version  show version number and exit")
            exit(EXIT_SUCCESS)
        }
        if argument == "-v" || argument == "--version" {
            print(kVersion)
            exit(EXIT_SUCCESS)
        }
    }

    let userName = NSUserName()
    let apology = "I'm sorry \(userName). I'm afraid I can't do that."
    let invalidArguments = arguments.joined(separator: " ")
    let errorMessage = "\(usage)\n\(apology)\n  \(invalidArguments)\n"
    let standardError = FileHandle.standardError
    standardError.write(errorMessage.data(using: .utf8)!)
    exit(EXIT_FAILURE)
}

print("now")
exit(EXIT_SUCCESS)
