with
    source as (
        select * from {{ ref("stg_social_cloud_schema__raw_perfiles_empresas") }}
    ),
    generar_surrogate_key as (
        select distinct
            {{ dbt_utils.generate_surrogate_key(["empresa_categoria"]) }}
            as id_categoria_empresa,
            empresa_categoria as nombre
        from source
    )

select *
from generar_surrogate_key
