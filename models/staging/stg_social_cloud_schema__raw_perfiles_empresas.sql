with
    source as (
        select * from {{ source("social_cloud_schema", "raw_perfiles_empresas") }}
    ),
    renamed as (
        select
            trim(empresa_id) as empresa_id,
            trim(empresa_nombre) as empresa_nombre,
            initcap(trim(empresa_categoria)) as empresa_categoria,
            initcap(trim(empresa_pais)) as empresa_pais,
            trim(empresa_web) as empresa_web,
            trim(empresa_email) as empresa_email,
            trim(perfil_id) as perfil_id,
            case
                when username ilike '@%' then substr(username, 2) else username
            end as username,
            case
                when regexp_like(trim(plataforma), '^(instagram|ig|insta)$', 'i')
                then 'Instagram'
                when regexp_like(trim(plataforma), '^(tiktok|tk|tik tok)$', 'i')
                then 'Tiktok'
                when regexp_like(trim(plataforma), '^(youtube|yt|you tube)$', 'i')
                then 'Youtube'
                else 'Desconocido'
            end as plataforma,
            fecha_creacion_perfil,
            activo,
            semana_snapshot,
            seguidores,
            alcance_semanal,
            impresiones_semanales,
            visitas_perfil,
            created_at,
            updated_at,
            _line,
            _fivetran_synced
        from source
        qualify
            row_number() over (
                partition by perfil_id, semana_snapshot order by created_at
            )
            = 1  -- Quito duplicados
    )

select *
from renamed