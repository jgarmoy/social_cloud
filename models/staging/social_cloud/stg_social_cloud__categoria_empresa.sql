with source as (
    select * from {{ source('social_cloud_schema', 'raw_perfiles_empresas') }}
),
generar_surrogate_key as (
    select distinct
        {{ dbt_utils.generate_surrogate_key(['lower(empresa_categoria)']) }} as id_categoria_empresa,
        lower(empresa_categoria) as nombre
    from source
)

select * from generar_surrogate_key