with
    source as (
        select * from {{ source("social_cloud_schema", "raw_audiencia_demografica") }}
    ),
    renombrar as (
        select
            trim(empresa_id) as empresa_id,
            trim(perfil_id) as perfil_id,
            case
                when tk_handle ilike '@%' then substr(trim(tk_handle), 2) else tk_handle
            end as tk_handle,
            case
                when tk_platform is not null then 'Tiktok' else tk_platform
            end as tk_platform,
            snapshot_date,
            initcap(trim(gender_segment)) as gender_segment,
            initcap(trim(age_segment)) as age_segment,
            initcap(trim(country)) as country,
            audience_share_pct,
            seg_followers,
            case
                when ig_username ilike '@%'
                then substr(trim(ig_username), 2)
                else ig_username
            end as ig_username,
            case
                when ig_platform is not null then 'Instagram' else ig_platform
            end as ig_platform,
            report_date,
            initcap(trim(audience_gender)) as audience_gender,
            initcap(trim(audience_age)) as audience_age,
            initcap(trim(audience_country)) as audience_country,
            pct_audience,
            follower_count_seg,
            case
                when yt_handle ilike '@%' then substr(trim(yt_handle), 2) else yt_handle
            end as yt_handle,
            case when network is not null then 'Youtube' else network end as network,
            period,
            initcap(trim(sexo)) as genero,
            initcap(trim(edad)) as edad,
            initcap(trim(pais_audiencia)) as pais_audiencia,
            porcentaje,
            n_seguidores_seg,
            created_at,
            updated_at,
            _line,
            _fivetran_synced
        from source
    )
    
select *
from renombrar
