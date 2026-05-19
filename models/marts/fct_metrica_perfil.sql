with
    source as (select * from {{ ref("int_metrica_perfil") }}),

    renombrar as (
        select
            id_metrica_perfil,
            id_perfil_social,
            year(semana_snapshot) * 10000
            + month(semana_snapshot) * 100
            + day(semana_snapshot) as id_fecha,
            seguidores,
            alcance_semanal,
            impresiones_semanales,
            visitas_perfil,
            case
                when seguidores > 0 then round(alcance_semanal / seguidores * 100, 4)::float
            end as tasa_alcance_pct,
            case
                when impresiones_semanales > 0
                then round(alcance_semanal / impresiones_semanales * 100, 4)::float
            end as tasa_cobertura_pct
        from source
    )

select *
from renombrar
