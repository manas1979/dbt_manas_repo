{%- set yaml_metadata -%}
source_model: 'customers_raw'
derived_columns:
  record_source: '!RAW_EY'
  load_date: 'current_timestamp'
  effective_from: 'updated_at'
hashed_columns:
  hk_customer: customerid
  hd_customer:
    is_hashdiff: true
    columns:
      - customerid
      - firstname
      - lastname
      - email
      - phone
      - address
      - city
      - state
      - zipcode
      - updated_at
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{% set source_model = metadata_dict['source_model'] %}

{% set derived_columns = metadata_dict['derived_columns'] %}

{% set hashed_columns = metadata_dict['hashed_columns'] %}

{{ automate_dv.stage(include_source_columns=true,
                     source_model=source_model,
                     derived_columns=derived_columns,
                     hashed_columns=hashed_columns,
                     ranked_columns=none) }}

{% if is_incremental() %}
where  Updated_at > (select max(updated_at) from {{ this }})
{% endif %}                     