README for HW4: 1) hg387.pdf file is attached as a report containing
answers to all the assignment questions.

2)  For your first programming task, you’ll implement, train and test a
    Naive Bayes Classifier. Download the dataset spambase.data from
    Blackboard. As mentioned in the Datasets area, this dataset contains
    4601 rows of data, each with 57 continuous valued features followed
    by a binary class label (0=not-spam, 1=spam). Since the features are
    continuous, we’ll use Gaussians to model P(xi|y). There is no header
    information in this file and the data is comma separated. As always,
    your code should work on any dataset that lacks header information
    and has several comma-separated continuous-valued features followed
    by a class id ∈ 0, 1.

NaiveBayes.m contains the implementation of the Naive Classifier. Also,
log is used to take care of the underflow.

3)  Finally, lets design, implement, train and test a Logistic
    Regression Classifier. For training and testing, we’ll use the same
    dataset as in the previous programming part, and as always, your
    code should work on any dataset that lacks header information and
    has several comma-separated continuousvalued features followed by a
    class id ∈ 0, 1.

LogisticClassifier contains the implementation of the Logistic
Classifier.

4)  All the produced results are congruent with the expected results.

