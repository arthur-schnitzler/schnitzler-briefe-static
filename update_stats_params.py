#!/usr/bin/env python3
"""
Update XSLT parameters with statistics from gesamtstatistik.json
"""

import json
import re
from pathlib import Path


def update_params_xsl():
    """Read statistics from JSON and update params.xsl"""

    # Read the JSON statistics file
    json_path = Path("html/js-data/gesamtstatistik.json")
    if not json_path.exists():
        print(f"Warning: {json_path} not found. Skipping parameter update.")
        return

    with open(json_path, 'r', encoding='utf-8') as f:
        stats = json.load(f)

    total_letters = stats.get('total_letters', 3936)
    complete_correspondences = stats.get('complete_correspondences', 52)

    # Format numbers with thousands separator (German style with dot)
    def format_number(num):
        return f"{num:,}".replace(',', '.')

    letters_formatted = format_number(total_letters)
    corr_formatted = format_number(complete_correspondences)

    # Read params.xsl
    params_path = Path("xslt/partials/params.xsl")
    with open(params_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Check if parameters already exist
    if '<xsl:param name="total_letters"' not in content:
        # Add new parameters before the closing </xsl:stylesheet>
        new_params = f'''    <xsl:param name="total_letters">{total_letters}</xsl:param>
    <xsl:param name="total_letters_formatted">{letters_formatted}</xsl:param>
    <xsl:param name="complete_correspondences">{complete_correspondences}</xsl:param>
    <xsl:param name="complete_correspondences_formatted">{corr_formatted}</xsl:param>
'''
        content = content.replace('</xsl:stylesheet>', new_params + '</xsl:stylesheet>')
    else:
        # Update existing parameters
        content = re.sub(
            r'<xsl:param name="total_letters">\d+</xsl:param>',
            f'<xsl:param name="total_letters">{total_letters}</xsl:param>',
            content
        )
        content = re.sub(
            r'<xsl:param name="total_letters_formatted">[^<]+</xsl:param>',
            f'<xsl:param name="total_letters_formatted">{letters_formatted}</xsl:param>',
            content
        )
        content = re.sub(
            r'<xsl:param name="complete_correspondences">\d+</xsl:param>',
            f'<xsl:param name="complete_correspondences">{complete_correspondences}</xsl:param>',
            content
        )
        content = re.sub(
            r'<xsl:param name="complete_correspondences_formatted">[^<]+</xsl:param>',
            f'<xsl:param name="complete_correspondences_formatted">{corr_formatted}</xsl:param>',
            content
        )

    # Write back to params.xsl
    with open(params_path, 'w', encoding='utf-8') as f:
        f.write(content)

    print(f"✓ Updated params.xsl with: {letters_formatted} letters, {corr_formatted} correspondences")


if __name__ == '__main__':
    update_params_xsl()
