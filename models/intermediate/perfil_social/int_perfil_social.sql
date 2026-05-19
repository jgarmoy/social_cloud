with
    source as (
        select * from {{ ref("stg_social_cloud_schema__raw_perfiles_empresas") }}
    ),

    renombrar_generar_surrogate_key_perfil_social as (
        select
            {{ dbt_utils.generate_surrogate_key(["perfil_id"]) }} as id_perfil_social,
            perfil_id as codigo_perfil_social,
            {{ dbt_utils.generate_surrogate_key(["empresa_id"]) }} as id_empresa,
            {{ dbt_utils.generate_surrogate_key(["plataforma"]) }} as id_red_social,
            username as nombre_usuario,
            fecha_creacion_perfil as fecha_creacion,
            activo,
            _fivetran_synced
        from source
        qualify
            row_number() over (
                partition by username, plataforma order by created_at desc
            )
            = 1
    )

select *
from renombrar_generar_surrogate_key_perfil_social
