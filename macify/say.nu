# macOS text-to-speech wrapper

def "nu-complete voices" [] {
    ^say -v '?'
    | lines
    | each {|l|
        let parts = ($l | split row -r '\s{2,}')
        let head = ($parts.0? | default "" | split row ' ')
        {value: $head.0, description: ($parts.2? | default "")}
    }
    | where value != ""
}

# Speak text aloud using macOS `say`
export def main [
    text?: string                                          # Text to speak (or piped in)
    --voice (-v): string@"nu-complete voices"              # Voice name
    --rate (-r): int                                       # Words per minute
    --output (-o): path                                    # Save to AIFF file instead of speaking
] {
    let words = if ($text | is-empty) { $in } else { $text }

    mut args = []
    if $voice  != null { $args = ($args | append ["-v" $voice]) }
    if $rate   != null { $args = ($args | append ["-r" ($rate | into string)]) }
    if $output != null { $args = ($args | append ["-o" $output]) }

    $words | ^say ...$args
}
