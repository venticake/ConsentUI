#!/usr/bin/env python3
"""
Generate platform-specific resource files from master consent_strings.json
"""

import json
import os
from pathlib import Path

SCRIPT_DIR = Path(__file__).parent
PROJECT_ROOT = SCRIPT_DIR.parent
MASTER_FILE = PROJECT_ROOT / "resources" / "consent_strings.json"

# iOS mapping: JSON key -> iOS locale folder name
IOS_LOCALE_MAP = {
    "en": "en",
    "ko": "ko",
    "de": "de",
    "fr": "fr",
    "es": "es",
    "it": "it",
    "ja": "ja",
    "zh-Hans": "zh-Hans",
    "pt": "pt-BR",
    "nl": "nl",
    "pl": "pl",
    "sv": "sv",
}

# Android mapping: JSON key -> Android values folder suffix
ANDROID_LOCALE_MAP = {
    "en": "",  # Default (values/)
    "ko": "-ko",
    "de": "-de",
    "fr": "-fr",
    "es": "-es",
    "it": "-it",
    "ja": "-ja",
    "zh-Hans": "-zh-rCN",
    "pt": "-pt-rBR",
    "nl": "-nl",
    "pl": "-pl",
    "sv": "-sv",
}


def load_master_strings() -> dict:
    """Load master consent strings from JSON file."""
    with open(MASTER_FILE, "r", encoding="utf-8") as f:
        return json.load(f)


def generate_ios_strings(strings: dict):
    """Generate iOS Localizable.strings files."""
    ios_resources_dir = PROJECT_ROOT / "ios" / "Sources" / "ConsentUI" / "Resources"

    for json_locale, ios_locale in IOS_LOCALE_MAP.items():
        if json_locale not in strings:
            print(f"Warning: Missing locale '{json_locale}' in master file")
            continue

        locale_data = strings[json_locale]
        lproj_dir = ios_resources_dir / f"{ios_locale}.lproj"
        lproj_dir.mkdir(parents=True, exist_ok=True)

        output_file = lproj_dir / "Localizable.strings"

        content = f'''/* ConsentUI Localized Strings - {ios_locale} */

"consent_title" = "{escape_ios_string(locale_data['title'])}";
"consent_message" = "{escape_ios_string(locale_data['message'])}";
"consent_allow" = "{escape_ios_string(locale_data['allow'])}";
"consent_decline" = "{escape_ios_string(locale_data['decline'])}";
'''

        with open(output_file, "w", encoding="utf-8") as f:
            f.write(content)

        print(f"Generated: {output_file}")


def generate_android_strings(strings: dict):
    """Generate Android strings.xml files."""
    android_res_dir = PROJECT_ROOT / "android" / "consentui" / "src" / "main" / "res"

    for json_locale, android_suffix in ANDROID_LOCALE_MAP.items():
        if json_locale not in strings:
            print(f"Warning: Missing locale '{json_locale}' in master file")
            continue

        locale_data = strings[json_locale]
        values_dir = android_res_dir / f"values{android_suffix}"
        values_dir.mkdir(parents=True, exist_ok=True)

        output_file = values_dir / "strings.xml"

        content = f'''<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="consent_title">{escape_android_string(locale_data['title'])}</string>
    <string name="consent_message">{escape_android_string(locale_data['message'])}</string>
    <string name="consent_allow">{escape_android_string(locale_data['allow'])}</string>
    <string name="consent_decline">{escape_android_string(locale_data['decline'])}</string>
</resources>
'''

        with open(output_file, "w", encoding="utf-8") as f:
            f.write(content)

        print(f"Generated: {output_file}")


def escape_ios_string(s: str) -> str:
    """Escape special characters for iOS .strings format."""
    return s.replace("\\", "\\\\").replace('"', '\\"').replace("\n", "\\n")


def escape_android_string(s: str) -> str:
    """Escape special characters for Android XML format."""
    return (s
            .replace("&", "&amp;")
            .replace("<", "&lt;")
            .replace(">", "&gt;")
            .replace('"', '\\"')
            .replace("'", "\\'"))


def main():
    print("Loading master strings...")
    strings = load_master_strings()

    print(f"\nFound {len(strings)} locales: {', '.join(strings.keys())}")

    print("\n=== Generating iOS resources ===")
    generate_ios_strings(strings)

    print("\n=== Generating Android resources ===")
    generate_android_strings(strings)

    print("\nDone!")


if __name__ == "__main__":
    main()
