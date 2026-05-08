# macOS clipboard wrapper

# Get clipboard contents, or set from pipe/argument
export def main [
    text?: string   # Text to put on clipboard (else read from pipe; else get)
] {
    let input = $in
    let value = if ($text | is-not-empty) {
        $text
    } else if ($input | is-not-empty) {
        $input
    } else {
        return (^pbpaste)
    }
    $value | ^pbcopy
}

# Get clipboard contents
export def get [] {
    ^pbpaste
}

# Set clipboard contents
export def set [text?: string] {
    let value = if ($text | is-empty) { $in } else { $text }
    $value | ^pbcopy
}

# Clear the clipboard
export def clear [] {
    "" | ^pbcopy
}
