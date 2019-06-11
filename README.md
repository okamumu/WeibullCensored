
## 打ち切りデータからの推定例

打ち切りデータを使った場合と使わない場合の推定値の違いを見てみる

### 真の分布の設定

本当はわからないけど，もし故障が以下のパラメータをもつワイブル分布だったらとして考える

``` r
shape <- 2 # 真の故障分布（ワイブル形状パラメータ）
scale <- 1000 # 真の故障分布（ワイブル尺度パラメータ（スケール））
```

### 環境の設定

信頼性試験をする環境の設定．この場合は 100 製品を試験して，それぞれ 1000 時間たっても故障しなかったら試験をやめる．

``` r
t <- 500 # 打ち切り時間
n <- 100 # 試験する製品数
```

### シミュレーション

関数を定義した R ファイルを読み込み

``` r
source("weibull_censored.R")
```

自分で決めた真の故障分布からデータの生成．第１列目は故障あるいは打ち切り時間，第２列目は第１列目が故障か打ち切りかを示すブール型の値．TRUE
なら第１列は打ち切り時間．

``` r
data <- gen.sample(n, t, shape, scale) # 擬似的な実験データを生成
data
```

    ##         time censored
    ## 1   373.4927    FALSE
    ## 2   109.2164    FALSE
    ## 3   500.0000     TRUE
    ## 4   500.0000     TRUE
    ## 5   500.0000     TRUE
    ## 6   500.0000     TRUE
    ## 7   311.5060    FALSE
    ## 8   153.4010    FALSE
    ## 9   500.0000     TRUE
    ## 10  500.0000     TRUE
    ## 11  500.0000     TRUE
    ## 12  500.0000     TRUE
    ## 13  500.0000     TRUE
    ## 14  500.0000     TRUE
    ## 15  500.0000     TRUE
    ## 16  500.0000     TRUE
    ## 17  500.0000     TRUE
    ## 18  454.6036    FALSE
    ## 19  217.1894    FALSE
    ## 20  500.0000     TRUE
    ## 21  500.0000     TRUE
    ## 22  369.4209    FALSE
    ## 23  500.0000     TRUE
    ## 24  500.0000     TRUE
    ## 25  500.0000     TRUE
    ## 26  500.0000     TRUE
    ## 27  500.0000     TRUE
    ## 28  500.0000     TRUE
    ## 29  500.0000     TRUE
    ## 30  500.0000     TRUE
    ## 31  500.0000     TRUE
    ## 32  500.0000     TRUE
    ## 33  500.0000     TRUE
    ## 34  500.0000     TRUE
    ## 35  500.0000     TRUE
    ## 36  472.7647    FALSE
    ## 37  223.6279    FALSE
    ## 38  500.0000     TRUE
    ## 39  500.0000     TRUE
    ## 40  500.0000     TRUE
    ## 41  500.0000     TRUE
    ## 42  500.0000     TRUE
    ## 43  432.5462    FALSE
    ## 44  413.6206    FALSE
    ## 45  500.0000     TRUE
    ## 46  500.0000     TRUE
    ## 47  500.0000     TRUE
    ## 48  500.0000     TRUE
    ## 49  500.0000     TRUE
    ## 50  500.0000     TRUE
    ## 51  500.0000     TRUE
    ## 52  500.0000     TRUE
    ## 53  500.0000     TRUE
    ## 54  500.0000     TRUE
    ## 55  500.0000     TRUE
    ## 56  179.4261    FALSE
    ## 57  500.0000     TRUE
    ## 58  500.0000     TRUE
    ## 59  500.0000     TRUE
    ## 60  500.0000     TRUE
    ## 61  500.0000     TRUE
    ## 62  500.0000     TRUE
    ## 63  500.0000     TRUE
    ## 64  465.1218    FALSE
    ## 65  500.0000     TRUE
    ## 66  500.0000     TRUE
    ## 67  500.0000     TRUE
    ## 68  500.0000     TRUE
    ## 69  500.0000     TRUE
    ## 70  500.0000     TRUE
    ## 71  500.0000     TRUE
    ## 72  500.0000     TRUE
    ## 73  500.0000     TRUE
    ## 74  377.6446    FALSE
    ## 75  500.0000     TRUE
    ## 76  500.0000     TRUE
    ## 77  500.0000     TRUE
    ## 78  329.1998    FALSE
    ## 79  500.0000     TRUE
    ## 80  500.0000     TRUE
    ## 81  500.0000     TRUE
    ## 82  500.0000     TRUE
    ## 83  500.0000     TRUE
    ## 84  500.0000     TRUE
    ## 85  222.4571    FALSE
    ## 86  376.9754    FALSE
    ## 87  500.0000     TRUE
    ## 88  500.0000     TRUE
    ## 89  500.0000     TRUE
    ## 90  226.2202    FALSE
    ## 91  280.7876    FALSE
    ## 92  500.0000     TRUE
    ## 93  500.0000     TRUE
    ## 94  161.5651    FALSE
    ## 95  500.0000     TRUE
    ## 96  462.3304    FALSE
    ## 97  315.0199    FALSE
    ## 98  500.0000     TRUE
    ## 99  500.0000     TRUE
    ## 100 500.0000     TRUE

打ち切りされた製品個数と故障まで試験した製品の個数

``` r
print(paste("# of failedd items", sum(data$censored == FALSE))) # 故障した製品数
```

    ## [1] "# of failedd items 22"

``` r
print(paste("# of censored items", sum(data$censored))) # 打ち切りをした製品数
```

    ## [1] "# of censored items 78"

打ち切った時間の情報を使わない推定

``` r
result <- mle.withoutcensored(data)
cat("Estimated parameters (shape, scale): ", result$par)
```

    ## Estimated parameters (shape, scale):  3.239268 352.8362

打ち切った時間の情報を使った推定

``` r
result <- mle.withcensored(data)
cat("Estimated parameters (shape, scale): ", result$par)
```

    ## Estimated parameters (shape, scale):  1.983361 1005.7
