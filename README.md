# batchRename
Double click rename.bat to excute (*must to put in the same directory with target image folder)

type your folder name that files waiting for rename
```
Please Enter "Folder" name:
```
choose how to rename
```
(a)a,b,c,d in one folder (b)change title and volumn in one folder (c)a,b in every sub-folder
```
# if choose (a), then

type your filename extension `.jpg` 
```
Please Enter filename Extension(i.e.: .jpg or .tif):
```
type the starting part of files' names
```
Please key in 'Title':
```
type the volume number
```
Please key in 'Volume' name:
```
type the page number of first page
```
Please key in 'First' page number:
```
type the pages number that need to be named 'c' and 'd'
```
Please key in C,D pages here:
```
type the pages number that need to be skiped
```
Which pages do you want to skip(small to large page)
```

The result will become:

e.g. 

lj001-001a.jpg

lj001-001b.jpg
	 
lj001-002a.jpg

.

.

.


# if choose (b), then

only rename the part before '-' 

type the new starting part of files' names
```
Please key in new 'Title':
```
type the new Volumn number
```
Please key in new 'Volumn' name:
```

the file name will change from

oldTitleVolumn-001a.jpg to

newTitleVolumn-001a.jpg

# if choose (c), then 

type your filename extension `.jpg`
```
Please Enter filename Extension(i.e.: .jpg or .tif):
```

every image in the sub-folders of the main folder, which you just type in the command line in the beginning, will be renamed by the name of sub-folder

if there are two sub-folders in the main folder: folderA folderB

the images in folderA will be renamed as:

folderA-001a, folderA-001b, folderA-002a, folderA002b ......

the images in folderA will be renamed as:

folderB-001a, folderB-001b, folderB-002a, folderB002b ......
