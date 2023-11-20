# E-Commerce-SQL-Analysis

Dataset yang digunakan pada project ini adalah dataset yang diperoleh dari project akhir Bootchamp Data Analis oleh MySkill. Project ini menggunakan dataset Ecommerce Tokopaedi(dummy) ini berisi transaksi dari bulan Januari 2021 sampai bulan Desember 2022. Dataset terdidri dari:
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

  
