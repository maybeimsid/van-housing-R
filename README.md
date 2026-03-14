# Non-Market Housing Dashboard

This project is an interactive dashboard built using **Shiny for R** to explore non-market housing data for the City of Vancouver.

The dashboard allows users to filter housing projects and view key summary information, including:

* Total number of non-market housing units
* A table summarizing completed housing projects
* Filters for clientele type and occupancy year

Users can interact with the filters in the sidebar to dynamically update the displayed metrics and project table.

**PS:** This is a simplified version of the main dashboard, which was originally implemented using **Shiny for Python**. [Link](https://019ca11c-80e1-200e-f440-05e01724ec0a.share.connect.posit.cloud/)

---

## Requirements

This project assumes the following software is already installed:

* **R (version 4.1 or higher recommended)**
* **RStudio** (optional but recommended)

---

## Installation

### Clone the repository

```bash
git clone git@github.com:maybeimsid/van-housing-R.git
```

Then navigate to the project folder.

---

### Install dependencies

Run the following command in R:

```r
install.packages(c(
  "shiny",
  "dplyr",
  "DT",
  "bslib"
))
```

---

## Running the app

Run the following command in R:

```r
shiny::runApp()
```

This will launch the dashboard locally in your browser.

---

## Live view

You can view the deployed dashboard here:

[Live Dashboard Link](https://019cea87-7a08-fb64-6b12-39c183645adf.share.connect.posit.cloud/)
