## Persyaratan (Requirements)

Proyek ini dibuat menggunakan environment berikut:

* **Python**: >= 3.11
    * `pandas`
    * `scikit-learn`
    * `imblearn`
    * `shap`
    * `matplotlib`
    * `seaborn`
* **R**: >= 4.3
    * `readr`
    * `dplyr`
    * `ggplot2`
    * `glmtoolbox` (sesuai instruksi)
    * `ResourceSelection` (digunakan sebagai alternatif karena isu kompatibilitas dengan `glmtoolbox`)

## Cara Menjalankan Proyek

Proyek ini terdiri dari tiga bagian independen.

### Bagian A: SQL Analytics

1.  **Query SQL**: Semua query untuk analisis RFM, deteksi anomali, dan repeat-purchase terdapat di dalam file `analysis.sql`.
2.  **Temuan Anomali**: Ringkasan temuan anomali dapat dibaca di `A_findings.md`.

### Bagian B: Python Modeling

1.  **Proses Pemodelan**: Buka dan jalankan semua sel di dalam notebook `notebooks/B_modeling.ipynb`. Notebook ini berisi semua langkah mulai dari EDA, perbandingan model, hingga pembuatan scorecard.
2.  **Hasil Analisis Fitur**: Plot SHAP yang menunjukkan fitur teratas disimpan dalam file `shap_summary.png`.
3.  **Rekomendasi Keputusan**: Slide presentasi untuk studi kasus pinjaman Rp 5 juta terdapat di `decision_slide.pdf`.

### Bagian C: R Statistical Check

1.  **Jalankan Script R**: Buka lingkungan R (seperti RStudio), set direktori kerja ke folder proyek ini, lalu jalankan script `validation.R`.
    ```R
    source("validation.R")
    ```
2.  **Hasil Validasi**:
    * Hasil uji Hosmer-Lemeshow akan ditampilkan di konsol dan disimpan di `hosmer_lemeshow_output.txt`.
    * Plot kurva kalibrasi disimpan dalam file `calibration_curve.png`.
    * Ringkasan penentuan *cut-off score* dapat dibaca di `C_summary.md`.
