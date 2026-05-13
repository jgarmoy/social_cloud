with source as (
    select * from {{ source('social_cloud_schema', 'raw_perfiles_empresas') }}
)
select * from source