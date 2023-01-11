#  NSFW Model

The NSFWDetector uses the NSFW ML Model. The class and current model was trained and available from here:

[lovoo/NSFWDetector](https://github.com/lovoo/NSFWDetector)

However, for better classification (and that the MLModel seemed to be corrupt), we are using the larger model from here:

[yahoo/open_nsfw](https://github.com/yahoo/open_nsfw)

To convert a Caffe model to a Core ML model, you can use `convert.py` as follows:

Install Python v2.7

```
.\Python27\Scripts\pip.exe install virtualenv
.\Python27\Scripts\virtualenv.exe --version
virtualenv 20.15.1 from c:\python27\lib\site-packages\virtualenv\__init__.pyc
.\Python27\Scripts\virtualenv.exe py2env
created virtual environment CPython2.7.17.final.0-64 in 3373ms
python --version
Python 2.7.17
pip install -U CoreMLTools
pip install --upgrade pip enum34

```


Useful links:

[iOS CoreML project with NSFW model [Swift]](https://medium.com/@yiweini/ios-coreml-project-with-open-nsfw-model-516bcedd8381)
[2 Installing CoremlTools using Python PIP](https://www.youtube.com/watch?v=MR_fbL57C5A)
[3 Converting a Caffe Model into MLModel](https://www.youtube.com/watch?v=s44AEbM0jsI)
