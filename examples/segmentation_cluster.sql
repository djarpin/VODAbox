-- Cluster customers
\o segmentation_cluster.log

-- Run kmeans clustering algorithm
drop table if exists segmentation_centroid;
create table segmentation_centroid as
select *
from madlib.kmeanspp('segmentation_proj',
                     'row_vec',
                     4);

-- Allocate customers to a cluster
drop table if exists segmentation_cluster;
create table segmentation_cluster as
select s.row_id, 
       (madlib.closest_column(centroids, row_vec)).column_id as cluster_id
from segmentation_proj s,
     (select centroids
      from segmentation_centroid) c
order by row_id;

-- Look for differences in clusters
drop table if exists segmentation_summary;
create table segmentation_summary as
with cluster_subcat as
(select c.cluster_id, r.product_subcategory,
        sum(exp(s.log_sales) - 1) as sales
 from segmentation s
 inner join segmentation_cluster c
 on s.row_id = c.row_id
 inner join product_class r
 on s.product_class_id = r.product_class_id
 group by c.cluster_id, r.product_subcategory)
select cs.cluster_id, cs.product_subcategory, cs.sales,
       100 * cs.sales / c.cluster_sales / (s.subcat_sales / (select sum(sales) from cluster_subcat)) as sales_index
from cluster_subcat cs
inner join (select cluster_id,
                   sum(sales) as cluster_sales
            from cluster_subcat
            group by cluster_id) c
on cs.cluster_id = c.cluster_id
inner join (select product_subcategory,
                   sum(sales) as subcat_sales
            from cluster_subcat
            group by product_subcategory) s
on cs.product_subcategory = s.product_subcategory
order by cluster_id, sales_index desc;

-- look at output
select *
from segmentation_summary;
