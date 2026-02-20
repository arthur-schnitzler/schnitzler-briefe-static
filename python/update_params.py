#!/usr/bin/env python3
"""
Update params.xsl with current statistics from the data.

This script counts:
- Total letters (XML files in data/editions/)
- Complete correspondences (non-planned personGrp entries in listcorrespondence.xml)

Then updates xslt/partials/params.xsl with these values.
"""

import re
from pathlib import Path
import xml.etree.ElementTree as ET


def count_letters(editions_dir):
    """Count XML files in editions directory."""
    editions_path = Path(editions_dir)
    if not editions_path.exists():
        print(f"Warning: {editions_dir} does not exist")
        return 0

    xml_files = list(editions_path.glob("*.xml"))
    count = len(xml_files)
    print(f"Found {count} letter files in {editions_dir}")
    return count


def count_complete_correspondences(listcorrespondence_file):
    """
    Count personGrp entries that are NOT planned.
    Excludes: ana="planned" and xml:id="correspondence_null"
    """
    try:
        tree = ET.parse(listcorrespondence_file)
        root = tree.getroot()

        # Register namespace
        ET.register_namespace('', 'http://www.tei-c.org/ns/1.0')

        # Find all personGrp elements
        person_groups = root.findall('.//{http://www.tei-c.org/ns/1.0}personGrp')

        complete_count = 0
        for pg in person_groups:
            xml_id = pg.get('{http://www.w3.org/XML/1998/namespace}id')
            ana = pg.get('ana', '')

            # Exclude planned correspondences and correspondence_null
            if xml_id == 'correspondence_null':
                continue
            if 'planned' in ana:
                continue

            complete_count += 1

        print(f"Found {complete_count} complete correspondences (excluding planned)")
        return complete_count

    except Exception as e:
        print(f"Error parsing {listcorrespondence_file}: {e}")
        return 0


def format_number_german(number):
    """Format number with German thousands separator (e.g., 3936 -> 3.936)."""
    return f"{number:,}".replace(',', '.')


def update_params_xsl(params_file, total_letters, complete_correspondences):
    """Update the params.xsl file with new values."""

    try:
        with open(params_file, 'r', encoding='utf-8') as f:
            content = f.read()

        # Format the numbers
        letters_formatted = format_number_german(total_letters)

        # Update total_letters
        content = re.sub(
            r'<xsl:param name="total_letters">\d+</xsl:param>',
            f'<xsl:param name="total_letters">{total_letters}</xsl:param>',
            content
        )

        # Update total_letters_formatted
        content = re.sub(
            r'<xsl:param name="total_letters_formatted">[\d.]+</xsl:param>',
            f'<xsl:param name="total_letters_formatted">{letters_formatted}</xsl:param>',
            content
        )

        # Update complete_correspondences
        content = re.sub(
            r'<xsl:param name="complete_correspondences">\d+</xsl:param>',
            f'<xsl:param name="complete_correspondences">{complete_correspondences}</xsl:param>',
            content
        )

        # Update complete_correspondences_formatted
        content = re.sub(
            r'<xsl:param name="complete_correspondences_formatted">[\d.]+</xsl:param>',
            f'<xsl:param name="complete_correspondences_formatted">{complete_correspondences}</xsl:param>',
            content
        )

        # Write back
        with open(params_file, 'w', encoding='utf-8') as f:
            f.write(content)

        print(f"\nUpdated {params_file}:")
        print(f"  total_letters: {total_letters}")
        print(f"  total_letters_formatted: {letters_formatted}")
        print(f"  complete_correspondences: {complete_correspondences}")
        print(f"  complete_correspondences_formatted: {complete_correspondences}")

    except Exception as e:
        print(f"Error updating {params_file}: {e}")
        raise


def main():
    """Main function."""
    # Set up paths relative to project root (one level above the python/ directory)
    script_dir = Path(__file__).parent.parent

    editions_dir = script_dir / "data" / "editions"
    listcorrespondence_file = script_dir / "data" / "indices" / "listcorrespondence.xml"
    params_file = script_dir / "xslt" / "partials" / "params.xsl"

    print("Counting statistics...")
    print("=" * 60)

    # Count letters
    total_letters = count_letters(editions_dir)

    # Count complete correspondences
    complete_correspondences = count_complete_correspondences(listcorrespondence_file)

    print("=" * 60)

    # Update params.xsl
    update_params_xsl(params_file, total_letters, complete_correspondences)

    print("\n✓ params.xsl updated successfully!")


if __name__ == "__main__":
    main()
