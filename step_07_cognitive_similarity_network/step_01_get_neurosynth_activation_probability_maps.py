# 123 cognitive terms were selected from the Cognitive Atlas (https://www.cognitiveatlas.org/)
# following the previous study (Hansen, 2021).
# Hansen, J. Y., Markello, R. D., Vogel, J. W., Seidlitz, J., Bzdok, D., & Misic, B. (2021). 
# Mapping gene transcription and neurocognition across human neocortex. Nature Human Behaviour, 5(9), 1240-1250.


from neurosynth import Dataset
from neurosynth import meta
import numpy as np
import pandas as pd
from scipy import sparse
import os

file_path = 'F:/Cui_Lab/Projects/Connectional_Hierarchy/step_07_cognitive_similarity_network/'
dataset = Dataset(file_path + 'cognitive_atlas/database.txt')
feature_data_sparse = sparse.load_npz(file_path + 'cognitive_atlas/data-neurosynth_version-7_vocab-terms_source-abstract_type-tfidf_features.npz')
feature_data = feature_data_sparse.todense()
metadata_df = pd.read_table(file_path + 'cognitive_atlas/data-neurosynth_version-7_metadata.tsv.gz')
ids = metadata_df['id'].tolist()
feature_names = np.genfromtxt(file_path + 'cognitive_atlas/data-neurosynth_version-7_vocab-terms_vocabulary.txt', dtype=str, delimiter='/t').tolist()
feature_df = pd.DataFrame(index=ids, columns=feature_names, data=feature_data)
dataset.add_features(feature_df,duplicates = 'ignore')
dataset.save(file_path + 'cognitive_atlas/dataset.pkl')
base_dir = file_path + 'cognitive_atlas/images'
out_dir = os.path.abspath(file_path + 'cognitive_atlas')
os.makedirs(out_dir, exist_ok=True)
cognitive_atlas = pd.read_csv(file_path + 'cognitive_atlas/cognitive_atlas.csv') # 123 cognitive terms
selected_term = cognitive_atlas['cognitive_terms'].to_list()
for term in selected_term:
    ids = dataset.get_studies(features=term)
    ma = meta.MetaAnalysis(dataset, ids)
    output_dir = os.path.join(base_dir,term)
    os.makedirs(output_dir)
    ma.save_results(output_dir, term)