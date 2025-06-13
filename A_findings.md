
1. Analisis rasio decoy_noise terhadap payment_value mengidentifikasi beberapa pelanggan sebagai outlier. Entri untuk customer_id 833 dan 298, yang menunjukkan rasio outlier yang sangat tinggi (33.25 dan 26.49). Begitu pula entri customer_id 974 dan 851 menunjukkan rasio outlier yang sangat rendah (-15.79 dan -16.49).

2. Ditemukan anomali pada logika penetapan decoy_flag. Empat pelanggan konsisten hanya menerima satu jenis flag di semua transaksi mereka, contohnya customer_id 871 memiliki 8 transaksi dengan flag yang sama, sementara pelanggan lain dapat menerima flag yang berbeda-beda.