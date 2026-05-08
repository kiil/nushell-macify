# macOS notification wrapper using osascript

def "nu-complete sounds" [] {
    [
        "Basso"
        "Blow"
        "Bottle"
        "Frog"
        "Funk"
        "Glass"
        "Hero"
        "Morse"
        "Ping"
        "Pop"
        "Purr"
        "Sosumi"
        "Submarine"
        "Tink"
    ]
}

# Display a macOS notification via osascript
export def main [
    message: string                                       # Notification body
    --title (-t): string = "System"                       # Notification title
    --sound (-s): string@"nu-complete sounds" = "Glass"   # Sound name
] {
    let script = $'display notification "($message)" with title "($title)" sound name "($sound)"'
    osascript -e $script
}
