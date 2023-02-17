import abagen
import warnings
from nilearn.datasets import fetch_atlas_schaefer_2018
warnings.filterwarnings('ignore', category=FutureWarning)

schaefer = fetch_atlas_schaefer_2018(n_rois=400)
norm_method = 'srs'
expression, report = abagen.get_expression_data(schaefer['maps'], lr_mirror="bidirectional", missing="interpolate",
                                                sample_norm=norm_method, gene_norm=norm_method,
                                                return_donors=False, return_report=True)
file_path = 'F:/Cui_Lab/Projects/Connectional_Hierarchy/step_05_correlated_gene_expression_network/'
expression.to_csv(file_path + 'gene_expressions_schaefer400.csv')
fh = open(file_path + 'report_correlated_gene_expressions.txt', 'w', encoding='utf-8')
fh.write(report)
fh.close()