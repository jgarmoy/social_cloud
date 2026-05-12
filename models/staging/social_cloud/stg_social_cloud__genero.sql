with source as (
    select * from {{ source('social_cloud_schema', 'raw_audiencia_demografica') }}
),
unir_generos_tk_yt_ig as (
    select distinct
        gender_segment as genero
    from source
    union
    select distinct
        audience_gender as genero
    from source
    union
    select distinct
        sexo as genero
    from source
),
generar_surrogate_key as (
    select
        {{ dbt_utils.generate_surrogate_key(["lower(coalesce(genero, 'Desconocido'))"]) }} as id_genero,
        lower(coalesce(genero, 'Desconocido')) as nombre
    from unir_generos_tk_yt_ig
)
select * from generar_surrogate_key