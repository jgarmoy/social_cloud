with source as (
    select * from {{ source('social_cloud_schema', 'raw_posts_interacciones') }}
),
generar_surrogate_key as (
    select distinct
        {{ dbt_utils.generate_surrogate_key(['lower(tipo_interaccion)']) }} as id_tipo_interaccion,
        lower(tipo_interaccion) as nombre
    from source
)
select * from generar_surrogate_key