# SelfManagementApp

## アプリ概要
### アプリテーマ
SelgManagementAppは、個人の目標管理を一箇所にまとめる記録アプリです。<br>
プロジェクト管理機能、プロジェクトアサイン機能、タスク管理機能、ガントチャート機能など、個人が目標を達成するために必要な機能を利用することができます。

### テーマを選んだ理由
BacklogやRedmine、Wrikeなど組織でタスク管理やプロジェクト管理をするツールはたくさんあります。<br>
しかし、個人で利用するにはコストも高くオーバースペックなことが多いです。<br>
<br>
近年では個人で仕事をする人が増加している背景もあるため、<br>
個人向けの目標管理ツールにより、プロジェクト達成をサポートできるサービスがあれば便利だと考え、こちらのテーマにしました。<br>

### ターゲットユーザ
- 個人で仕事をしている個人ユーザー

### 主な利用シーン
- プロジェクト達成に必要なタスク管理や進捗管理
- 複数人が関わるプロジェクトの共有

## 設計書
### ER図
![SelfManagementApp](https://user-images.githubusercontent.com/108569722/197373138-c833b0c0-7ed8-414d-bb92-fcc41f39508b.jpg)

### テーブル設計書
https://docs.google.com/spreadsheets/d/1pgQAVF10C0rT_JnunxAq1LUdnzEhIPUocxz52LdrHoE/edit?usp=sharing

### アプリケーション詳細設計書
https://docs.google.com/spreadsheets/d/1uBKobr93xndEKkWIYH4M1-Fedm8-2MRrhtN4Eu9t7WY/edit?usp=sharing

## 開発環境
- OS
  - Linux(CentOS)
- 言語・フレームワーク・ライブラリ・データベース
  - HTML / SCSS / JavaScript / JQuery / Ruby / Ruby on Rails / MySQLなど
- インフラ
  - AWS(Cloud9 / EC2 / EBS / RDS / VPC　/ EIP / ALB /　Route 53 / CloudWatch / S3) 
  - Nginx など
- その他ツール
  - Slack / GitHub / GitHub Actions / cron(バッチ処理)

## 使用素材
- FontAwesome(https://fontawesome.com/)
