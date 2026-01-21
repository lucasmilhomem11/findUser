# Username Enumeration Script (Auto-Detect)

This Bash script performs username enumeration against a web login form by analyzing how an application responds to valid versus invalid usernames.
It automatically detects response differences and adjusts its detection logic without relying on hardcoded strings.

The script is intended for lab environments, security testing, and educational purposes only.

---

## Features

* Automatic detection of valid vs invalid username responses
* Supports both response-length and response-content detection
* Parallelized requests for improved performance
* Live progress display during enumeration
* Optional custom wordlist support
* No hardcoded error messages required
* Designed for predictable and reproducible results in lab environments

---

## How It Works

1. Sends a login request using:

   * A likely valid username (first entry in the wordlist)
   * A guaranteed invalid username
2. Compares the responses
3. Automatically determines the best detection method:

   * Response length (preferred)
   * Unique response string (fallback)
4. Runs the enumeration using the detected logic

---

## Usage

```bash
./script.sh -u <login_url> [-w <wordlist>]
```

---

## Required

* `-u <url>`
  Target login endpoint

---

## Optional

* `-w <wordlist>`
  Username wordlist
  Default:

  ```text
  /usr/share/seclists/Usernames/Names/names.txt
  ```

* `-h`
  Show help message

---

## Examples

```bash
./script.sh -u http://lookup.thm/login.php
```

```bash
./script.sh -u http://lookup.thm/login.php -w users.txt
```

---

## Requirements

* Bash
* curl
* GNU parallel
* A login form that differentiates between valid and invalid usernames

---

## Limitations

* Will not work if the application returns identical responses for all login failures
* CSRF-protected or tokenized forms require additional handling
* The first wordlist entry should ideally be a likely valid username

---

## Legal Disclaimer

This tool is intended for authorized security testing, lab environments, and educational use only.
Do not use this script against systems you do not own or have explicit permission to test.

---

## License

MIT License
