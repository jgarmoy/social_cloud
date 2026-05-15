with
    source as (
        select * from {{ ref("stg_social_cloud_schema__raw_perfiles_empresas") }}
    ),
    renamed as (
        select distinct
            {{ dbt_utils.generate_surrogate_key(["username"]) }} as id_perfil_social,
            perfil_id as codigo_perfil_social,
            {{ dbt_utils.generate_surrogate_key(["empresa_nombre"]) }} as id_empresa,
            {{ dbt_utils.generate_surrogate_key(["plataforma"]) }} as id_red_social,
            username as nombre_usuario,
            fecha_creacion_perfil as fecha_creacion,
            activo
        from source
    )

select *
from renamed