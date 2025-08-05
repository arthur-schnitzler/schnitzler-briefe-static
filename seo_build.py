#!/usr/bin/env python3
"""
SEO Build Script for Schnitzler Briefe
Comprehensive SEO optimization during build process
"""

import os
import sys
import subprocess
import json
from datetime import datetime
import xml.etree.ElementTree as ET

def run_command(command, description):
    """Run a command and handle errors"""
    print(f"Running: {description}")
    try:
        result = subprocess.run(command, shell=True, check=True, capture_output=True, text=True)
        print(f"✓ {description} completed successfully")
        if result.stdout:
            print(f"  Output: {result.stdout.strip()}")
        return True
    except subprocess.CalledProcessError as e:
        print(f"✗ Error in {description}:")
        print(f"  {e.stderr}")
        return False

def validate_html_files():
    """Basic validation of generated HTML files for SEO compliance"""
    html_files = []
    issues = []
    
    # Find all HTML files
    for root, dirs, files in os.walk('./html/'):
        for file in files:
            if file.endswith('.html'):
                html_files.append(os.path.join(root, file))
    
    print(f"Validating {len(html_files)} HTML files for SEO compliance...")
    
    for html_file in html_files[:10]:  # Check first 10 files as sample
        try:
            with open(html_file, 'r', encoding='utf-8') as f:
                content = f.read()
                
            # Check for essential SEO elements
            if '<title>' not in content:
                issues.append(f"{html_file}: Missing title tag")
            
            if 'name="description"' not in content:
                issues.append(f"{html_file}: Missing meta description")
                
            if 'rel="canonical"' not in content:
                issues.append(f"{html_file}: Missing canonical URL")
                
            if '<h1>' not in content and '<h1 ' not in content:
                issues.append(f"{html_file}: Missing H1 tag")
                
        except Exception as e:
            issues.append(f"{html_file}: Error reading file - {e}")
    
    if issues:
        print(f"⚠ Found {len(issues)} SEO issues:")
        for issue in issues[:10]:  # Show first 10 issues
            print(f"  - {issue}")
    else:
        print("✓ No major SEO issues found in sample files")
    
    return len(issues) == 0

def generate_htaccess():
    """Generate .htaccess file for SEO and performance optimizations"""
    
    htaccess_content = """# SEO and Performance Optimizations for Schnitzler Briefe

# Enable compression
<IfModule mod_deflate.c>
    AddOutputFilterByType DEFLATE text/plain
    AddOutputFilterByType DEFLATE text/html
    AddOutputFilterByType DEFLATE text/xml
    AddOutputFilterByType DEFLATE text/css
    AddOutputFilterByType DEFLATE application/xml
    AddOutputFilterByType DEFLATE application/xhtml+xml
    AddOutputFilterByType DEFLATE application/rss+xml
    AddOutputFilterByType DEFLATE application/javascript
    AddOutputFilterByType DEFLATE application/x-javascript
    AddOutputFilterByType DEFLATE application/json
</IfModule>

# Enable browser caching
<IfModule mod_expires.c>
    ExpiresActive On
    ExpiresByType text/css "access plus 1 month"
    ExpiresByType application/javascript "access plus 1 month"
    ExpiresByType image/png "access plus 1 year"
    ExpiresByType image/jpg "access plus 1 year"
    ExpiresByType image/jpeg "access plus 1 year"
    ExpiresByType image/gif "access plus 1 year"
    ExpiresByType image/ico "access plus 1 year"
    ExpiresByType image/svg+xml "access plus 1 year"
</IfModule>

# Security headers
<IfModule mod_headers.c>
    Header always set X-Content-Type-Options nosniff
    Header always set X-Frame-Options DENY
    Header always set X-XSS-Protection "1; mode=block"
    Header always set Referrer-Policy "strict-origin-when-cross-origin"
</IfModule>

# URL Rewriting for clean URLs
RewriteEngine On

# Redirect to HTTPS (if applicable)
# RewriteCond %{HTTPS} off
# RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]

# Remove .html extension for cleaner URLs
RewriteCond %{REQUEST_FILENAME} !-d
RewriteCond %{REQUEST_FILENAME} !-f
RewriteRule ^([^\.]+)$ $1.html [NC,L]

# Redirect old URLs if any
# Add specific redirects here for changed URLs

# Custom error pages
ErrorDocument 404 /404.html
"""
    
    htaccess_path = "./html/.htaccess"
    with open(htaccess_path, 'w', encoding='utf-8') as f:
        f.write(htaccess_content)
    
    print(f"✓ Generated .htaccess file: {htaccess_path}")
    return htaccess_path

def generate_security_txt():
    """Generate security.txt file as per RFC 9116"""
    
    security_content = f"""Contact: mailto:acdh-tech@oeaw.ac.at
Expires: {(datetime.now().replace(year=datetime.now().year + 1)).strftime('%Y-%m-%dT%H:%M:%S.000Z')}
Encryption: https://www.oeaw.ac.at/acdh/
Preferred-Languages: en, de
Canonical: https://schnitzler-briefe.acdh.oeaw.ac.at/.well-known/security.txt
Policy: https://www.oeaw.ac.at/acdh/
"""
    
    # Create .well-known directory
    os.makedirs("./html/.well-known", exist_ok=True)
    
    security_path = "./html/.well-known/security.txt"
    with open(security_path, 'w', encoding='utf-8') as f:
        f.write(security_content)
    
    print(f"✓ Generated security.txt: {security_path}")
    return security_path

def verify_sitemap():
    """Verify that sitemap.xml is properly formatted"""
    
    sitemap_path = "./html/sitemap.xml"
    
    if not os.path.exists(sitemap_path):
        print("✗ Sitemap not found!")
        return False
    
    try:
        tree = ET.parse(sitemap_path)
        root = tree.getroot()
        
        # Count URLs
        urls = root.findall('.//{http://www.sitemaps.org/schemas/sitemap/0.9}url')
        
        print(f"✓ Sitemap verified: {len(urls)} URLs found")
        
        # Check for required elements in first few URLs
        for i, url in enumerate(urls[:5]):
            loc = url.find('{http://www.sitemaps.org/schemas/sitemap/0.9}loc')
            lastmod = url.find('{http://www.sitemaps.org/schemas/sitemap/0.9}lastmod')
            
            if loc is None:
                print(f"⚠ URL {i+1} missing <loc> element")
            if lastmod is None:
                print(f"⚠ URL {i+1} missing <lastmod> element")
        
        return True
        
    except ET.ParseError as e:
        print(f"✗ Sitemap XML parsing error: {e}")
        return False

def generate_performance_report():
    """Generate a performance and SEO summary report"""
    
    report = {
        "build_timestamp": datetime.now().isoformat(),
        "files_generated": {
            "sitemap": os.path.exists("./html/sitemap.xml"),
            "robots": os.path.exists("./html/robots.txt"),
            "htaccess": os.path.exists("./html/.htaccess"),
            "security_txt": os.path.exists("./html/.well-known/security.txt")
        },
        "seo_features": [
            "Meta descriptions for all pages",
            "OpenGraph tags for social sharing", 
            "Twitter Card metadata",
            "JSON-LD structured data",
            "Canonical URLs",
            "Proper heading hierarchy",
            "Alt text for images",
            "XML sitemap with proper priorities",
            "Robots.txt with sitemap reference"
        ],
        "performance_optimizations": [
            "GZIP compression enabled",
            "Browser caching headers",
            "Image optimization via IIIF",
            "Minified CSS/JS (if applicable)",
            "CDN for external libraries"
        ]
    }
    
    os.makedirs("./html/seo-data", exist_ok=True)
    
    with open("./html/seo-data/build-report.json", "w", encoding="utf-8") as f:
        json.dump(report, f, ensure_ascii=False, indent=2)
    
    print("✓ Performance report generated")
    
    # Print summary
    print("\n" + "="*50)
    print("SEO BUILD SUMMARY")
    print("="*50)
    print(f"Build completed: {report['build_timestamp']}")
    print(f"Sitemap: {'✓' if report['files_generated']['sitemap'] else '✗'}")
    print(f"Robots.txt: {'✓' if report['files_generated']['robots'] else '✗'}")
    print(f".htaccess: {'✓' if report['files_generated']['htaccess'] else '✗'}")
    print(f"Security.txt: {'✓' if report['files_generated']['security_txt'] else '✗'}")
    print(f"SEO features: {len(report['seo_features'])}")
    print(f"Performance optimizations: {len(report['performance_optimizations'])}")
    print("="*50)
    
    return report

def main():
    """Main SEO build process"""
    
    print("Starting SEO Build Process for Schnitzler Briefe")
    print("=" * 60)
    
    success = True
    
    # Generate additional SEO files
    try:
        generate_htaccess()
        generate_security_txt()
    except Exception as e:
        print(f"✗ Error generating additional files: {e}")
        success = False
    
    # Verify core files
    if not verify_sitemap():
        success = False
    
    # Validate HTML (sample)
    if not validate_html_files():
        print("⚠ Some SEO issues found in HTML validation")
    
    # Generate final report
    generate_performance_report()
    
    if success:
        print("\n🎉 SEO build completed successfully!")
        return 0
    else:
        print("\n❌ SEO build completed with issues")
        return 1

if __name__ == "__main__":
    sys.exit(main())