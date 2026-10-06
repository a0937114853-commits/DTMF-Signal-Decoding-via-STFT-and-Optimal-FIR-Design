# EE3660 Introduction to Digital Signal Processing - HW6: Computer-Based Exercises - README

本專案為國立清華大學電機系課程「數位訊號處理概論」（EE3660, Prof. Yi-Wen Liu）作業六（HW6）之電腦實作與模擬報告。本篇內容聚焦於**雙音多頻（DTMF）訊號之短時距傅立葉變換（STFT）與資訊檢索**，以及**基於 Parks-McClellan 演算法的最佳化 FIR 濾波器設計**。

---

## 1. 資訊檢索：雙音多頻 (DTMF) 訊號解碼與 STFT 分析
執行 `<DSP2025_HW5_DualTones.m>` 進行 3D 頻譜圖（Spectrogram）視覺化與互動分析。

* **(a) 視窗長度與類別之影響**
  * 變換視窗長度與視窗類型（Hann、Rectangular、Blackman），探討其對時頻解析度的影響。
  * 評估在維持可清楚辨識兩個分離峰值（Two Separated Peaks）的前提下，各視窗類型所能設定的最小視窗極限。
* **(b) 未知電話號碼解碼 (`unknown_phonenum.wav`)**
  * 載入檔案 `<unknown_phonenum.wav>`，利用 STFT 頻譜圖對應高頻與低頻群組頻率，解碼出對應的電話號碼序列。
  * 說明訊號段切割、峰值偵測與對應頻率對照之解碼流程。

> 🎵 **音檔播放與測試 (Audio Playback)**
> <audio controls>
>     <source src="unknown_phonenum.wav" type="audio/wav">
>     您的瀏覽器不支援音訊播放標籤。
> </audio>

> 📊 **DTMF 頻譜圖與 3D 檢視範例**
> ![DTMF Spectrogram](dtmf_spectrogram_3d.png)
> *圖 1：透過 3D 頻譜圖觀察 DTMF 雙音頻率在時頻域上的能量分佈與峰值分離狀況。*

---

## 2. Optimal FIR 最佳化濾波器設計
執行 `<myTestPM.m>`（內含 `<myChebyPol.m>`）以觀察 Parks-McClellan 演算法如何透過迭代逼近等漣波（Equal-Ripple）低通濾波器之最佳設計。

* **(a) 初始交替點對迭代次數之影響**
  * 修改程式碼第 10 行之初始交替點（Alternating Points）猜測值。
  * 討論不同的初始猜測如何影響演算法收斂所需的迭代次數（Iteration Steps）。
* **(b) 截止頻率 $\omega_c$ 對最大近似誤差的影響**
  * 變動截止頻率 $\omega_c$，探討其對最終設計之最大近似誤差（即漣波大小，Ripple Size）的影響。
* **(c) 迭代過程中 $\Delta$ 值增加之原理解析**
  * 探討並解釋為何在 Parks-McClellan 演算法的迭代過程中，$\Delta$ 值會隨著步驟逐次增加的數學與物理意義。

> 📈 **Parks-McClellan 迭代收斂與頻率響應圖**
> ![Parks-McClellan Convergence](pm_filter_response.png)
> *圖 2：Parks-McClellan 等漣波濾波器設計之頻率響應與最大近似誤差收斂情形。*