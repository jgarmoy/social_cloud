with
    source_perfiles as (
        select * from {{ ref("stg_social_cloud_schema__raw_perfiles_empresas") }}
    ),
    source_audiencia as (select * from {{ ref("int_audiencia_demografica") }}),
    unificado as (
        select initcap(trim(empresa_pais)) as pais
        from source_perfiles

        union

        select initcap(trim(pais)) as pais
        from source_audiencia
        where pais is not null
    ),

    generar_surrogate_key as (
        select
            {{ dbt_utils.generate_surrogate_key(["pais"]) }} as id_pais, pais as nombre
        from unificado
    )

select *
from generar_surrogate_key
