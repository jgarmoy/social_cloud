with source as (
    select * from {{ source('social_cloud_schema', 'raw_perfiles_empresas') }}
),
limpiar_plataformas as (
    select
        * exclude plataforma,
        case
            when regexp_like(trim(plataforma), '^(instagram|ig|insta)$', 'i') then 'instagram'
            when regexp_like(trim(plataforma), '^(tiktok|tk|tik tok)$', 'i') then 'tiktok'
            when regexp_like(trim(plataforma), '^(youtube|yt|you tube)$', 'i') then 'youtube'
            else lower(plataforma)
        end as plataforma
    from source
),
renamed as (
    select 
        {{ dbt_utils.generate_surrogate_key(["substr(username, 2)"]) }} as id_perfil_empresa, -- Todos tienen @, select * from source where username not ilike '@%'
        perfil_id as codigo_perfil_social,
        {{ dbt_utils.generate_surrogate_key(["empresa_nombre"]) }} as id_empresa,
        {{ dbt_utils.generate_surrogate_key(['plataforma']) }} as id_red_social,
        
    from limpiar_plataformas
)

select * from source where empresa_nombre is null