with source as (
    select * from {{ source('social_cloud_schema', 'raw_audiencia_demografica') }}
),
obtener_genero as (
    select
        coalesce(gender_segment)
    from source
),
generar_surrogate_key as (
    select
        {{ dbt_utils.generate_surrogate_key(["lower(coalesce(genero, 'Desconocido'))"]) }} as id_genero,
        lower(coalesce(genero, 'Desconocido')) as nombre
    from unir_generos_tk_yt_ig
)
select * from generar_surrogate_key