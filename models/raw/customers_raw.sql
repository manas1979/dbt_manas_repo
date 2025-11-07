with base as
(
SELECT
    row_number()
        over(
            partition by
            customerid
            order by 
            updated_at desc
    ) as rnk,
    customerid,
    firstname,
    lastname,
    email,
    phone,
    address,
    city,
    state,
    zipcode,
    updated_at
FROM
    {{ source('raw', 'customers') }}
)    

select * from base where rnk = 1