with
    source as (
        select * from {{ ref("stg_social_cloud_schema__raw_posts_interacciones") }}
    ),
    renamed as (
        select post_id, plataforma, lower(substr(value, 2)) as hashtag
        from source, lateral split_to_table(source.hashtags, ' ')
    )

select *
from renamed
