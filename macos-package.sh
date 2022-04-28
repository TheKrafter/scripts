#!/bin/bash
##########
# macos-package.sh by Krafter, published under the MIT License
# available in my scripts repo at github.com/TheKrafter/scripts
# feel free to use, but bear in mind the license's terms. 
# you should have recieved a copy of the license with this software;
# if not, it's available online at https://mit-license.org/ 
##########
### help
if [ -z $1 ] # if no exec is set, show help
then
    echo "'macos-package.sh' by Krafter, under the MIT License"
    echo "Usage: ./macos-package.sh <executable> <verbose>"
    echo "<executable> - path of executable to package"
fi
### variables
exec_path=$1 # path of exec to use
exec_file=$(basename $exec_path) # name of exec to use
macospackage_tmp=/tmp/macos-package.d # tmp dir to do stuff in
macospackage_dir=$macospackage_tmp/$exec_file.app/Contents # tmp contents dir
macospackage_app=$exec_file.app # name of app
macospackage_out=$HOME/Desktop # where to put app when complete
### script
echo "Packaging $exec_file..."
mkdir -p $macospackage_dir/MacOS/
cp $exec_path $macospackage_dir/MacOS/$exec_file
echo "Done."
echo "Moving to $macospackage_out..."
cp -R $macospackage_tmp/$macospackage_app $macospackage_out/
echo "Done."
echo "Cleaning up..."
rm -rf $macospackage_tmp/
echo "Done."
echo "'$exec_file' packaged into '$macospackage_app'."