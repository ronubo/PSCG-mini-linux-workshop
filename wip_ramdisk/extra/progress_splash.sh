#!/bin/sh
# Illustrates the logic of psplash "FAKE_LOGIC" we used in the previous commit
# To use it, make sure /tmp exists before running psplash
# You could alternatively use psplash-write but we didn't bother to include it for now

DIR=/tmp
if [ ! -e $DIR ] ; then 
  echo "You must have $DIR in your filesystem before executing psplash if you want to communicate with it" ; 
  exit 1
fi

PSPLASH_FIFO=$DIR/psplash_fifo
if [ ! -e $PSPLASH_FIFO ] ; then 
  echo "You must have $PSPLASH_FIFO as a fifo in your filesystem. Are you sure psplash is running? (probably not!)" ; 
  exit 2
fi


PROGRESS=0
echo -n -e "PROGRESS $PROGRESS\0" > $PSPLASH_FIFO
sleep 1
PROGRESS=20
echo -n -e "PROGRESS $PROGRESS\0" > $PSPLASH_FIFO
sleep 1
PROGRESS=40
echo -n -e "PROGRESS $PROGRESS\0" > $PSPLASH_FIFO
sleep 1
PROGRESS=70
echo -n -e "PROGRESS $PROGRESS\0" > $PSPLASH_FIFO
sleep 1
PROGRESS=99
echo -n -e "PROGRESS $PROGRESS\0" > $PSPLASH_FIFO

MESSAGE="For great justice."
echo -n -e "MSG $(date) $MESSAGE\0" > $PSPLASH_FIFO
sleep 1

PROGRESS=100
echo -n -e "PROGRESS $PROGRESS\0" > $PSPLASH_FIFO
sleep 0.2 # Current psplash implementation is sensitive to timing, hence we add some delay. We don't bother to fix it.

echo -n -e "QUIT\0" > $PSPLASH_FIFO 



