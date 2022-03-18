files_num=0
dirs_num=0
files_names=(a a a a a) 
files_sizes=(0 0 0 0 0)
dirs_names=(a a a a a)
dirs_sizes=(0 0 0 0 0)
perms=(0 0 0 0)
total_size=0

if [ $# -eq 2 ]
then
     arg=$2
else
     arg=0
fi        

function check_dir {

    if [ $arg -eq 0 ]
    then
        for f in ` ls $1`
        do
          if [ -d $1/$f ]
          then
              dirs_num=$(($dirs_num + 1))
              check_dir $1/$f
          else 
              files_num=$(($files_num+1))
             
              case `stat -c %a $1/$f` in
              770)
                 perms[0]=$((${perms[0]}+1))
                 ;;
     
             700)
                 perms[1]=$((${perms[1]}+1))
                 ;;
             755)
                 perms[2]=$((${perms[2]}+1))
                 echo $1/$f
                 ;;
             750)
                 perms[3]=$((${perms[3]}+1))
                 ;;
            esac
          fi
        done
    else
         for k in  $( find $1 -mindepth 1 -maxdepth $arg)
         do
           if [ -d $k ]
           then
                dirs_num=$(($dirs_num+1))  
           else
                files_num=$(($files_num+1))
                case `stat -c %a $k` in
                770)
                   perms[0]=$((${perms[0]}+1))
                   ;;
      
                700)
                  perms[1]=$((${perms[1]}+1))
                  ;;
                755)
                  perms[2]=$((${perms[2]}+1))
                  ;;
                750)
                  perms[3]=$((${perms[3]}+1))
                  ;;
               esac
           fi
        done
    fi
        
}            
function largest_dirs {

` cd $1`
 if [ $arg -eq 0 ]
 then
    for f in `ls $1`
    do
      if [ -f $1/$f ]
      then
           size=`stat -c%s $1/$f`
           total_size=$(($total_size + $size))
      fi
    done
    update_dirs $1 $total_size
    total_size=0
 
    for k in ` ls $1`
    do
      if [ -d $1/$k ]
      then
          largest_dirs $1/$k
      fi
    done
 else
   
     for i in  $( find $1 -mindepth 0 -maxdepth $arg)
     do
       if [ -d $i ]
       then
           for n in ` ls $i`
           do
             if [ -f $i/$n ]
             then
               size=`stat -c%s $i/$n`
               total_size=$(($total_size + $size))
             fi
           done
       fi
       update_dirs $i $total_size
       total_size=0   
     done       
 fi
         
}

function update_dirs {
     
    if [ $2 -gt ${dirs_sizes[0]} ]; then
        dirs_names[4]=${dirs_names[3]}
        dirs_names[3]=${dirs_names[2]}
        dirs_names[2]=${dirs_names[1]}
        dirs_names[1]=${dirs_names[0]}
        dirs_sizes[4]=${dirs_sizes[3]}
        dirs_sizes[3]=${dirs_sizes[2]}
        dirs_sizes[2]=${dirs_sizes[1]}
        dirs_sizes[1]=${dirs_sizes[0]}
        dirs_names[0]=$1
        dirs_sizes[0]=$2
    elif [ $2 -gt ${dirs_sizes[1]} ]; then
        dirs_names[4]=${dirs_names[3]}
        dirs_names[3]=${dirs_names[2]}
        dirs_names[2]=${dirs_names[1]}
        dirs_sizes[4]=${dirs_sizes[3]}
        dirs_sizes[3]=${dirs_sizes[2]}
        dirs_sizes[2]=${dirs_sizes[1]}
        dirs_names[1]=$1
        dirs_sizes[1]=$2
    elif [ $2 -gt ${dirs_sizes[2]} ]; then
        dirs_names[4]=${dirs_names[3]}
        dirs_names[3]=${dirs_names[2]}
        dirs_sizes[4]=${dirs_sizes[3]}
        dirs_sizes[3]=${dirs_sizes[2]}
        dirs_names[2]=$1
        dirs_sizes[2]=$2
    elif [ $2 -gt ${dirs_sizes[3]} ]; then
        dirs_names[4]=${dirs_names[3]}
        dirs_sizes[4]=${dirs_sizes[3]}
        dirs_names[3]=$1
        dirs_sizes[3]=$2
    elif [ $2 -gt ${dirs_sizes[4]} ]; then
        dirs_names[4]=$1
        dirs_sizes[4]=$2
    fi

}

function update_files {
    if [ $2 -gt ${files_sizes[0]} ]; then
        files_names[4]=${files_names[3]}
        files_names[3]=${files_names[2]}
        files_names[2]=${files_names[1]}
        files_names[1]=${files_names[0]}
        files_sizes[5]=${files_sizes[4]}
        files_sizes[4]=${files_sizes[3]}
        files_sizes[3]=${files_sizes[2]}
        files_sizes[2]=${files_sizes[1]}
        files_sizes[1]=${files_sizes[0]}
        files_names[0]=$1
        files_sizes[0]=$2
    elif [ $2 -gt ${files_sizes[1]} ]; then
        files_names[4]=${files_names[3]}
        files_names[3]=${files_names[2]}
        files_names[2]=${files_names[1]}
        files_sizes[4]=${files_sizes[3]}
        files_sizes[3]=${files_sizes[2]}
        files_sizes[2]=${files_sizes[1]}
        
        files_names[1]=$1
        files_sizes[1]=$2
    elif [ $2 -gt ${files_sizes[2]} ]; then
        files_names[4]=${files_names[3]}
        files_names[3]=${files_names[2]}
      
  files_sizes[4]=${files_sizes[3]}
        files_sizes[3]=${files_sizes[2]}
        files_names[2]=$1
        files_sizes[2]=$2
    elif [ $2 -gt ${files_sizes[3]} ]; then
        files_names[4]=${files_names[3]}
        files_sizes[4]=${files_sizes[3]}
        files_names[3]=$1
        files_sizes[3]=$2
    elif [ $2 -gt ${files_sizes[3]} ]; then
        files_names[4]=$1
        files_sizes[4]=$2
    fi
}

function dirs_files {
 `cd $1`
if [ $arg -eq 0 ] 
then

 for f in `ls $1`
 do
     if [ -d $1/$f ]
     then
          sumdirs=$(($sumdirs+1))
     else 
          sumfiles=$(($sumfiles+1))
     fi
 done


 update_dirs $1 $sumdirs
 update_files $1 $sumfiles

 sumdirs=0
 sumfiles=0

 for k in `ls $1`
 do
  if [ -d $1/$k ]
  then
          dirs_files $1/$k
            
   fi
 done
else
   for i in  $( find $1 -mindepth 0 -maxdepth $arg)
   do
     if [ -d $i ]
     then
       for n in `ls $i`
       do
         if [ -d $i/$n ]
         then
           sumdirs=$((sumdirs+1))   
         else
           sumfiles=$((sumfiles+1))
         fi
       done
          update_dirs $i $sumdirs
          update_files $i $sumfiles 
          sumdirs=0
          sumfiles=0
     fi
   done
fi
    
}

files_num=0
dirs_num=0

check_dir $1

echo Monitored directories: $1
echo Depth: $2
echo Number of directories: $dirs_num
echo Number of files: $files_num
echo Found $files_num files and $dirs_num dirs.
echo Total size on disk:`du -s -h $1`

echo -e "\nPermission on files"
array=(770 700 755 750)
tmp=0
temp=0
for i in `seq 0 4`
do
  if [ ${perms[0]} -lt ${perms[1]} ]
  then
    tmp=${perms[0]} 
    perms[0]=${perms[1]}
    perms[1]=$tmp
    temp=${array[0]}
    array[0]=${array[1]}
    array[1]=$temp

  elif [ ${perms[1]} -lt ${perms[2]} ]
  then
     tmp=${perms[1]}
     perms[1]=${perms[2]}
     perms[2]=$tmp
     temp=${array[1]}
     array[1]=${array[2]}
     array[2]=$temp
  elif [ ${perms[2]} -lt ${perms[3]} ]
  then  
     tmp=${perms[2]}
     perms[2]=${perms[3]}
     perms[3]=$tmp
     temp=${array[2]}
     array[2]=${array[3]}
     array[3]=$temp
  elif [ ${perms[0]} -lt ${perms[3]} ]
  then
     tmp=${perms[3]}
     perms[3]=${perms[0]}
     perms[0]=$tmp 
     temp=${array[3]}
     array[3]=${array[0]}
     array[0]=$temp
  fi
done

echo  -e "${array[0]} $((${perms[0]}*100/$files_num))%" 
echo  -e "${array[1]} $((${perms[1]}*100/$files_num))%" 
echo  -e "${array[2]} $((${perms[2]}*100/$files_num))%" 
echo  -e "${array[3]} $((${perms[3]}*100/$files_num))%" 

if [ $arg -eq 0 ]
then
  last_accessed=`find $1 -type f -printf "\n%AD %AT %p" |head -n 5| sort -n`
  last_modified=`find $1 -type f -printf "\n%Tc %p" | head -n 5 | sort -n -r`
else
  last_accessed=`find $1 -maxdepth $2 -type f -printf "\n%AD %AT %p" |head -n 5| sort -n`
  last_modified=`find $1 -maxdepth $2 -type f -printf "\n%Tc %p" | head -n 5 | sort -n -r`
fi
echo  -e "\nLastly accessed files $last_accessed"
echo  -e "\nLastly modified files \n$last_modified" 
echo -e "\nLargest Directories"                                        
largest_dirs $1
for i in `seq 0 4 `
do 
   echo ${dirs_names[$i]}- ${dirs_sizes[$i]}
done

for i in `seq 0 4`
do
   files_sizes[$i]=0
   files_names[$i]=a
   dirs_sizes[$i]=0
   dirs_names[$i]=a
done

sumdirs=0
sumfiles=0

dirs_files $1
echo -e "\nDirs with more files(in the dir level)"
for i in `seq 0 4 `
do 
   echo ${files_names[$i]}- ${files_sizes[$i]}
done
echo -e "\nDirs with more dirs(in the dir level)"
for i in `seq 0 4 `
do 
   echo ${dirs_names[$i]}- ${dirs_sizes[$i]}
done
	

