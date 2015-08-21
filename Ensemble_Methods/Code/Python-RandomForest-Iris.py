from sklearn.datasets import load_iris
from sklearn.ensemble import RandomForestClassifier
import pandas
import numpy

# Load iris class into memory
iris = load_iris() 

# gaining information about the dataset
#print iris['DESCR']

# loads the iris dataset into a data frame (pandas)
# inserts column names into the data frame
irisDF = pandas.DataFrame(iris.data, columns=iris.feature_names)
irisDF['is_train'] = numpy.random.uniform(0, 1, len(irisDF)) <= .75
irisDF['species'] = pandas.Categorical.from_codes(iris.target, iris.target_names)
irisDF.head()

irisDF_train = irisDF[irisDF['is_train']==True]
irisDF_test = irisDF[irisDF['is_train']==False]

features = irisDF.columns[:4]
clf = RandomForestClassifier(n_jobs=2)
y, _ = pandas.factorize(irisDF_train['species'])
clf.fit(irisDF_train[features], y)

preds = iris.target_names[clf.predict(irisDF_test[features])]
pandas.crosstab(irisDF_test['species'], preds, rownames=['actual'], colnames=['preds'])