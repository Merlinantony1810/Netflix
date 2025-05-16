
# 📊 Netflix Content Analysis using SQL

## 📝 Overview

This project presents a comprehensive SQL-based analysis of Netflix's movies and TV shows dataset. The primary objective is to derive actionable insights from the data to support content strategy, regional performance evaluation, user experience optimization, and historical content trends.

The project explores various dimensions such as content type distribution, top contributing countries, genre frequency, average durations, director-specific trends, and content addition patterns over time.

## 🎯 Objectives

- Analyze the distribution of content types (Movies vs. TV Shows).
- Identify the countries producing the most Netflix content.
- Examine trends in content releases by year and cumulative growth.
- Explore genre distribution and the most common content listings.
- Evaluate director contributions and actor-specific content.
- Extract insights about duration trends and top-performing titles.
- Build SQL functions and views for reusability and reporting.

## 📁 Dataset

This project uses the **Netflix Movies and TV Shows** dataset from Kaggle.

- 📌 [Kaggle Dataset – Netflix Shows](https://www.kaggle.com/datasets/shivamb/netflix-shows)

Please download the dataset and load it into your SQL database (e.g., PostgreSQL) before running the queries.

## 🛠️ Tools & Technologies

- PostgreSQL
- SQL (Window Functions, CTEs, Views, Stored Functions)
- pgAdmin / DBeaver (for database querying and visualization)

## 📌 Key Insights & Highlights

- **Top Countries**: USA, India, UK dominate Netflix’s content library.
- **Content Type**: Movies make up the majority of Netflix’s content.
- **Most Frequent Ratings**: TV-MA and TV-14 are the most common.
- **Release Trends**: A significant rise in content after 2015.
- **Longest Movies**: Identified by parsing the `duration` field.
- **Prolific Directors**: Analyzed frequency of directors’ work.
- **Reusable Functions**: Created PL/pgSQL functions for dynamic queries like actor appearance count or content by year.

