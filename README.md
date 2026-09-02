# RaceDay

RaceDay is a full-stack, web-based event management system built for the South African road running, walking, and cycling community. It replaces the paper-based registration, spreadsheets, and disconnected communication that many local events still rely on. Event Organisers can create and manage events, categories, and participant results; Participants can browse upcoming events, enter events, track their personal performance history, and prepare for race day.

**Repository:** [https://github.com/ST10475058/RaceDay-POE.git](https://github.com/ST10475058/RaceDay-POE.git)

This repository contains Part 1 of the RaceDay Portfolio of Evidence (POE): **System Planning and Database**. This part is planning only — no application code has been written. It is made up of three sections:

- **Section A – Entity Relationship Diagram (ERD)**: the full data model for RaceDay, with six entities, primary keys, foreign keys, and cardinality shown for every relationship.
- **Section B – API Endpoint Plan**: a table covering every planned API endpoint — method, route, description, role required, request body, and expected response — for Authentication, User Profile, Events, Categories, Event Enrolments, and Results.
- **Section C – SQL Database Script**: a SQL Server script that creates and seeds the full database schema, matching the ERD exactly.

## Roles

RaceDay is designed around two distinct user roles:

- **Organiser** – creates, edits, and deletes events; manages event categories; captures participant results; views all enrolments for their events.
- **Participant** – creates an account, browses events, enters an event by selecting a category, views their own enrolments, and tracks their personal results.

## Contents

All planning documents are committed to the `/docs` folder:

- `docs/RaceDay_POE_Part1_Tim.pdf` – full write-up covering Section A (ERD with a detailed explanation of every entity and relationship), Section B (API endpoint plan), and Section C (SQL database script).
- `docs/raceday_erd.png` – the ERD image (Section A).
- `docs/raceday_database.sql` – the SQL Server script that creates and seeds the `RaceDayDB` database (Section C). Tested on a clean SQL Server instance.
- `docs/raceday_database_backup.sql` – additional SQL script backup.

## CI/CD

![CI/CD Green Build](green-build.png)

The GitHub Actions workflow validates that the `/docs` folder exists and contains all required files.

[![Validate Repository Structure](https://github.com/ST10475058/RaceDay-POE/actions/workflows/validate.yml/badge.svg)](https://github.com/ST10475058/RaceDay-POE/actions/workflows/validate.yml)

## Video Walkthrough

[Watch the video walkthrough here](https://youtu.be/your-video-link-here)

The video walks through the planning documents, explains the ERD decisions (Section A), covers the endpoint plan choices (Section B), and runs the SQL script live in SSMS (Section C). The voiceover is by the student (no AI-generated voices).
