with source as (
    select * from {{ source('social_cloud_schema', 'raw_audiencia_demografica') }}
)
select * from source