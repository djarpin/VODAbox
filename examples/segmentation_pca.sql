-- Principal component analysis
\o segmentation_pca.log

-- Find principal component formulas
drop table if exists segmentation_pca;
drop table if exists segmentation_pca_mean;
select madlib.pca_sparse_train('segmentation',
                               'segmentation_pca',
                               'row_id',
                               'col_id',
                               'log_sales',
                               5581,
                               102,
                               5);

-- Project data into principal component space
drop table if exists segmentation_proj;
select madlib.pca_sparse_project('segmentation',
                                 'segmentation_pca',
                                 'segmentation_proj',
                                 'row_id',
                                 'col_id',
                                 'log_sales',
                                 5581,
                                 102);

-- Look at top rows of projection
select *
from segmentation_proj
limit 10;
