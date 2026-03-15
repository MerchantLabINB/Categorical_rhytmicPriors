# Categorical Rhythmic Priors in Macaques

This repository contains the MATLAB code and data analysis pipeline for the study:  
**"Categorical rhythmic priors in macaques"** (Castillo-Almazán et al., 2025).

The codebase supports the investigation of rhythmic synchronization and categorical internal representations in Rhesus monkeys (*Macaca mulatta*), specifically focusing on their ability to generalize complex rhythms across varied tempi.

## 📋 Table of Contents
- [Project Overview](#project-overview)
- [Key Features](#key-features)
- [Installation & Requirements](#installation--requirements)
- [Usage](#usage)
- [Citation](#citation)

## 🔬 Project Overview
This project explores how macaques synchronize to isochronous and non-isochronous rhythms. Using an **Iterated Reproduction** paradigm (similar to the "broken telephone game"), we used this code to reveal the internal "priors" or rhythmic categories (like 1:1 or 1:2 ratios) that monkeys hold. We compared the results of the monkey against human synchronization in visual and auditory modalities.

## 🚀 Key Features
The MATLAB scripts included here perform the following:
* **Iterated Reproduction Analysis:** * Evaluates convergence using **Jensen-Shannon divergence (JSD)**.
* **Categorical Analysis:** Identifies peaks in rhythmic ratios and performs bootstrapping for 95% confidence intervals. Identifies categories in a 2D density plot.
![peaks and categories](https://github.com/MerchantLabINB/Categorical_rhytmicPriors/blob/db13b96f81dedac666a3f625350de83cefae4cd1/peaks_categories.png)

## 💻 Installation & Requirements
- **Software:** MATLAB (Recommended version R2021a or later). For the analysis in the article, MATLAB R2025b was used.

1. Clone the repository:
   ```bash
   git clone [https://github.com/YourUsername/Macaque-Rhythmic-Priors.git](https://github.com/YourUsername/Macaque-Rhythmic-Priors.git)
2. Get the dataset from:
   Data_AllGrps.mat

## 📝 Citation
If you use the database or the code, please cite the original article:
Castillo-Almazán, A., Prado, L., Jacoby, N., & Merchant, H. (2025). Categorical rhythmic priors in macaques. bioRxiv. [https://www.biorxiv.org/content/10.64898/2025.12.29.696861v1]

## 📬 Contact
For any questions or queries about the project, please contact:
Hugo Merchant, hugomerchant@unam.mx

For any query on the code or database, please contact:
Ameyaltzin Castillo-A, ameyaltzin.ca@gmail.com
