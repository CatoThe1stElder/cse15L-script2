#!/bin/bash
# Name: Edmud T. Leibert III
# Account ID: cs15wi20ajl@ieng6-202.ucsd.edu
# File: crypt.sh
# Assignment: Scripting Project 2
# Date: 3/7/2019

#===============================================================================
# DO NOT TOUCH BELOW THIS LINE
#===============================================================================

# This gets the character for a corresponding ASCII value
chr() {
  [ "$1" -lt 256 ] || return 1
  printf "\\$(printf '%03o' "$1")"
}

# This gets the ASCII value of a character
ord() {
  LC_CTYPE=C printf '%d' "'$1"
}


A_VAL=`ord A` # numerical value of the capital letter A
#===============================================================================
# DO NOT TOUCH ABOVE THIS LINE
#===============================================================================

function encrypt_str {
#===============================================================================
# Explanation:
# This function will actually encrypt a given string with a given key.
# The first parameter passed in (in $1) shall be the line to encrypt.
# Second parameter passed in shall be the key to use to encrypt.
# Third parameter shall be "" if no output file, otherwise it shall be the
# filename.
#
# Here's the workflow:
# 1. Create your index for looping through the key, and create your output
#    string.
  ind=0
  outputString=""
# *Developer: Other declarations for code readability
  inputString=$1
  key=$2
  outputFileEnc=$3
# *Developer: Test inputs to ensure they are correct
  # echo -n "inputString: "
  # echo "$inputString"
  # echo -n "key: "
  # echo "$key"
  # echo -n "outputFileEnc: "
  # echo "$outputFileEnc"
# *Developer: If needed, extend key to match length of inputString
  while [ ${#key} -lt ${#inputString} ]; do
    key+="$key"
    if [ ${#key} -gt ${#inputString} ]; then
      delCharNum=$((${#key} - ${#inputString}))
      key=${key::-$delCharNum}
    fi
  done 
# *Developer: If needed, reduce key to match length of inputString
  while [ ${#key} -gt ${#inputString} ]; do
    if [ ${#key} -gt ${#inputString} ]; then
      delCharNum=$((${#key} - ${#inputString}))
      key=${key::-$delCharNum}
    fi
  done 
# *Developer: Set keyIndex to be zero
  keyIndex=-1
# 2. For each line in the file, do the following:
# 3. Grab the char at the current index
  for((index=0;index < ${#inputString};index++)); do
    char=${inputString:$index:1}
# *Developer: For debugging purposes
    # echo -n "char: "
    # echo $char
# 4. If it's not a space, then do the following:
# 5. Get the ASCII value of the current char.
    if [ "$char" != " " ]; then
      asciChar=`ord "$char"`
# *Developer: For debugging purposes
      # echo -n "asciChar: "
      # echo $asciChar
# 6. Get the index of the current char in the key
      keyIndex=$(( $keyIndex + 1 ))
      keyChar=${key:$keyIndex:1}
# *Developer: For debugging purposes
      # echo -n "Index: "
      # echo $index
      # echo -n "keyIndex: "
      # echo $keyIndex
# *Developer: For debugging purposes
      # echo -n "keyChar: "
      # echo $keyChar
# 7. Get the ASCII value of the char in the key.
      asciKeyChar=`ord "$keyChar"`
# 8. XXX USE THIS LINE TO GET THE ASCII VALUE OF THE REPLACEMENT CHAR XXX
      num=`echo "(($asciChar + $asciKeyChar) % 26) + $A_VAL" | bc`
# *Developer: For debugging purposes
      # echo -n "num: "
      # echo $num
# 9. Get the corresponding char for that value using `ch $num`
      newChar=`chr "$num"`
# *Developer: For debugging purposes
      # echo -n "newChar: "
      # echo $newChar
# 10. Append the char to the string.
      outputString+="$newChar"
# 11. If the char was a space, just append it without doing any of the above
#     steps
    else 
      outputString+=" "
    fi
  done
# 12. At the end of the loop, if the output file is an empty string, print the
#     line
  if [ -z "$3" ]; then
    echo $outputString
  else
# 13. Otherwise, APPEND the string to the output file.
    `echo "$outputString" >> "$outputFile"`
  fi
#===============================================================================
}

function decrypt_str {
#===============================================================================
# Explanation:
# This function will actually decrypt a given string with a given key.
# The first parameter passed in (in $1) shall be the line to decrypt.
# Second parameter passed in shall be the key used to encrypt.
# Third parameter shall be "" if no output file, otherwise it shall be the
# filename.
#
# Here's the workflow:
# 1. Create your index for looping through the key, and create your output
#    string.
  ind=0
  outputString=""
# *Developer: Other declarations for code readability
  inputString=$1
  key=$2
  outputFileEnc=$3
# *Developer: If needed, extend key to match length of inputString
  while [ ${#key} -lt ${#inputString} ]; do
    key+="$key"
    if [ ${#key} -gt ${#inputString} ]; then
      delCharNum=$((${#key} - ${#inputString}))
      key=${key::-$delCharNum}
    fi
  done 
# *Developer: If needed, reduce key to match length of inputString
  while [ ${#key} -gt ${#inputString} ]; do
    if [ ${#key} -gt ${#inputString} ]; then
      delCharNum=$((${#key} - ${#inputString}))
      key=${key::-$delCharNum}
    fi
  done 
# *Developer: Set keyIndex to be zero
  keyIndex=-1
# 2. For each line in the file, do the following:
# 3. Grab the char at the current index
  for((index=0;index < ${#inputString};index++)); do
    char=${inputString:$index:1}
# *Developer: For debugging purposes
    # echo -n "char: "
    # echo $char
# 4. If it's not a space, then do the following:
# 5. Get the ASCII value of the current char.    
    if [ "$char" != " " ]; then
      asciChar=`ord "$char"`
# *Developer: For debugging purposes
      # echo -n "asciChar: "
      # echo $asciChar
# 6. Get the index of the current char in the key
      keyIndex=$(( $keyIndex + 1 ))
      keyChar=${key:$keyIndex:1}
# *Developer: For debugging purposes
      # echo -n "Index: "
      # echo $index
      # echo -n "keyIndex: "
      # echo $keyIndex
# *Developer: For debugging purposes
      # echo -n "keyChar: "
      # echo $keyChar
# 7. Get the ASCII value of the char in the key.
      asciKeyChar=`ord "$keyChar"`
# 8. XXX USE THIS LINE TO GET THE ASCII VALUE OF THE REPLACEMENT CHAR XXX
      num=`echo "(($asciChar - $asciKeyChar + 26) % 26) + $A_VAL" | bc`
# 9. Get the corresponding char for that value using `chr $num`
      newChar=`chr "$num"`
# *Developer: For debugging purposes
      # echo -n "newChar: "
      # echo $newChar
# 10. Append the char to the string.
      outputString+="$newChar"
# 11. If the char was a space, just append it without doing any of the above
#     steps
    else 
      outputString+=" "
    fi
  done
# 12. At the end of the loop, if the output file is an empty string, print the
#     line
  # echo -n "Output: "
  # echo -n "a"
  # echo -n $outputFileEnc
  # echo "a"

  if [ -z "$3" ]; then
    echo $outputString
  else
# 13. Otherwise, APPEND the string to the output file.
    `echo "$outputString" >> "$outputFile"`
  fi
#===============================================================================
}

function encrypt {
#===============================================================================
# Explanation:
# This function will act as a wrapper for encrypt_str.
#
# Here's the workflow:
# *Declare empty string and outputFile
  emptyString=""
  outputFile=""
# 1. Create your output file name string.
  fileOutput="fileOutput"
# 2. Get the key from the user to use to encrypt.
  echo -n "Enter a key to use to encrypt: "
  read encKey
# 3. check if they wanna read from a file or from the command line.
#    If they pick file, then get the name of the file they want to read.
  echo -n "Read from (f)ile or (c)ommand line? "
  read readMode
  echo

  if [ $readMode = "f" ]; then
    echo -n "Enter an input file: "
    read inputFile
    echo
  fi
# 4. Ask if they want to output to a file or from the command line.
#    If they pick file and gave an input file, the output file should
#    be the name of the inputfile with ".enc" appended to it. Otherwise,
#    prompt them for the filename they want to use and add ".enc" to it.
#    If the output file exists already, be sure to delete it.
  echo -n "Output to (f)ile or (c)ommand line? "
  read outputMode
  # echo

  if [ $outputMode = "f" ]; then
    if [ $readMode = "f" ]; then
      outputFile=$inputFile
      outputFile=${outputFile}.enc
    else
      echo -n "Enter an output file name: "
      read outputFile
      echo
      outputFile=${outputFile}.enc
    fi
  fi

  if [ -f $outputFile ]; then
    `rm -f $outputFile`
  fi
# 5. If they picked a file, loop through the file line by line calling
#    encrypt_str on each line of the file. Otherwise, prompt them for a string
#    to encrypt and call encrypt_str on their string.
  # echo -n "readMode: "
  # echo $readMode

  if [ $readMode = "f" ]; then
    if [ $outputMode = "f" ]; then
      # echo "FIRST OPTION"
      while read LINE; do
        # echo $LINE
        encrypt_str "$LINE" "$encKey" "$outputFile"
      done < $outputFile
    else
      # echo "SECOND OPTION"
      while read LINE; do
        # echo $LINE
        encrypt_str "$LINE" "$encKey" "$emptyString"
      done < $inputFile
    fi
  else
    # echo "THIRD OPTION"
    echo -n "Enter the string to encrypt: "
    read encString
    encrypt_str "$encString" "$encKey" "$outputFile"
  fi
#===============================================================================

  # TODO make sure you remove this!!!
  # >&2 echo "Great success!"
  # XXX you will lose points if this prints!
}

function decrypt {
#===============================================================================
# Explanation:
# This function will act as a wrapper for decrypt_str.
#
# Here's the workflow:
# *Declare empty string
  emptyString=""
# 1. Create your output file name string.
  fileOutput="fileOutput"
# 2. Get the key from the user used to encrypt
  echo -n "Enter a key to use to encrypt: "
  read encKey
# 3. check if they wanna read from a file or from the command line.
#    If they pick file, then get the name of the file they want to read.
  echo -n "Read from (f)ile or (c)ommand line? "
  read readMode
  echo

   if [ $readMode = "f" ]; then
    echo -n "Enter an input file: "
    read inputFile
    echo
  fi
# 4. Ask if they want to output to a file or from the command line.
#    If they pick file and gave an input file, the output file should
#    be the name of the inputfile without the ".enc" appended to it. Otherwise,
#    prompt them for a filename and just use that one WITHOUT DOING ANYTHING TO IT.
#    If the output file exists already, be sure to delete it.
  echo -n "Output to (f)ile or (c)ommand line? "
  read outputMode
  echo

  if [ $outputMode = "f" ]; then
    if [ $readMode = "f" ]; then
      outputFile=$inputFile
      outputFile=${outputFile::-4}
    else
      echo -n "Enter an output file name: "
      read outputFile
      echo
      outputFile=${outputFile}
    fi
  fi

  if [ -f $outputFile ]; then
    `rm -f $outputFile`
  fi
# 5. If they picked a file, loop through the file line by line calling
#    decrypt_str on each line of the file. Otherwise, prompt them for a string
#    to decrypt and call decrypt_str on their string.
  if [ $readMode = "f" ]; then
    if [ $outputMode = "f" ]; then
      while read LINE; do
        # echo $LINE
        decrypt_str "$LINE" "$encKey" "$outputFile"
      done < $inputFile
    else
      while read LINE; do
        # echo $LINE
        decrypt_str "$LINE" "$encKey" "$emptyString"
      done < $inputFile
    fi
  else
    echo -n "Enter the string to decrypt: "
    read decString

    # echo -n "decString: "
    # echo $decString
    # echo -n "encKey: "
    # echo $encKey
    # echo -n "emptyString: "
    # echo -n "a"
    # echo -n $emptyString
    # echo "a"

    decrypt_str "$decString" "$encKey" "$outputFile"
  fi
#===============================================================================

  # TODO make sure you remove this!!!
  # >&2 echo "Great success!"
  # XXX you will lose points if this prints!

}

#===============================================================================
# DO NOT TOUCH BELOW THIS LINE
#===============================================================================
function main {

  # Read in which mode the user wants
  echo -n "(e)ncrypt or (d)ecrypt? "
  read repl
  echo

  if [ $repl = "e" ]; then
    encrypt
  elif [ $repl = "d" ]; then
    decrypt
  else
    echo "Invalid option: $repl"
    exit 1
  fi
}

main

#===============================================================================
# DO NOT TOUCH ABOVE THIS LINE
#