with source_perfiles as (
    select * from {{ source('social_cloud_schema', 'raw_perfiles_empresas') }}
),
source_audiencia as (
    select * from {{ source('social_cloud_schema', 'raw_audiencia_demografica') }}
),
source as (
    select
        distinct lower(coalesce(empresa_pais, 'Desconocido')) as pais
    from source_perfiles
    union 
    select 
        distinct lower(coalesce(country, 'Desconocido')) as pais
    from source_audiencia
    union
    select 
        distinct lower(coalesce(audience_country, 'Desconocido')) as pais
    from source_audiencia
    union
    select 
        distinct lower(coalesce(pais_audiencia, 'Desconocido')) as pais
    from source_audiencia
),
generar_surrogate_key as (
    select 
        {{ dbt_utils.generate_surrogate_key(['pais']) }} as id_pais,
        pais as nombre
    from source
)

select * from generar_surrogate_key