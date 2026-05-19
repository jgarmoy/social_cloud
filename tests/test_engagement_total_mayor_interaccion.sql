with
    interacciones_por_post as (
        select
            id_post,
            id_tipo_interaccion,
            total_interaccion,
            engagement_total
        from {{ ref("fct_rendimiento_contenido") }}
    ),
    fallos as (
        select * from interacciones_por_post where total_interaccion > engagement_total
    )

select *
from fallos
