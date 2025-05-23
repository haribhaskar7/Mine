function Convert-TextToEBCDIC037 {
    param (
        [string]$text
    )

    # Manual ASCII to EBCDIC 037 map (only basic for now, expand if needed)
    $asciiToEbcdic = @{
        'A' = 0xC1; 'B' = 0xC2; 'C' = 0xC3; 'D' = 0xC4; 'E' = 0xC5; 'F' = 0xC6; 'G' = 0xC7; 'H' = 0xC8; 'I' = 0xC9
        'J' = 0xD1; 'K' = 0xD2; 'L' = 0xD3; 'M' = 0xD4; 'N' = 0xD5; 'O' = 0xD6; 'P' = 0xD7; 'Q' = 0xD8; 'R' = 0xD9
        'S' = 0xE2; 'T' = 0xE3; 'U' = 0xE4; 'V' = 0xE5; 'W' = 0xE6; 'X' = 0xE7; 'Y' = 0xE8; 'Z' = 0xE9
        '0' = 0xF0; '1' = 0xF1; '2' = 0xF2; '3' = 0xF3; '4' = 0xF4; '5' = 0xF5; '6' = 0xF6; '7' = 0xF7; '8' = 0xF8; '9' = 0xF9
        ' ' = 0x40
    }

    $bytes = @()

    foreach ($char in $text.ToCharArray()) {
        if ($asciiToEbcdic.ContainsKey($char)) {
            $bytes += [byte]$asciiToEbcdic[$char]
        } else {
            throw "Character '$char' not found in EBCDIC map."
        }
    }

    # Pad to 24 bytes with EBCDIC space (0x40)
    while ($bytes.Count -lt 24) {
        $bytes += 0x40
    }

    # If longer, truncate
    if ($bytes.Count -gt 24) {
        $bytes = $bytes[0..23]
    }

    return ,$bytes  # Force array return
}
