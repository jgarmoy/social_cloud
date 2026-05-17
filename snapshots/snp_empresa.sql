{% snapshot snp_empresa %}

    {{
        config(
            target_schema="snapshots",
            unique_key="codigo_empresa",
            strategy="check",
            check_cols=["nombre", "id_pais", "id_categoria_empresa", "web", "email"],
            invalidate_hard_deletes=True,
        )
    }}

    select *
    from {{ ref("int_empresa") }}

{% endsnapshot %}
