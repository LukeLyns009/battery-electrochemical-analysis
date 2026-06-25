# 🔋 Battery Electrochemical Analysis
### NASA PCoE Dataset · Python · SQL · Data Visualization

![Python](https://img.shields.io/badge/Python-3.10+-blue?logo=python)
![SQL](https://img.shields.io/badge/SQL-SQLite-lightgrey?logo=sqlite)
![Plotly](https://img.shields.io/badge/Viz-Plotly%20%7C%20Matplotlib%20%7C%20Seaborn-orange)

> **A full end-to-end data analysis project combining electrochemical domain knowledge with advanced SQL and Python visualisation — built for Business Analyst / Data Analyst portfolio.**

---

## 📌 Project Overview

This project analyses the **NASA Battery Prognostics Dataset** (cells B0005, B0006, B0007, B0018) across three analytical chapters:

| Chapter | Question | Key Techniques |
|---------|----------|---------------|
| **1 — Degradation** | Which cells degrade fastest and why? | CTEs, LAG, RANK, NTILE, rolling window functions |
| **2 — Operations** | How do charge conditions affect capacity retention? | CASE bucketing, Pearson correlation, percentile bands |
| **3 — RUL Prediction** | Can we predict remaining useful life? | Feature engineering via SQL, exponential decay fit, linear regression |

**End-of-Life threshold:** SOH < 80% (industry standard)

---

## 🗂️ Repository Structure

```
battery-project/
│
├── notebooks/
│   └── battery_analysis.ipynb      # Main analysis notebook
│
├── sql/                            # All SQL queries as standalone files
│   ├── ch1_soh_trajectory.sql      # SOH fade with CTEs + window functions
│   ├── ch1_degradation_rank.sql    # FIRST_VALUE / LAST_VALUE / RANK
│   ├── ch1_resistance_heatmap.sql  # NTILE life-stage segmentation
│   ├── ch2_operational_trends.sql  # CASE bucketing + grouped aggregation
│   ├── ch2_capacity_bands.sql      # Distribution bands (min/avg/max)
│   └── ch3_rul_features.sql        # Full feature engineering for RUL
│
├── data/
│   └── nasa_battery_data.csv       # NASA PCoE calibrated dataset
│
├── outputs/
│   ├── figures/                    # Static PNG charts
│   └── interactive/                # Plotly HTML charts
│
└── README.md
```

---

## 🔍 Key Findings

- **B0018** degrades fastest at **0.0385% SOH/cycle**; **B0007** is most durable at 0.0298%/cycle
- **Internal resistance** shows r > 0.9 correlation with capacity — strongest real-time health signal
- **Charge time drift** (+12 min from early to late life) is a low-cost early-warning indicator
- A simple **linear RUL model** achieves R² ≈ 0.82 using only observable electrochemical features

---

## 🛠️ Tech Stack

| Layer | Tool |
|-------|------|
| Data storage | SQLite (via SQLAlchemy) |
| Query engine | SQL — CTEs, window functions, NTILE, LAG, RANK |
| Analysis | Python · Pandas · NumPy · SciPy · scikit-learn |
| Visualisation | Matplotlib · Seaborn · Plotly (interactive) |

---

## ▶️ How to Run

```bash
# 1. Clone the repo
git clone https://github.com/<your-username>/battery-electrochemical-analysis.git
cd battery-electrochemical-analysis

# 2. Install dependencies
pip install pandas numpy matplotlib seaborn plotly scipy scikit-learn sqlalchemy jupyter

# 3. Launch the notebook
jupyter lab notebooks/battery_analysis.ipynb
```

The notebook loads `data/nasa_battery_data.csv`, pushes it into a local SQLite database, then runs each `.sql` file from the `sql/` directory for every analysis step.

---

## 📚 Dataset

**NASA Prognostics Center of Excellence (PCoE) Battery Dataset**  
Cells: B0005, B0006, B0007, B0018 (18650 Li-ion)  
Conditions: Charge at 1.5A to 4.2V · Discharge at 2A · 24°C ambient  
Variables: Capacity (Ah), Internal Resistance (Ω), Voltage, Charge/Discharge Time, Temperature

---

## 👤 Author

**Shakti** — M.Sc. IIT Bombay (Electrochemistry & Battery Research)  
Anthropic AI Fluency Certified · Joining Prof. T. Pradeep's group, IIT Madras

---

*Built as a portfolio project demonstrating domain expertise + SQL + Python data analysis skills.*
