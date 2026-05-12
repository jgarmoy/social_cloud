with source as (
    select * from {{ source('social_cloud_schema', 'raw_perfiles_empresas') }}
),
renamed as (
    select 
        {{ dbt_utils.generate_surrogate_key(["empresa_nombre"]) }} as id_empresa,
        empresa_id as codigo_empresa,
        empresa_nombre as nombre,
        {{ dbt_utils.generate_surrogate_key(["lower(coalesce(empresa_pais, 'Desconocido'))"]) }} as id_pais,
        {{ dbt_utils.generate_surrogate_key(["lower(coalesce(empresa_categoria, 'Desconocido'))"]) }} as id_categoria_empresa,
        empresa_web as web,
        empresa_email as email
    from source
)
select * from renamed order by codigo_empresa