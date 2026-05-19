with
    perfil as (select * from {{ ref("snp_perfil_social") }}),

    red_social as (select * from {{ ref("int_red_social") }}),

    final as (
        select
            p.id_perfil_social,
            p.codigo_perfil_social,
            r.nombre as red_social,
            p.nombre_usuario,
            p.activo

        from perfil p
        left join red_social r on p.id_red_social = r.id_red_social
        where p.dbt_valid_to is null
    )

select *
from final
