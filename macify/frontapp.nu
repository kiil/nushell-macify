# macOS frontmost app and app control via osascript

def "nu-complete apps" [] {
    ls /Applications
    | where name =~ '\.app$'
    | get name
    | path basename
    | str replace '.app' ''
}

# Get name of frontmost app
export def main [] {
    ^osascript -e 'tell application "System Events" to name of first application process whose frontmost is true'
    | str trim
}

# List running app names
export def list [] {
    ^osascript -e 'tell application "System Events" to get name of every application process whose background only is false'
    | str trim
    | split row ", "
}

# Activate (bring to front) an app
export def activate [
    app: string@"nu-complete apps"
] {
    ^osascript -e $'tell application "($app)" to activate'
}

# Quit an app
export def quit [
    app: string@"nu-complete apps"
] {
    ^osascript -e $'tell application "($app)" to quit'
}

# Hide an app
export def hide [
    app: string@"nu-complete apps"
] {
    ^osascript -e $'tell application "System Events" to set visible of process "($app)" to false'
}
