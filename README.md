# Username Enumeration Script (Auto-Detect)

This Bash script performs username enumeration against a web login form.
The script is intended for lab environments, security testing, and educational purposes only.

---

## Features

* Parallelized requests for improved performance
* Live progress display during enumeration
* Optional custom wordlist support

---

## How It Works

The script submits login requests using usernames from a wordlist

For each request, the HTTP response is analyzed to determine whether the username is valid.

A username is considered valid when:

  The response contains a string that indicates an existing user (by default: Wrong password)

The response string used to identify valid usernames can be:

  The default hardcoded value (Wrong password)

  A custom value provided by the user at runtime

Requests are sent in parallel to improve performance, and progress is displayed live during execution.

Usernames that meet the detection criteria are reported as valid.

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
