{% snapshot snp_perfil_social %}

    {{
        config(
            target_schema="snapshots",
            unique_key="codigo_perfil_social",
            strategy="check",
            check_cols=["activo", "nombre_usuario", "id_empresa", "id_red_social"],
            invalidate_hard_deletes=True,
        )
    }}

    select *
    from {{ ref("int_perfil_social") }}

{% endsnapshot %}
