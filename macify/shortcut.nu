# macOS Shortcuts.app wrapper

def "nu-complete shortcuts" [] {
    ^shortcuts list | lines
}

# List installed shortcuts
export def list [] {
    ^shortcuts list | lines
}

# Run a shortcut by name; pass stdin as input, return stdout
export def main [
    name: string@"nu-complete shortcuts"
    --output (-o): path           # Write output to file instead of stdout
] {
    let input = $in
    if ($output != null) {
        $input | ^shortcuts run $name --output-path $output
    } else if ($input | is-not-empty) {
        $input | ^shortcuts run $name
    } else {
        ^shortcuts run $name
    }
}

# View a shortcut in the Shortcuts.app editor
export def view [
    name: string@"nu-complete shortcuts"
] {
    ^shortcuts view $name
}
