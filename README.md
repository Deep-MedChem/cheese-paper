# CHEESE: Supplementary Material

[![DOI](https://zenodo.org/badge/881508101.svg)](https://doi.org/10.5281/zenodo.14019962)

Welcome in CHEESE paper supplementary material. Here you can find additional information and data that was not included in the main manuscript as well as detailed result .csv files and even R scripts used to generate the figures.

## Contents:

```python
├── README.md
├── dude # DUD-E Benchmark
│   ├── bedroc20_cheese_koes2014_eberhardt2021.csv
│   ├── bedroc80_cheese_chaput2016.csv
│   ├── boxplot_bedroc_chaput_simple.R
│   ├── boxplot_targets.R
│   ├── chaput_targets.R
│   ├── chaput_targets.svg
│   ├── dude_bedroc20_koes.svg
│   ├── dude_cheese_chaput.svg
│   └── koes_eberhardt_targets.svg
├── litpcba # LIT-PCBA Unbiased Benchmark
│   ├── batch_boxplot_scaled.svg
│   ├── batch_ef1_litpcba.csv
│   ├── batch_heatmap.svg
│   ├── batch_plots copy.R
│   ├── batch_plots.R
│   ├── batch_pooling.R
│   ├── batch_pooling_median_esp.csv
│   ├── batch_pooling_median_shape.csv
│   ├── single_boxplot.svg
│   ├── single_ef1_litpcba.csv
│   ├── single_heatmap.svg
│   └── single_plots.R
├── sidechain_vs # Sidechain Virtual Screening
│   ├── barplot.R
│   ├── moesm_bar.svg
│   └── roc_mean.csv
├── retrieval_distributions # Retrieval Distributions Benchmark
│   ├── dist_espsim.svg
│   ├── dist_shapesim.svg
│   ├── distributions.R
│   ├── espsim_distributions_combined.csv
│   ├── kolmogorov_smirnov.R
│   ├── ks_espsim_results.csv
│   ├── ks_shapesim_results.csv
│   └── shapesim_distributions_combined.csv
└── utils
    └── smiles_standardization.py # SMILES standardization function
```

## Notes

- R scripts were written in `R version 4.4.1 Patched (2024-09-30 r87211) -- "Race for Your Life"`
- Python scripts were written in `Python 3.9.7`

## References

```
@article{litpcba2020,
  title={LIT-PCBA: An Unbiased Data Set for Machine Learning and Virtual Screening},
  author={Tran-Nguyen, Viet-Khoa and Jacquemard, Célien and Rognan, Didier},
  journal={Journal of Chemical Information and Modelling},
  volume={60},
  number={9},
  pages={4263--4273},
  year={2020},
  doi={10.1021/acs.jcim.0c00155}
}

@article{dude2019,
  title={Hidden bias in the DUD-E dataset leads to misleading performance of deep learning in structure-based virtual screening},
  author={Chen, Lieyang and Cruz, Anthony and Ramsey, Steven and Dickson, Callum J. and Duca, Jose S. and Hornak, Viktor and Koes, David R. and Kurtzman, Tom},
  journal={PLoS ONE},
  volume={14},
  number={8},
  year={2019},
  doi={10.1371/journal.pone.0220113}
}

@article{sidechain2020,
  title={Side chain virtual screening of matched molecular pairs: a PDB-wide and ChEMBL-wide analysis},
  author={Baumgartner, Matthew P. and Evans, David A.},
  journal={Journal of Computer-Aided Molecular Design},
  volume={34},
  number={9},
  pages={953--963},
  year={2020},
  doi={10.1007/s10822-020-00313-1}
}


@article{chaput2016,
  title={Benchmark of four popular virtual screening programs: construction of the active/decoy dataset remains a major determinant of measured performance},
  author={Chaput, Ludovic and Martinez-Sanz, Juan and Saettel, Nicolas and Mouawad, Liliane},
  journal={Journal of Cheminformatics},
  volume={8},
  number={1},
  pages={56},
  year={2016},
  doi={10.1186/s13321-016-0167-x}
}

@article{koes2014,
  title={Shape-based virtual screening with volumetric aligned molecular shapes},
  author={Koes, D. R. and Camacho, C. J.},
  journal={Journal of Computational Chemistry},
  volume={35},
  year={2014},
  doi={10.1002/jcc.23690}
}

@article{eberhardt2021,
  title={AutoDock Vina 1.2.0: New Docking Methods, Expanded Force Field, and Python Bindings},
  author={Eberhardt, Jerome and Santos-Martins, Diogo and Tillack, Andreas F. and Forli, Stefano},
  journal={Journal of Chemical Information and Modelling},
  volume={61},
  number={8},
  pages={3891--3898},
  year={2021},
  doi={10.1021/acs.jcim.1c00203}
}
```
