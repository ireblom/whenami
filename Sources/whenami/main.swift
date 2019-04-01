import Foundation

let arguments = CommandLine.arguments
if arguments.count > 1 {
    let executable = URL(fileURLWithPath: arguments[0]).lastPathComponent
    let usage = "usage: \(executable) [-h]"

    if arguments.count == 2 {
        let argument = arguments[1].trimmingCharacters(in: .whitespacesAndNewlines)

        if argument == "-h" || argument == "--help" {
            print(usage);
            print()
            print("optional arguments:")
            print("  -h, --help  show this help message and exit")
            exit(EXIT_SUCCESS)
        }
    }

    let userName = NSUserName()
    let apology = "I'm sorry \(userName). I'm afraid I can't do that."
    let invalidArguments = arguments[1...arguments.count-1].joined(separator:" ")
    let errorMessage = "\(usage)\n\(apology)\n  \(invalidArguments)\n"
    let standardError = FileHandle.standardError
    standardError.write(errorMessage.data(using: .utf8)!)
    exit(EXIT_FAILURE)
}

print("now")
exit(EXIT_SUCCESS)
