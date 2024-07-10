# Analisis E-Commerce Menggunakan SQL

Dataset yang digunakan pada project ini adalah dataset yang diperoleh dari project akhir Bootchamp Data Analis oleh MySkill. Project ini menggunakan dataset Ecommerce Tokopaedi(data dummy) ini berisi transaksi dari bulan Januari 2021 sampai bulan Desember 2022. Dataset terdidri dari:
1.  order_detail, berisi detail data order yang terdiri dari:
      * id → angka unik dari order / id_order
      * customer_id → angka unik dari pelanggan
      * order_date → tanggal saat dilakukan transaksi
      * sku_id → angka unik dari produk (sku adalah stock keeping unit)
      * price → harga yang tertera pada tagging harga
      * qty_ordered → jumlah barang yang dibeli oleh pelanggan
      * before_discount → nilai harga total dari produk (price * qty_ordered)
      * discount_amount → nilai diskon product total
      * after_discount → nilai harga total produk ketika sudah dikurangi dengan diskon
      * is_gross → menunjukkan pelanggan belum membayar pesanan
      * is_valid → menunjukkan pelanggan sudah melakukan pembayaran
      * is_net → menunjukkan transaksi sudah selesai
      * payment_id → angka unik dari metode pembayaran
2.  sku_detail, berisi detail sku/produk yang terdiri dari:
      * id → angka unik dari produk (dapat digunakan untuk key saat join)
      * sku_name → nama dari produk
      * base_price → harga barang yang tertera pada tagging harga / price
      * cogs → cost of goods sold / total biaya untuk menjual 1 produk
      * category → kategori produk
3.  customer_detail, yang berisiskan detail dari customer yang terdiri dari:
      * id → angka unik dari pelanggan
      * registered_date → tanggal pelanggan mulai mendaftarkan diri sebagai anggota
4.  payment_detail, yang berisikan detail dari pembayaran yang terdiri dari:
      * id → angka unik dari metode pembayaran
      * payment_method → metode pembayaran yang digunakan

## Case Study
1. Selama transaksi yang terjadi selama 2021, pada bulan apa total nilai transaksi (after_discount) paling besar?
     <details>
     <summary>Query nomor 1 </summary>
     
     ``` sql
     select
         format_date("%B", date(order_date)) as bulan,
         sum(after_discount) as total_sales
     from `latihan-sql-1-399313.tokopaedi.order_detail`
     where
         is_valid=1 
         nd extract(year from order_date) = 2021
      group by 1
     order by 2 desc
     limit 5;
     ```
     
     </details>

Tabel Output: 
![](Images/no1_study_case.png)

Berdasarkan tabel yang telah didapat, pada tahun 2021 nilai transaksi paling besar berada pada bulan Agustus sebesar      227862744.0
     
2. Selama transaksi pada tahun 2022, kategori apa yang menghasilkan nilai transaksi paling besar?
     <details>
     <summary>Query nomor 2</summary>
     ''' sql
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
     '''
     </details>

Tabel Ouput: \
![](Images/no2_study_case.png)
     
kagetori yang menghasilkan nilai transaksi paling besar, yaitu kategori Mobiles & Tablets sebesar 918451576.0
     
 3. Bandingkan nilai transaksi dari masing-masing kategori pada tahun 2021 dengan 2022. Sebutkan kategori apa saja yang         mengalami peningkatan dan kategori apa yang mengalami penurunan nilai transaksi dari tahun 2021 ke 2022.
     <details>
     <summary>Query nomor 3</summary>
     ``` sql
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
     ````
     </details>

Tabel Output: \    
![](Images/no3_study_case.png)
     
Berdasarkan tabel yang diperoleh di atas terdapat 13 kategori yang mengalami peningkatan, tiga teratas yang menalami        peningkatan adalah kategori mobiles & Tablets, Entertainment dan Appliances. Sedangkan terdapat dua kategori yang           mengalami penurunan yaitu kategori Books dan kategori Others.

4. Tampilkan top 5 metode pembayaran yang paling populer digunakan selama 2022! (berdasarkan total unique order)
     <details>
     <summary>Query nomor 4</summary>
     ``` sql
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
     ```
     </details>

Tabel Output: \
![](Images/no4_study_case.png)
     
Top 5 metode pembayaran paling populer yang digunakan selama tahun 2022 secara berurutan dari yang terbesar jumlah          transaksinya, yaitu COD, Payaxis, Customercredit, Easypay dan Jazzwallet

5.  Urutan produk berdasarkan nilai transaksinya (Samsung, Apple, Sony, Huawei, Lenovo)
     <details>
     <summary>Query nomor 5</summary>
     ``` sql
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
                 order by 2 desc;
     ```
     </details>

Tabel Output: \
![](Images/no5_study_case.png)
     
produk Samsung berada diurutan pertama dengan nilai transaksi 588764148.0 diikuti oleh Apple sebesar 445282530.0, lalu      Sony sebesar 63960718.0, Huawei sebesar 63160260.0 dan Lenovo diperingkat ke-lima dengan nilai transaksi 62379800.4.
