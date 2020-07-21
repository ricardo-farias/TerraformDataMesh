val data = spark.read.format("csv").option("header", "true").option("inferschema", "true").load("s3://data-mesh-covid-domain/TestData.csv")
val rdd = 1 to 100
rdd.map(x => if(x % 2 == 0) x*x else x*x*x)
val evens = rdd.filter(x => x % 2 == 0)
val odd = rdd.filter(x => x % 2 == 1)
data.show()