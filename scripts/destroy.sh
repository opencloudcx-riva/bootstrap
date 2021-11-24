#!/bin/bash


_POSITIONAL=()
while [[ $# -gt 0 ]]
do
_key="$1"

case $_key in
  -p|--profile)
    _PROFILE="$2"
    shift
    shift
    ;;
  -d|--default)
    _PROFILE="default"
    shift
    shift
    ;;
  *)
    _POSITIONAL+=("$1")
    echo "!! Unknown parameter [$_key]"
    shift
    ;;
esac
done

set -- "${POSITIONAL[@]}"

if [ -z "$_PROFILE" ]; then
  echo " "
  echo "No profile specified. Use -p to specify a named profile to use or -d to use [default] profile."
  exit 101
fi

echo " ---------------- FIRST PASS DESTROY "
AWS_PROFILE=$_PROFILE terraform destroy --auto-approve

echo " ---------------- SECOND PASS DESTROY "
AWS_PROFILE=$_PROFILE terraform destroy --auto-approve

echo " ---------------- DELETE spinnaker NAMESPACE "
kubectl delete namespace spinnaker

echo " ---------------- THIRD PASS DESTROY "
AWS_PROFILE=$_PROFILE terraform destroy --auto-approve

