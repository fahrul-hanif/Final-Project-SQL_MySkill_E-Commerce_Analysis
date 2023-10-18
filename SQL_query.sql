
/* Soal 1
Q: Selama transaksi yang terjadi selama 2021, pada bulan apa total nilai transaksi
(after_discount) paling besar? Gunakan is_valid = 1 untuk memfilter data transaksi.
Source table: order_detail */

select 
  format_date("%B", date(order_date)) as bulan,
  sum(after_discount) as total_sales
from `latihan-sql-1-399313.tokopaedi.order_detail`
where
  is_valid=1 
  and extract(year from order_date) = 2021
group by 1
order by 2 desc
limit 5;


/* soal 2
Q: Selama transaksi pada tahun 2022, kategori apa yang menghasilkan nilai transaksi paling
besar? Gunakan is_valid = 1 untuk memfilter data transaksi.
Source table: order_detail, sku_detail 
join sku_detail.id dan order_detail.sku_id*/


select 
  sd.category,
  round(sum(od.after_discount),2) total
from `latihan-sql-1-399313.tokopaedi.order_detail` as od
left join `latihan-sql-1-399313.tokopaedi.sku_detail` as sd
on od.sku_id=sd.id
where
  is_valid=1
  and extract(year from order_date)= 2022
group by 1
order by 2 desc
limit 5;


--- Soal 3
/* Bandingkan nilai transaksi dari masing-masing kategori pada tahun 2021 dengan 2022.
Sebutkan kategori apa saja yang mengalami peningkatan dan kategori apa yang mengalami
penurunan nilai transaksi dari tahun 2021 ke 2022. Gunakan is_valid = 1 untuk memfilter data
transaksi.
Source table: order_detail, sku_detai */

with data_transaksi as
  (select
    od.id as order_id,
    od.sku_id as sku_id,
    od.after_discount as after_discount,
    sd.category as category,
    extract(year from od.order_date) as tahun
  from `latihan-sql-1-399313.tokopaedi.order_detail` as od
  left join `latihan-sql-1-399313.tokopaedi.sku_detail` as sd
  on od.sku_id = sd.id
  where
    is_valid=1
    and extract(year from order_date) in (2021,2022)
  )
 select
  data_transaksi.category,
  round(sum(case when tahun = 2021 then data_transaksi.after_discount else 0 end), 2) as transaksi_2021,
  round(sum(case when tahun = 2022 then data_transaksi.after_discount else 0 end), 2) as transaksi_2022,
  cast((round(sum(case when tahun = 2022 then data_transaksi.after_discount else 0 end), 2)) - (round(sum(case when tahun = 2021 then data_transaksi.after_discount else 0 end), 2)) as int) as selisih
 from data_transaksi
 group by data_transaksi.category
 order by 4 desc;

--- Cara 2
with data as(
  select
    sd.category as category,
    sum(case when extract(year from order_date)=2022 then od.after_discount else 0 end) as sales_2022,
    sum(case when extract(year from order_date) =2021 then od.after_discount else 0 end) as sales_2021
  from `latihan-sql-1-399313.tokopaedi.order_detail` as od
  left join `latihan-sql-1-399313.tokopaedi.sku_detail` as sd
  on od.sku_id = sd.id
  where
    is_valid=1
  group by 1
)
select 
  category,
  round(sales_2021, 1) sales2021,
  round(sales_2022, 1) sales2022,
  round(sales_2022-sales_2021,1) as growth
from data
order by 4 desc;


--- Soal 4
/* Q: Tampilkan top 5 metode pembayaran yang paling populer digunakan selama 2022
(berdasarkan total unique order). Gunakan is_valid = 1 untuk memfilter data transaksi.
Source table: order_detail, payment_method */

select 
  pd.payment_method as metode_pembayaran,
  count(distinct od.id) as jumlah_transaksi
from `latihan-sql-1-399313.tokopaedi.order_detail` as od
left join `latihan-sql-1-399313.tokopaedi.payment_detail` as pd
on (od.payment_id = pd.id)
where
  is_valid=1
  and extract(year from order_date)=2022
group by 1
order by 2 desc
limit 5;

--- Soal 5
/* Q: Urutkan dari ke-5 produk ini berdasarkan nilai transaksinya.
1. Samsung
2. Apple
3. Sony
4. Huawei
5. Lenovo
Gunakan is_valid = 1 untuk memfilter data transaksi.
Source table: order_detail, sku_detai */

with a as
  (select
  case
    when lower(sd.sku_name) like '%samsung%' then 'Samsung'
    when lower(sd.sku_name) like '%iphone%' or lower(sd.sku_name) like '%ipad%' 
    or lower(sd.sku_name) like '%macbook%' or lower(sd.sku_name) like '%apple%' then 'Apple'
    when lower(sd.sku_name) like '%sony%' then 'Sony'
    when lower(sd.sku_name) like '%huawei%'then 'Huawei'
    when lower(sd.sku_name) like '%lenovo%' then 'Lenovo'
    else 'lainnya'
    end as nama_produk,
  sum(od.after_discount) as nilai_transaksi
  from `latihan-sql-1-399313.tokopaedi.order_detail` as od
  join `latihan-sql-1-399313.tokopaedi.sku_detail` as sd
  on od.sku_id = sd.id
  where
    is_valid=1
  group by 1
  )
  select nama_produk, nilai_transaksi
  from a
  where nama_produk != 'lainnya'
  order by 2 desc





