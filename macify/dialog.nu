# macOS dialog wrappers via osascript

# Ask the user for text input
export def ask [
    prompt: string
    --title (-t): string = ""
    --default (-d): string = ""
    --hidden          # Hide input (password)
] {
    let hidden_part = if $hidden { " with hidden answer" } else { "" }
    let title_part  = if ($title | is-empty) { "" } else { $' with title "($title)"' }
    let script = $'display dialog "($prompt)" default answer "($default)"($title_part)($hidden_part)'
    let result = (^osascript -e $script | complete)
    if $result.exit_code != 0 { return null }
    $result.stdout
    | str trim
    | parse --regex 'text returned:(?P<v>.*)'
    | get v.0?
    | default ""
}

# Yes/no confirmation; returns true/false
export def confirm [
    prompt: string
    --title (-t): string = ""
] {
    let title_part = if ($title | is-empty) { "" } else { $' with title "($title)"' }
    let script = $'display dialog "($prompt)"($title_part) buttons {"No","Yes"} default button "Yes"'
    let result = (^osascript -e $script | complete)
    if $result.exit_code != 0 { return false }
    ($result.stdout | str contains "Yes")
}

# Show a one-button alert
export def alert [
    message: string
    --title (-t): string = "Alert"
] {
    ^osascript -e $'display alert "($title)" message "($message)"'
}

# Choose one (or many) from a list
export def choose [
    items: list<string>
    --title (-t): string = ""
    --prompt (-p): string = "Choose:"
    --multiple
] {
    let list_str = ($items | each {|x| $'"($x)"'} | str join ", ")
    let multi    = if $multiple { "true" } else { "false" }
    let title_p  = if ($title | is-empty) { "" } else { $' with title "($title)"' }
    let script   = $'choose from list {($list_str)} with prompt "($prompt)"($title_p) multiple selections allowed ($multi)'
    let result = (^osascript -e $script | complete)
    if $result.exit_code != 0 or ($result.stdout | str trim) == "false" { return null }
    let out = ($result.stdout | str trim)
    if $multiple { $out | split row ", " } else { $out }
}

# Pick a file
export def file [
    --prompt (-p): string = "Choose a file"
] {
    let script = ('POSIX path of (choose file with prompt "' + $prompt + '")')
    let result = (^osascript -e $script | complete)
    if $result.exit_code != 0 { return null }
    $result.stdout | str trim
}

# Pick a folder
export def folder [
    --prompt (-p): string = "Choose a folder"
] {
    let script = ('POSIX path of (choose folder with prompt "' + $prompt + '")')
    let result = (^osascript -e $script | complete)
    if $result.exit_code != 0 { return null }
    $result.stdout | str trim
}
