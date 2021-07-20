CS 383 Machine Learning
Himanshu Gupta 
Assignment 1
README:

1) CS383HimanshuGupta.pdf contains the answers of question 1 and visualization of question 2.

2) Task: 

-> Standardizes the data
-> Reduces the data to 2D using PCA
-> Plot the data as points in 2D space for visualization

AssgnPart2.m contains the source code for question 2 where:
	default directory for getting images is "./yalefaces/"
	if anyone wants to changes it, portion of the code commented to replace the default directory name
	Also, for increasing performance, I am attaching database.mat file which contains generated 40 X 40 data
	matrix without standardisation so first program looks for this file, if not exists then creates its own
	40 X 40 matrix by reading images from the directory.
	On top of these, plotted graph would be saved in "plot.png" file. Sample is attached with the zip file.
	For running in tux, just do: matlab AssgnPart2.matlab
	This will generate required figure in "plot.png."

3) Task: 

One (cool?) application of PCA is be lossy-compression. We can project our data down to k dimenions (where k < D), then when we need to reconstruct our data, we can just multiply the k
dimensional data by (the transpose of) its k associated principle components in order to return to
our original feature space!
	
In this part of the assignment you’ll be making a video showing how the reconstruction looks as you
varying k, from k = 1 to k = D. affects the reconstruction, visualizing this as a video. If you’re
working in Matlab I’d suggest using the VideoWriter class

AssgnPart3.m contains the source code for question 3 where:
	Program tries to read "subject02.centerlight" which is placed inside "./yalefaces" directory.
	So, you need to have this image inside of mentioned directory. // PROGRAM REQUIREMENT
	Also, section of code is commented to location of this image easily.
	
	default directory for getting images is "./yalefaces/"
	if anyone wants to changes it, portion of the code commented to replace the default directory name
	Also, for increasing performance, I am attaching database.mat file which contains generated 40 X 40 data
	matrix without standardisation so first program looks for this file, if not exists then creates its own
	40 X 40 matrix by reading images from the directory.
	
	On top of these, I have also included sample video file (eigenfaces.avi) generated from my program with 
	value of K superimposed over images.
	For running in tux, after matlab is opened, just do: run AssgnPart3.m
	This will generate required video file as "eigenfaces.avi."
4) The programs are throughly tested on tux and performed well in various cases. 