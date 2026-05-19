with
    source as (
        select * from {{ ref("stg_social_cloud_schema__raw_perfiles_empresas") }}
    ),

    renombrar_quitar_duplicados as (
        select
            {{ dbt_utils.generate_surrogate_key(["empresa_id"]) }} as id_empresa,
            empresa_id as codigo_empresa,
            empresa_nombre as nombre,
            {{ dbt_utils.generate_surrogate_key(["empresa_pais"]) }} as id_pais,
            {{ dbt_utils.generate_surrogate_key(["empresa_categoria"]) }}
            as id_categoria_empresa,
            empresa_web as web,
            empresa_email as email
        from source
        qualify
            row_number() over (
                partition by empresa_id
                -- Priorizo registros con web y email no nulos, sino los que tenga el
                -- email, luego la web y después los que son ambos
                order by
                    (empresa_email is not null)::int desc,
                    (empresa_web is not null)::int desc,
                    created_at asc
            )
            = 1
    )

select *
from renombrar_quitar_duplicados
