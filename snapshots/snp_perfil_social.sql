{% snapshot snp_perfil_social %}

    {{
        config(
            target_schema="snapshots",
            unique_key="codigo_perfil_social",
            strategy="timestamp",
            updated_at="_fivetran_synced",
            invalidate_hard_deletes=True,
        )
    }}

    with
        perfil as (
            select
                id_perfil_social,
                codigo_perfil_social,
                id_empresa,
                id_red_social,
                nombre_usuario,
                fecha_creacion,
                activo,
                _fivetran_synced
            from {{ ref("int_perfil_social") }}
        ),

        modificaciones as (
            select
                id_perfil_social,
                codigo_perfil_social,
                id_empresa,
                id_red_social,
                nombre_usuario,
                fecha_creacion,
                activo,
                _fivetran_synced
            from
                {{
                    ref(
                        "stg_social_cloud_schema_modificar_perfil__raw_modificar_perfil"
                    )
                }}
        ),

        union_perfiles as (
            select *
            from perfil
            union all
            select *
            from modificaciones
        ),

        final as (
            select *
            from union_perfiles
            qualify
                row_number() over (
                    partition by codigo_perfil_social order by _fivetran_synced desc
                )
                = 1
        )

    select *
    from final

{% endsnapshot %}
