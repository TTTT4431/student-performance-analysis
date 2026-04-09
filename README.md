# student-performance-analysis

## 📊 プロジェクト概要
学生の試験成績データをもとに、成績上位者の特徴を分析した。
SQLによるデータ抽出と、Pythonによる可視化を組み合わせて、成績に影響する要因を特定している。

---

## 🛠 使用技術
- MySQL
- SQL（PERCENT_RANK / 集計 / CASE文）
- Python（pandas / matplotlib / seaborn）
- Jupyter Notebook

---

## 🧱 データ構成
以下の項目を使用：

- Hours_Studied（勉強時間）
- Attendance（出席率）
- Sleep_Hours（睡眠時間）
- Previous_Scores（過去成績）
- Tutoring_Sessions（塾利用回数）
- Physical_Activity（運動量）
- Exam_Score（試験スコア）
- Motivation_Level（学習意欲）

---

## 📈 分析内容

### ① 上位者の定義
- PERCENT_RANK関数を用いて、試験スコア上位30%を「Top」と定義

### ② グループ比較
- TopとOtherで平均値を比較
- 差分分析（平均との差）を算出

### ③ 相関分析
- Exam_Scoreとの相関係数を算出

### ④ 可視化
- 箱ひげ図（Top vs Other）
- 棒グラフ（平均比較）
- ヒートマップ（相関）

---

## 💡 分析結果

- 成績上位者は、**勉強時間と出席率が明確に高い**
- 特に出席率は最も強い影響要因
- 過去成績も一定の影響あり
- 睡眠時間・運動量は大きな差が見られず、影響は小さい
- 塾利用は補助的な要因にとどまる

---

## ⚠️ データ前処理での学び

CSV取り込み時に列順の不一致が発生し、  
Sleep_Hours・Previous_Scoresなどがすべて0になる問題が発生。

→ テーブル定義とCSVの列順を一致させて再取り込み  
→ データの整合性を回復

👉 データ分析において「前処理の重要性」を学んだ

---

## 📁 フォルダ構成

├── sql/
│   ├── create_table.sql
│   ├── analysis_query.sql
│
├── python/
│   ├── analysis.ipynb
│
├── data/
│   ├── StudentPerformanceFactors.csv
│
├── output/
│   ├── graphs/
│
└── README.md


## 🎯 工夫した点

- SQLとPythonを組み合わせた分析フローを構築　
- 上位30%という明確な基準で比較分析　　　　　　→ データが多いため、上位30％でも十分、分析できると考えた
- 可視化により直感的に理解できる形に整理　　　　→　「seaborn」を使って綺麗な図を作成できたと思う

  
## 🚀 今後の改善

- 回帰分析による影響度の定量評価　　　　　→ 今後の目標としては「回帰分析」実行し、データ分析の勉強を深めていきたい
- 特徴量重要度の算出　　　　　　　　　　　→　「Kaggle」で高スコアを狙うには、この特徴量を出す工程も必要になってくる。
- 　　　　　　　　　　　　　　　　　　　　　　したがって、今後はここにも注力していきたい
