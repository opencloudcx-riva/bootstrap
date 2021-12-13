#!/bin/bash

echo ""
echo "Attempting to connect to the k8s clusters..."
echo ""

function usage() {
    echo "usage: connect.sh [options]"
    echo " "
    echo "  options:"
    echo " "
    echo "    -p, --profile   AWS profile name to use for execution"
    echo "    -d. --default   Use default profile"
    echo " "
}

function getEksInfo() {

  if [ $2 != "[" ] && [ $2 != "]" ]; then
    _k8sName=$(echo $2 | sed 's/,*$//g')

    IFS='-'
    read -ra STACKNAME <<< "$2"
    _stackName="$(echo ${STACKNAME[2]} | sed 's/,*$//g' )"

    aws eks --region us-east-1 update-kubeconfig --name "$_k8sName" --alias "$_stackName" --profile "$1" > /dev/null
    kubectl config use-context $_stackName > /dev/null

    echo "==================== $_stackName stack"
    echo ""

    _thing=$(kubectl get sa/k8s-dashboard-admin --namespace spinnaker -o jsonpath="{.secrets[0].name}" 2> /dev/null) 

    if [ ! -z "$_thing" ]; then
      _dashboardToken=$(kubectl get secret -n spinnaker "$_thing" -o go-template="{{.data.token | base64decode}}" 2> /dev/null)  
      if [ ! -z "$_dashboardToken" ]; then
        echo "Dashboard token"
        echo "---------------"
        echo "${_dashboardToken}"
        echo ""
        # _passwordTable="${_passwordTable}\nDashboard token,${_dashboardToken}"
      fi
    fi

    _jenkinsPw=$(kubectl get secret --namespace jenkins jenkins -o jsonpath="{.data.jenkins-admin-password}" 2> /dev/null | base64 --decode) 
    if [ ! -z "$_jenkinsPw" ]; then
      _passwordTable="${_passwordTable}\nJenkins,${_jenkinsPw}"
    fi

    _grafanaPw=$(kubectl get secret --namespace opencloudcx grafana-admin -o jsonpath="{.data.password}" 2> /dev/null | base64 --decode)
    if [ ! -z "$_grafanaPw" ]; then
      _passwordTable="${_passwordTable}\nGrafana,${_grafanaPw}"
    fi

    _codeserverPw=$(kubectl get secret --namespace develop code-server -o jsonpath="{.data.password}" 2> /dev/null | base64 --decode)
    if [ ! -z "$_codeserverPw" ]; then
      _passwordTable="${_passwordTable}\nCodeServer,${_codeserverPw}"
    fi

    if [ ! -z "$_passwordTable" ]; then
      echo "Services and Passwords"
      echo "----------------------"
      echo -e $_passwordTable | column -t -x -s ',' 
    else
      echo "No resources to list..."
    fi
    echo ""
  fi
}

_PROFILE="default"
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
  echo "No profile specified. Defaulting to [default] entry in configuration (~/.aws/credentials). Use -p to specify a named profile to use."
  _PROFILE="default"
fi

export -f usage
export -f getEksInfo

aws eks list-clusters --profile odos-tc --region us-east-1 | jq -j ".clusters" | xargs -n 1 -I {} bash -c 'getEksInfo "'$_PROFILE'" "$@"' _ {}

echo ""
echo " *************** Current context --> [$(kubectl config current-context)] ***************"
