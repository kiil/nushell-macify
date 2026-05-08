# macOS browser inspection via osascript

def "nu-complete browsers" [] {
    ["Safari", "Google Chrome", "Arc", "Brave Browser", "Microsoft Edge", "Firefox"]
}

def detect [] {
    let front = (^osascript -e 'tell application "System Events" to name of first application process whose frontmost is true' | str trim)
    if $front in ["Safari" "Google Chrome" "Arc" "Brave Browser" "Microsoft Edge"] {
        $front
    } else {
        "Safari"
    }
}

# URL of active tab in given (or frontmost) browser
export def url [
    --browser (-b): string@"nu-complete browsers"
] {
    let b = ($browser | default (detect))
    let script = if $b == "Safari" {
        'tell application "Safari" to URL of front document'
    } else {
        $'tell application "($b)" to URL of active tab of front window'
    }
    ^osascript -e $script | str trim
}

# Title of active tab
export def title [
    --browser (-b): string@"nu-complete browsers"
] {
    let b = ($browser | default (detect))
    let script = if $b == "Safari" {
        'tell application "Safari" to name of front document'
    } else {
        $'tell application "($b)" to title of active tab of front window'
    }
    ^osascript -e $script | str trim
}

# {url, title} of active tab
export def main [
    --browser (-b): string@"nu-complete browsers"
] {
    let b = ($browser | default (detect))
    {
        browser: $b
        url: (url --browser $b)
        title: (title --browser $b)
    }
}

# All tabs in front window as table {url, title}
export def tabs [
    --browser (-b): string@"nu-complete browsers"
] {
    let b = ($browser | default (detect))
    let title_prop = if $b == "Safari" { "name" } else { "title" }
    let script = ('tell application "' + $b + '"
        set out to ""
        repeat with t in tabs of front window
            set out to out & (URL of t) & "\t" & (' + $title_prop + ' of t) & "\n"
        end repeat
        return out
    end tell')
    ^osascript -e $script
    | lines
    | where ($it | str trim | is-not-empty)
    | each {|l|
        let parts = ($l | split column -c "\t" url title)
        $parts | get 0
    }
}

# Open a URL (in given browser, or default)
export def open [
    url: string
    --browser (-b): string@"nu-complete browsers"
] {
    if ($browser | is-empty) {
        ^open $url
    } else {
        ^open -a $browser $url
    }
}
