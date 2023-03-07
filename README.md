# Connectional_Hierarchy
Data and codes for our paper **"Connectional Hierarchy in Human Brain Revealed by Individual Variability of Functional Network Edges"**.

*Inter-individual fc variability* matrices for both **HCP-D** and **HCP-YA** (typically referred as **'HCP'**), and the network of *hemodynamic connectivity*, *electromagnetic connectivity*, *white matter structural connectivity*, *correlated gene expression*, *receptor similarity* and *cognitive similarity* are obtained using `Schaefer-400` (7 Networks order); the network of *disorder similarity* are obtained using `Cammoun-033`/`Desikan-Killiany` (68 cortical regions in different order) . See [data](data/) for more details.

## `data`
- The [sub_info](data/sub_info) folder contains the subject information (`sub_id`,`age` and `gender`) used in this study.
- The [fc_variability](data/fc_variability) folder contains the *inter-individual fc variability* matrix for both HCP-D and HCP, saved in the `.mat` file. Particularly, the `.mat` file is a struct variable with 2 fields which stores the fc variability matrix estimated by `Schaefer-400` or `Cammoun-033`. 
- The [network_matrix](data/network_matrix) folder contains the brain networks constructed by *hemodynamic connectivity*, *electromagnetic connectivity*, *white matter structural connectivity*, *correlated gene expression*, *receptor similarity*, *cognitive similarity* and *disorder similarity*. Except the *disorder similarity*, which was constructed by the `Cammoun-033`, all network matrices were obtained based on `Schaefer-400` atlas.

- The [enigma_results](data/enigma_results) folder contains the statistical results of cortical thickness abnormality for 13 disorders, including *22q11.2 deletion syndrome*, *attention-deficit/hyperactivity disorder*, *autism spectrum disorder*, *epilepsy (idiopathic generalized, right temporal lobe, and left temporal lobe)*, *depression*, *obsessive-compulsive disorder*, *schizophrenia*, *bipolar disorder*, *obesity*, *schizotypy*, and *Parkinson’s disease*.
- The [parcellation_files](data/parcellation_files) folder contains the parcellation files used in this study.

## `code`
- The [step_01_individual_fc_variability](step_01_individual_fc_variability/) folder contains codes to estimate the individual variability of functional connectivity. 
- The [step_02_connectional_hierarchy_of_inter_individual_fc_variability](step_02_connectional_hierarchy_of_inter_individual_fc_variability/) folder contains codes to generate results and figures of *Figure 1. Individual variability of edge-wise functional connectivity reveals connectional hierarchy in the human brain*. 
- The [step_03_bold_meg_functional_network](step_03_bold_meg_functional_network/) folder contains codes to generate results and figures of *Figure 2. Hemodynamic and electrophysiological functional connectome basis of connectional hierarchy*.
- The [step_04_white_matter_structural_network](step_04_white_matter_structural_network/) folder contains codes to generate results and figures of *Figure 3. Structural connectome basis of connectional hierarchy in FC variability*. 
- The [step_05_correlated_gene_expression_network](step_05_correlated_gene_expression_network/) folder contains codes to generate results and figures of *Figure 4. Transcriptional similarity of gene expression underlying connectional hierarchy*.
- The [step_06_receptor_similarity_network](step_06_receptor_similarity_network/) folder contains codes to generate results and figures of *Figure 5. Network of neurotransmitter receptors and transporters expression shapes connectional hierarchy*.
- The [step_07_cognitive_similarity_network](step_07_cognitive_similarity_network/) folder contains codes to generate results and figures of *Figure 6. Implications of connectional hierarchy in cognitions*.
- The [step_08_disorder_similarity_network](step_08_disorder_similarity_network/) folder contains codes to generate results and figures of *Figure 7. Implications of connectional hierarchy on brain disorders*. 
- The [step_09_developments_of_connectional_hierarchy](step_09_developments_of_connectional_hierarchy/) folder contains codes to generate results and figures of *Figure 8. Development of connectional hierarchy in youth*.

## `functions`
The [functions](functions/) folder contains code and files commonly used in `code`.

## `wiki`
The detailed description about the codes used in this study, from `step_01_individual_fc_variability` to `step_09_developments_of_connectional_hierarchy`, can be found [here](https://github.com/CuiLabCIBR/Connectional_Hierarchy/wiki).

## `note`
The current repository does include code and data used in the supplementary analyses (control the *Euclidean distance*), these will be added in the near future. The FC matrices for HCP-D and HCP-YA have not been uploaded due to the limitation of large single file.

