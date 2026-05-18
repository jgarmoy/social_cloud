with
    source as (
        select * from {{ ref("stg_social_cloud_schema__raw_perfiles_empresas") }}
    ),

    renombrar as (
        select
            perfil_id as codigo_perfil_social,
            {{ dbt_utils.generate_surrogate_key(["empresa_id"]) }} as id_empresa,
            {{ dbt_utils.generate_surrogate_key(["plataforma"]) }} as id_red_social,
            username as nombre_usuario,
            fecha_creacion_perfil as fecha_creacion,
            activo
        from source
        qualify
            row_number() over (
                partition by username, plataforma order by created_at desc
            )
            = 1
    ),

    generar_surrogate_key_perfil_social as (
        select
            {{ dbt_utils.generate_surrogate_key(["id_empresa", "id_red_social"]) }}
            as id_perfil_social,
            codigo_perfil_social,
            id_empresa,
            id_red_social,
            nombre_usuario,
            fecha_creacion,
            activo
        from renombrar
    )

select *
from generar_surrogate_key_perfil_social
