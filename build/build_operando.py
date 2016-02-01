#!/usr/bin/env python
# coding: utf-8

import os, sys, subprocess, shutil
from distutils.dir_util import copy_tree


def buildOperando():		
	os.chdir('adblockpluschrome')
	os.system("build.py -t chrome devenv")
	os.chdir('..')
	return

os.chdir('..')
os.chdir('..')
BASE_DIR = os.getcwd()

if not os.path.exists(os.path.join(BASE_DIR,"adblockpluschrome")):
	os.system('git clone "https://github.com/adblockplus/adblockpluschrome"')	
	buildOperando()
	#TODO update

files = [
{
	"src":"browser-extension",
	"dest":"adblockpluschrome/operando",
	"is_directory":1
},
{
  "src": "browser-extension/build/override/metadata.common",
  "dest": "adblockpluschrome/metadata.common",
  "is_directory":0
}, {
  "src": "browser-extension/build/override/metadata.chrome",
  "dest": "adblockpluschrome/metadata.chrome",
  "is_directory":0
}, {
  "src": "browser-extension/build/override/packagerChrome.py",
  "dest": "adblockpluschrome/buildtools/packagerChrome.py",
  "is_directory":0
}, {
  "src": "browser-extension/build/override/popup.html",
  "dest": "adblockpluschrome/popup.html",
  "is_directory":0
}, {
  "src": "browser-extension/build/override/popup.css",
  "dest": "adblockpluschrome/skin/popup.css",
  "is_directory":0
},
{
  "src": "browser-extension/build/override/adblockplus/chrome/locale/en-US/meta.properties",
  "dest": "adblockpluschrome/adblockplus/chrome/locale/en-US/meta.properties",
  "is_directory":0
}]

#BASE_DIR = os.path.dirname(os.path.abspath(__file__))
#os.chdir('..')
#os.chdir('..')


#DEPENDENCY_SCRIPT = os.path.join(BASE_DIR, "ensure_dependencies.py")


#try:
#  subprocess.check_call([sys.executable, DEPENDENCY_SCRIPT, BASE_DIR])
#except subprocess.CalledProcessError as e:
#  print >>sys.stderr, e
#  print >>sys.stderr, "Failed to ensure dependencies being up-to-date!"



for file in files:
	if file['is_directory'] == 1:
		#print >>sys.stderr, os.path.join(BASE_DIR,file['src'])
		#print >>sys.stderr, os.path.join(BASE_DIR,file['dest'])
		copy_tree(os.path.join(BASE_DIR,file['src']), os.path.join(BASE_DIR,file['dest']))
	else:
		shutil.copy2(os.path.join(BASE_DIR,file['src']), os.path.join(BASE_DIR,file['dest']))

		

buildOperando()		

copy_tree(os.path.join(BASE_DIR,"adblockpluschrome/devenv.chrome"), os.path.join(BASE_DIR,"devenv.chrome.extension"))
		




#import buildtools.build
#buildtools.build.processArgs(BASE_DIR, sys.argv)


