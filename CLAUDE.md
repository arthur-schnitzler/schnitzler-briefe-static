# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository contains a static website generator for Arthur Schnitzler's correspondence. The project fetches data from external repositories and transforms TEI XML files into HTML using XSLT transformations. It serves as a replacement for an existDB-based website.

## Build Commands

### Main Build Process
- `./transform.sh` - Main build script that runs the complete transformation pipeline
- `ant` - Execute the XSLT transformations using the build.xml configuration

### Data Fetching
- `./fetch_data.sh` - Downloads and sets up all required data from external repositories

### Individual Python Scripts
- `python delete_faulty_files.py` - Clean up corrupted or problematic files
- `python add_mentions.py` - Process entity mentions and cross-references  
- `python make_calendar_data.py` - Generate calendar/chronological data
- `python make_typesense_index.py` - Build full-text search index

## Architecture

### Data Sources
The project fetches data from multiple GitHub repositories:
- `schnitzler-briefe-data` - Primary correspondence data (TEI XML)
- `schnitzler-chronik-data` - Chronological/biographical data
- `schnitzler-briefe-tex` - PDF versions of letters
- `schnitzler-briefe-charts` - Network analysis data

### Processing Pipeline
1. **Data Fetch**: External data downloaded via `fetch_data.sh`
2. **Python Processing**: Entity processing, calendar generation, search indexing
3. **XSLT Transformation**: TEI XML → HTML via Saxon processor with build.xml
4. **Output**: Static HTML files in `./html/` directory

### Key Directories
- `data/` - TEI XML source files (fetched from external repos)
- `xslt/` - XSLT stylesheets for HTML transformation
- `html/` - Generated static website output
- `chronik-data/` - Chronological data files
- `arche/` - ARCHE repository metadata and scripts

### XSLT Processing
Uses Saxon HE 9 processor with multiple transformations:
- Letters: `editions.xsl` transforms individual correspondence files
- Indexes: Separate stylesheets for persons, places, organizations, etc.
- Navigation: Table of contents and calendar views
- Metadata: Various listing and search pages

## Development Notes

- The project uses Apache Ant for build orchestration
- Python dependencies managed via requirements.txt (TEI processing utilities)
- XSLT 2.0 features used extensively via Saxon processor
- Output includes both HTML and XML versions of documents
- PDF files are integrated from external LaTeX compilation repository