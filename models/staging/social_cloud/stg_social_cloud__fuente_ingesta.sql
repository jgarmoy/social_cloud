with source as (
    select * from {{ source('social_cloud_schema', 'raw_posts_interacciones') }}
),
generar_surrogate_key as (
    select distinct
        {{ dbt_utils.generate_surrogate_key(['lower(source_api)']) }} as id_fuente_ingesta,
        lower(source_api) as nombre
    from source
)
select * from generar_surrogate_key