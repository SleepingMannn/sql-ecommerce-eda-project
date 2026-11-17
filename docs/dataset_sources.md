# Dataset & Attribution

This project uses the **Brazilian E-Commerce Public Dataset by Olist**, published by Olist on Kaggle.

- **Original source:** [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
- **Data provider:** Olist
- **License:** [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/)
- **Data period:** 2016–2018

The original dataset was provided by Olist and published on Kaggle. The data used in this project has been processed and transformed through Bronze, Silver, and Gold layers. Additional manual enrichment and data preparation steps are documented in the project.

The original dataset is not included in this repository. Please download it directly from the original Kaggle source and follow the applicable license terms.

**Attribution:** Olist, *Brazilian E-Commerce Public Dataset by Olist*, Kaggle.

### Modifications

The original data was changed in the following ways:
- Source column typos fixed (`lenght` → `length`).
- `order_estimated_delivery_date` converted from timestamp to date.
- State codes replaced by full state names.
- Two English category names added manually (`portable_kitchen_food_preparers`, `pc_gamer`); the English names were chosen by the project author, not by Olist.

### License Scope

The MIT License in this repository applies to the original SQL scripts and documentation created for this project.
The original Olist dataset is subject to its own license: CC BY-NC-SA 4.0.
The repository does not redistribute the original CSV files. Users should obtain the dataset from the original Kaggle source and follow its license terms.
