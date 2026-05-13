with source as (
    select * from {{ source('social_cloud_schema', 'raw_posts_interacciones') }}
)
select * from source