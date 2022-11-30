#!/usr/bin/bash
if ! which sshpass &>/dev/null; then
 echo "sshpass is required to run adminman please install it with your package manager.";
 exit;
fi
if [[ $# < 1 ]]; then
 echo "$0 <add/delete/execute/list> ...";
 exit;
fi
if [[ $1 = "list" ]]; then
 cat .lst;
fi
if [[ $1 = "add" ]]; then
 if [[ $# = 2 ]]; then
  echo "OK";
  echo $2 >> .lst;
 else
  echo "ip:user:pass";
 fi
fi
if [[ $1 = "delete" ]]; then
 if [[ $# = 2 ]]; then
  echo "OK";
  cat .lst | grep -v $2 | tee .lst.tmp;
  mv .lst.tmp .lst;
 else
  echo "ip";
 fi
fi
if [[ $1 = "execute" ]]; then
 if [[ $# = 2 ]]; then
  echo "OK";
  for host in $(cat .lst); do
   passwd=$(echo $host | cut -d ":" -f 3);
   user=$(echo $host | cut -d ":" -f 2); 
   ip=$(echo $host | cut -d ":" -f 1);
   sshpass -p $passwd ssh $user@$ip "$2";
  done
 else
  echo "command";
 fi
fi
