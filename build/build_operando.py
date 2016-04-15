#!/usr/bin/env python
# coding: utf-8

IGNORE_PATTERNS = ('.idea','.gitignore','.git')

import os, sys, subprocess,shutil
from shutil import copytree, ignore_patterns

def firstOperandoBuild():		
	os.chdir('adblockpluschrome')
	os.system("git reset --hard d2ba23e")
	os.system("build.py -t chrome devenv")
	os.chdir('..')
	return


def buildOperando():		
	os.chdir('adblockpluschrome')
	os.system("python build.py -t chrome devenv")
	os.chdir('..')
	return

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
BASE_DIR = os.path.join(BASE_DIR, "..","..");
os.chdir(BASE_DIR)
#print os.getcwd()
#sys.exit(0)

if not os.path.exists(os.path.join(BASE_DIR,"adblockpluschrome")):
    	os.system('git clone "https://github.com/adblockplus/adblockpluschrome"')
        firstOperandoBuild()
	    #TODO update

files = [
{
	"src":"op-chrome-ext",
	"dest":"adblockpluschrome/operando",
	"is_directory":1
},
{
  "src": "op-chrome-ext/build/override/metadata.common",
  "dest": "adblockpluschrome/metadata.common",
  "is_directory":0
}, {
  "src": "op-chrome-ext/build/override/metadata.chrome",
  "dest": "adblockpluschrome/metadata.chrome",
  "is_directory":0
}, {
  "src": "op-chrome-ext/build/override/packagerChrome.py",
  "dest": "adblockpluschrome/buildtools/packagerChrome.py",
  "is_directory":0
}, {
  "src": "op-chrome-ext/build/override/popup.html",
  "dest": "adblockpluschrome/popup.html",
  "is_directory":0
}, {
  "src": "op-chrome-ext/build/override/popup.css",
  "dest": "adblockpluschrome/skin/popup.css",
  "is_directory":0
},
 {
  "src": "op-chrome-ext/build/override/firstRun.html",
  "dest": "adblockpluschrome/adblockplusui/firstRun.html",
  "is_directory":0
},
{
  "src": "op-chrome-ext/build/override/adblockplus/chrome/locale/en-US/meta.properties",
  "dest": "adblockpluschrome/adblockplus/chrome/locale/en-US/meta.properties",
  "is_directory":0
}]


for file in files:
	if file['is_directory'] == 1:
	    if os.path.exists(os.path.join(BASE_DIR,file['dest'])):
                shutil.rmtree(os.path.join(BASE_DIR,file['dest']))
	    copytree(os.path.join(BASE_DIR,file['src']), os.path.join(BASE_DIR,file['dest']),ignore=ignore_patterns('.gitignore', '.git','.idea'))
	else:
		shutil.copy2(os.path.join(BASE_DIR,file['src']), os.path.join(BASE_DIR,file['dest']))

buildOperando()
if os.path.exists(os.path.join(BASE_DIR,"devenv.chrome.extension")):
    shutil.rmtree(os.path.join(BASE_DIR,"devenv.chrome.extension"))
copytree(os.path.join(BASE_DIR,"adblockpluschrome/devenv.chrome"), os.path.join(BASE_DIR,"devenv.chrome.extension"))


