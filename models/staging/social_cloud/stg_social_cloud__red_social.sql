with source as (
    select * from {{ source('social_cloud_schema', 'raw_perfiles_empresas') }}
),
limpiar_plataformas as (
    select distinct
        case
            when regexp_like(trim(plataforma), '^(instagram|ig|insta)$', 'i') then 'instagram'
            when regexp_like(trim(plataforma), '^(tiktok|tk|tik tok)$', 'i') then 'tiktok'
            when regexp_like(trim(plataforma), '^(youtube|yt|you tube)$', 'i') then 'youtube'
            else lower(plataforma)
        end as plataforma
    from source
),
generar_surrogate_key as (
    select 
    {{ dbt_utils.generate_surrogate_key(['plataforma']) }} as id_red_social,
    plataforma as nombre
from limpiar_plataformas
)
select 
    *
from generar_surrogate_key