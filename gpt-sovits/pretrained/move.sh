unzip -o pretrained_models.zip -d GPT_SoVITS
unzip -o G2PWModel.zip -d GPT_SoVITS/text
unzip -o nltk_data.zip -d $(python -c "import sys; print(sys.prefix)")
tar -xzf open_jtalk_dic_utf_8-1.11.tar.gz -C $(python -c "import os, pyopenjtalk; print(os.path.dirname(pyopenjtalk.__file__))")
