with source as (
    select * from {{ source('social_cloud_schema_modificar_perfil', 'raw_modificar_perfil_social') }}
),
renombrar as (
    select
        id_perfil_social,
        codigo_perfil_social,
        id_empresa,
        id_red_social,
        nombre_usuario,
        fecha_creacion,
        activo,
        _fivetran_synced
    from source
)

select * from renombrar