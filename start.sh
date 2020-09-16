#!/bin/bash
echo " start the ssh service "
service ssh start
echo " check the ssh service status "
service ssh status
echo " copy script to ${POD1} "
kubectl cp /opt/getstate.js ${POD1}:/tmp/getstate.js -n $NAMESPACE
echo " copy script to ${POD2} "
kubectl cp /opt/getstate.js ${POD2}:/tmp/getstate.js -n $NAMESPACE
echo " copy script to ${POD3} "
kubectl cp /opt/getstate.js ${POD3}:/tmp/getstate.js -n $NAMESPACE

mongo1=$(kubectl exec -i ${POD1} -- bash -c " mongo  /tmp/getstate.js --quiet"  -n ${NAMESPACE} )
echo " ${POD1} is ${mongo1}"
mongo2=$(kubectl exec -i ${POD2} -- bash -c " mongo  /tmp/getstate.js --quiet"  -n ${NAMESPACE} )
echo " ${POD2} is ${mongo2}"
mongo3=$(kubectl exec -i ${POD3} -- bash -c " mongo  /tmp/getstate.js --quiet"  -n ${NAMESPACE} )
echo " ${POD3} is ${mongo3}"


if [[ ${mongo1} =~ "PRIMARY" ]]
then
PRIMARY=${POD1}
echo "PRIMARY is ${PRIMARY} "
elif [[ ${mongo2} =~ "PRIMARY" ]]
then
PRIMARY=${POD2}
echo "PRIMARY is ${PRIMARY} "
elif [[ ${mongo3} =~ "PRIMARY" ]]
then
   PRIMARY=${POD3}
echo "PRIMARY is ${PRIMARY} "
else
   echo "None of the condition met"
fi


echo "port-forward from ${PRIMARY} "

kubectl port-forward --address 0.0.0.0 pod/$PRIMARY 27017:27017  -n $NAMESPACE

