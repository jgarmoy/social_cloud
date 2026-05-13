with source as (
    select * from {{ source('social_cloud_schema', 'raw_posts_interacciones') }}
),
renamed as (
    select distinct
        lower(substr(value, 2)) as hashtag
    from source, lateral split_to_table(source.hashtags, ' ')
),
generar_surrogate_key as (
    select
        {{ dbt_utils.generate_surrogate_key(["hashtag"]) }} as id_hashtag,
        hashtag as hashtag
    from renamed
)
select * from generar_surrogate_key