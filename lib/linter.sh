#!/usr/bin/env bash
# shellcheck disable=SC1003,SC2016,SC1091

################################################################################
################################################################################
########### Super-Linter (Lint all the code) @admiralawkbar ####################
################################################################################
################################################################################

#########################
# Source Function Files #
#########################
source /action/lib/buildFileList.sh   # Source the function script(s)
source /action/lib/validation.sh      # Source the function script(s)
source /action/lib/worker.sh          # Source the function script(s)

###########
# GLOBALS #
###########
# Default Vars
DEFAULT_RULES_LOCATION='/action/lib/.automation'                    # Default rules files location
LINTER_RULES_PATH="${LINTER_RULES_PATH:-.github/linters}"           # Linter Path Directory
# YAML Vars
YAML_FILE_NAME='.yaml-lint.yml'                                     # Name of the file
YAML_LINTER_RULES="$DEFAULT_RULES_LOCATION/$YAML_FILE_NAME"         # Path to the yaml lint rules
# MD Vars
MD_FILE_NAME='.markdown-lint.yml'                                   # Name of the file
MD_LINTER_RULES="$DEFAULT_RULES_LOCATION/$MD_FILE_NAME"             # Path to the markdown lint rules
# Python Vars
PYTHON_FILE_NAME='.python-lint'                                     # Name of the file
PYTHON_LINTER_RULES="$DEFAULT_RULES_LOCATION/$PYTHON_FILE_NAME"     # Path to the python lint rules
# Cloudformation Vars
CFN_FILE_NAME='.cfnlintrc.yml'                                      # Name of the file
CFN_LINTER_RULES="$DEFAULT_RULES_LOCATION/$CFN_FILE_NAME"           # Path to the python lint rules
# Ruby Vars
RUBY_FILE_NAME="${RUBY_CONFIG_FILE:-.ruby-lint.yml}"                # Name of the file
RUBY_LINTER_RULES="$DEFAULT_RULES_LOCATION/$RUBY_FILE_NAME"         # Path to the ruby lint rules
# Coffee Vars
COFFEE_FILE_NAME='.coffee-lint.json'                                  # Name of the file
COFFEESCRIPT_LINTER_RULES="$DEFAULT_RULES_LOCATION/$COFFEE_FILE_NAME" # Path to the coffeescript lint rules
# Javascript Vars
JAVASCRIPT_FILE_NAME="${JAVASCRIPT_ES_CONFIG_FILE:-.eslintrc.yml}"      # Name of the file
JAVASCRIPT_LINTER_RULES="$DEFAULT_RULES_LOCATION/$JAVASCRIPT_FILE_NAME" # Path to the Javascript lint rules
JAVASCRIPT_STANDARD_LINTER_RULES=''                                     # ENV string to pass when running js standard
# Typescript Vars
TYPESCRIPT_FILE_NAME="${TYPESCRIPT_ES_CONFIG_FILE:-.eslintrc.yml}"      # Name of the file
TYPESCRIPT_LINTER_RULES="$DEFAULT_RULES_LOCATION/$TYPESCRIPT_FILE_NAME" # Path to the Typescript lint rules
TYPESCRIPT_STANDARD_LINTER_RULES=''                                     # ENV string to pass when running js standard
# Ansible Vars
ANSIBLE_FILE_NAME='.ansible-lint.yml'                               # Name of the file
ANSIBLE_LINTER_RULES="$DEFAULT_RULES_LOCATION/$ANSIBLE_FILE_NAME"   # Path to the Ansible lint rules
# Docker Vars
DOCKER_FILE_NAME='.dockerfilelintrc'                                # Name of the file
DOCKER_LINTER_RULES="$DEFAULT_RULES_LOCATION/$DOCKER_FILE_NAME"     # Path to the Docker lint rules
# Golang Vars
GO_FILE_NAME='.golangci.yml'                                        # Name of the file
GO_LINTER_RULES="$DEFAULT_RULES_LOCATION/$GO_FILE_NAME"             # Path to the Go lint rules
# Terraform Vars
TERRAFORM_FILE_NAME='.tflint.hcl'                                        # Name of the file
TERRAFORM_LINTER_RULES="$DEFAULT_RULES_LOCATION/$TERRAFORM_FILE_NAME"    # Path to the Terraform lint rules
# Powershell Vars
POWERSHELL_FILE_NAME='.powershell-psscriptanalyzer.psd1'                   # Name of the file
POWERSHELL_LINTER_RULES="$DEFAULT_RULES_LOCATION/$POWERSHELL_FILE_NAME"    # Path to the Powershell lint rules
# CSS Vars
CSS_FILE_NAME='.stylelintrc.json'                                   # Name of the file
CSS_LINTER_RULES="$DEFAULT_RULES_LOCATION/$CSS_FILE_NAME"           # Path to the CSS lint rules
# OpenAPI Vars
OPENAPI_FILE_NAME='.openapirc.yml'                                   # Name of the file
OPENAPI_LINTER_RULES="$DEFAULT_RULES_LOCATION/$OPENAPI_FILE_NAME"   # Path to the OpenAPI lint rules
# Protocol Buffers Vars
PROTOBUF_FILE_NAME='.protolintrc.yml'                                   # Name of the file
PROTOBUF_LINTER_RULES="$DEFAULT_RULES_LOCATION/$PROTOBUF_FILE_NAME"   # Path to the Protocol Buffers lint rules
# Clojure Vars
CLOJURE_FILE_NAME='.clj-kondo/config.edn'
CLOJURE_LINTER_RULES="$DEFAULT_RULES_LOCATION/$CLOJURE_FILE_NAME"

#######################################
# Linter array for information prints #
#######################################
LINTER_ARRAY=("jsonlint" "yamllint" "xmllint" "markdownlint" "shellcheck"
  "pylint" "perl" "rubocop" "coffeelint" "eslint" "standard"
  "ansible-lint" "/dockerfilelint/bin/dockerfilelint" "golangci-lint" "tflint"
  "stylelint" "dotenv-linter" "powershell" "ktlint" "protolint" "clj-kondo"
  "spectral" "cfn-lint")


#############################
# Language array for prints #
#############################
LANGUAGE_ARRAY=('YML' 'JSON' 'XML' 'MARKDOWN' 'BASH' 'PERL' 'PHP' 'RUBY' 'PYTHON'
  'COFFEESCRIPT' 'ANSIBLE' 'JAVASCRIPT_STANDARD' 'JAVASCRIPT_ES'
  'TYPESCRIPT_STANDARD' 'TYPESCRIPT_ES' 'DOCKER' 'GO' 'TERRAFORM'
  'CSS' 'ENV' 'POWERSHELL' 'KOTLIN' 'PROTOBUF' 'CLOJURE' 'OPENAPI' 'CFN')

###################
# GitHub ENV Vars #
###################
GITHUB_SHA="${GITHUB_SHA}"                            # GitHub sha from the commit
GITHUB_EVENT_PATH="${GITHUB_EVENT_PATH}"              # Github Event Path
GITHUB_WORKSPACE="${GITHUB_WORKSPACE}"                # Github Workspace
DEFAULT_BRANCH="${DEFAULT_BRANCH:-master}"            # Default Git Branch to use (master by default)
ANSIBLE_DIRECTORY="${ANSIBLE_DIRECTORY}"              # Ansible Directory
VALIDATE_ALL_CODEBASE="${VALIDATE_ALL_CODEBASE}"      # Boolean to validate all files
VALIDATE_YAML="${VALIDATE_YAML}"                      # Boolean to validate language
VALIDATE_JSON="${VALIDATE_JSON}"                      # Boolean to validate language
VALIDATE_XML="${VALIDATE_XML}"                        # Boolean to validate language
VALIDATE_MD="${VALIDATE_MD}"                          # Boolean to validate language
VALIDATE_BASH="${VALIDATE_BASH}"                      # Boolean to validate language
VALIDATE_PERL="${VALIDATE_PERL}"                      # Boolean to validate language
VALIDATE_PHP="${VALIDATE_PHP}"                        # Boolean to validate language
VALIDATE_PYTHON="${VALIDATE_PYTHON}"                  # Boolean to validate language
VALIDATE_CLOUDFORMATION="${VALIDATE_CLOUDFORMATION}"  # Boolean to validate language
VALIDATE_RUBY="${VALIDATE_RUBY}"                      # Boolean to validate language
VALIDATE_COFFEE="${VALIDATE_COFFEE}"                  # Boolean to validate language
VALIDATE_ANSIBLE="${VALIDATE_ANSIBLE}"                # Boolean to validate language
VALIDATE_JAVASCRIPT_ES="${VALIDATE_JAVASCRIPT_ES}"              # Boolean to validate language
VALIDATE_JAVASCRIPT_STANDARD="${VALIDATE_JAVASCRIPT_STANDARD}"  # Boolean to validate language
VALIDATE_TYPESCRIPT_ES="${VALIDATE_TYPESCRIPT_ES}"              # Boolean to validate language
VALIDATE_TYPESCRIPT_STANDARD="${VALIDATE_TYPESCRIPT_STANDARD}"  # Boolean to validate language
VALIDATE_DOCKER="${VALIDATE_DOCKER}"                  # Boolean to validate language
VALIDATE_GO="${VALIDATE_GO}"                          # Boolean to validate language
VALIDATE_CSS="${VALIDATE_CSS}"                        # Boolean to validate language
VALIDATE_ENV="${VALIDATE_ENV}"                        # Boolean to validate language
VALIDATE_CLOJURE="${VALIDATE_CLOJURE}"                # Boolean to validate language
VALIDATE_TERRAFORM="${VALIDATE_TERRAFORM}"            # Boolean to validate language
VALIDATE_POWERSHELL="${VALIDATE_POWERSHELL}"          # Boolean to validate language
VALIDATE_KOTLIN="${VALIDATE_KOTLIN}"                  # Boolean to validate language
VALIDATE_OPENAPI="${VALIDATE_OPENAPI}"                # Boolean to validate language
TEST_CASE_RUN="${TEST_CASE_RUN}"                      # Boolean to validate only test cases
DISABLE_ERRORS="${DISABLE_ERRORS}"                    # Boolean to enable warning-only output without throwing errors

##############
# Debug Vars #
##############
RUN_LOCAL="${RUN_LOCAL}"                                # Boolean to see if we are running locally
ACTIONS_RUNNER_DEBUG="${ACTIONS_RUNNER_DEBUG:-false}"   # Boolean to see even more info (debug)

################
# Default Vars #
################
DEFAULT_VALIDATE_ALL_CODEBASE='true'                    # Default value for validate all files
DEFAULT_WORKSPACE="${DEFAULT_WORKSPACE:-/tmp/lint}"     # Default workspace if running locally
DEFAULT_RUN_LOCAL='false'             # Default value for debugging locally
DEFAULT_TEST_CASE_RUN='false'         # Flag to tell code to run only test cases
DEFAULT_IFS="$IFS"                    # Get the Default IFS for updating

###############################################################
# Default Vars that are called in Subs and need to be ignored #
###############################################################
# shellcheck disable=SC2034
DEFAULT_DISABLE_ERRORS='false'        # Default to enabling errors
# shellcheck disable=SC2034
RAW_FILE_ARRAY=()                     # Array of all files that were changed
# shellcheck disable=SC2034
READ_ONLY_CHANGE_FLAG=0               # Flag set to 1 if files changed are not txt or md
# shellcheck disable=SC2034
TEST_CASE_FOLDER='.automation/test'   # Folder for test cases we should always ignore
# shellcheck disable=SC2034
DEFAULT_ANSIBLE_DIRECTORY="$GITHUB_WORKSPACE/ansible"   # Default Ansible Directory

##########################
# Array of changed files #
##########################
FILE_ARRAY_YML=()                   # Array of files to check
FILE_ARRAY_JSON=()                  # Array of files to check
FILE_ARRAY_XML=()                   # Array of files to check
FILE_ARRAY_MD=()                    # Array of files to check
FILE_ARRAY_BASH=()                  # Array of files to check
FILE_ARRAY_PERL=()                  # Array of files to check
FILE_ARRAY_PHP=()                   # Array of files to check
FILE_ARRAY_RUBY=()                  # Array of files to check
FILE_ARRAY_PYTHON=()                # Array of files to check
FILE_ARRAY_CFN=()                   # Array of files to check
FILE_ARRAY_COFFEESCRIPT=()          # Array of files to check
FILE_ARRAY_JAVASCRIPT_ES=()         # Array of files to check
FILE_ARRAY_JAVASCRIPT_STANDARD=()   # Array of files to check
FILE_ARRAY_TYPESCRIPT_ES=()         # Array of files to check
FILE_ARRAY_TYPESCRIPT_STANDARD=()   # Array of files to check
FILE_ARRAY_DOCKER=()                # Array of files to check
FILE_ARRAY_GO=()                    # Array of files to check
FILE_ARRAY_TERRAFORM=()             # Array of files to check
FILE_ARRAY_POWERSHELL=()            # Array of files to check
FILE_ARRAY_CSS=()                   # Array of files to check
FILE_ARRAY_ENV=()                   # Array of files to check
FILE_ARRAY_CLOJURE=()               # Array of files to check
FILE_ARRAY_KOTLIN=()                # Array of files to check
FILE_ARRAY_PROTOBUF=()              # Array of files to check
FILE_ARRAY_OPENAPI=()               # Array of files to check

############
# Counters #
############
ERRORS_FOUND_YML=0                  # Count of errors found
ERRORS_FOUND_JSON=0                 # Count of errors found
ERRORS_FOUND_XML=0                  # Count of errors found
ERRORS_FOUND_MARKDOWN=0             # Count of errors found
ERRORS_FOUND_BASH=0                 # Count of errors found
ERRORS_FOUND_PERL=0                 # Count of errors found
ERRORS_FOUND_PHP=0                  # Count of errors found
ERRORS_FOUND_RUBY=0                 # Count of errors found
ERRORS_FOUND_PYTHON=0               # Count of errors found
ERRORS_FOUND_CFN=0                  # Count of errors found
ERRORS_FOUND_COFFEESCRIPT=0         # Count of errors found
ERRORS_FOUND_ANSIBLE=0              # Count of errors found
ERRORS_FOUND_JAVASCRIPT_STANDARD=0  # Count of errors found
ERRORS_FOUND_JAVASCRIPT_ES=0        # Count of errors found
ERRORS_FOUND_TYPESCRIPT_STANDARD=0  # Count of errors found
ERRORS_FOUND_TYPESCRIPT_ES=0        # Count of errors found
ERRORS_FOUND_DOCKER=0               # Count of errors found
ERRORS_FOUND_GO=0                   # Count of errors found
ERRORS_FOUND_TERRAFORM=0            # Count of errors found
ERRORS_FOUND_POWERSHELL=0           # Count of errors found
ERRORS_FOUND_CSS=0                  # Count of errors found
ERRORS_FOUND_ENV=0                  # Count of errors found
ERRORS_FOUND_CLOJURE=0              # Count of errors found
ERRORS_FOUND_KOTLIN=0               # Count of errors found
ERRORS_FOUND_PROTOBUF=0             # Count of errors found
ERRORS_FOUND_OPENAPI=0              # Count of errors found

################################################################################
########################## FUNCTIONS BELOW #####################################
################################################################################
################################################################################
#### Function Header ###########################################################
Header()
{
  ###############################
  # Give them the possum action #
  ###############################
  /bin/bash /action/lib/possum.sh

  ##########
  # Prints #
  ##########
  echo ""
  echo "---------------------------------------------"
  echo "--- GitHub Actions Multi Language Linter ----"
  echo "---------------------------------------------"
  echo ""
  echo "---------------------------------------------"
  echo "The Super-Linter source code can be found at:"
  echo " - https://github.com/github/super-linter"
  echo "---------------------------------------------"
}
################################################################################
#### Function GetLinterVersions ################################################
GetLinterVersions()
{
  #########################
  # Print version headers #
  #########################
  echo ""
  echo "---------------------------------------------"
  echo "Linter Version Info:"
  echo "---------------------------------------------"
  echo ""

  ##########################################################
  # Go through the array of linters and print version info #
  ##########################################################
  for LINTER in "${LINTER_ARRAY[@]}"
  do
    echo "---------------------------------------------"
    echo "[$LINTER]:"
    ###################
    # Get the version #
    ###################
    # shellcheck disable=SC2207
    GET_VERSION_CMD=($("$LINTER" --version 2>&1))

    #######################
    # Load the error code #
    #######################
    ERROR_CODE=$?

    ##############################
    # Check the shell for errors #
    ##############################
    if [ $ERROR_CODE -ne 0 ] || [ -z "${GET_VERSION_CMD[*]}" ]; then
      echo "WARN! Failed to get version info for:[$LINTER]"
      echo "---------------------------------------------"
    else
      ##########################
      # Print the version info #
      ##########################
      echo "${GET_VERSION_CMD[*]}"
      echo "---------------------------------------------"
    fi
  done
}
################################################################################
#### Function GetLinterRules ###################################################
GetLinterRules()
{
  # Need to validate the rules files exist

  ################
  # Pull in vars #
  ################
  FILE_NAME="$1"      # Name fo the linter file
  FILE_LOCATION="$2"  # Location of the linter file

  #####################################
  # Validate we have the linter rules #
  #####################################
  if [ -f "$GITHUB_WORKSPACE/$LINTER_RULES_PATH/$FILE_NAME" ]; then
    echo "----------------------------------------------"
    echo "User provided file:[$FILE_NAME], setting rules file..."

    ####################################
    # Copy users into default location #
    ####################################
    CP_CMD=$(cp "$GITHUB_WORKSPACE/$LINTER_RULES_PATH/$FILE_NAME" "$FILE_LOCATION" 2>&1)

    ###################
    # Load Error code #
    ###################
    ERROR_CODE=$?

    ##############################
    # Check the shell for errors #
    ##############################
    if [ $ERROR_CODE -ne 0 ]; then
      echo "ERROR! Failed to set file:[$FILE_NAME] as default!"
      echo "ERROR:[$CP_CMD]"
      exit 1
    fi
  else
    ########################################################
    # No user default provided, using the template default #
    ########################################################
    if [[ "$ACTIONS_RUNNER_DEBUG" == "true" ]]; then
      echo "  -> Codebase does NOT have file:[$LINTER_RULES_PATH/$FILE_NAME], using Default rules at:[$FILE_LOCATION]"
    fi
  fi
}
################################################################################
#### Function GetStandardRules #################################################
GetStandardRules()
{
  ################
  # Pull In Vars #
  ################
  LINTER="$1" # Type: javascript | typescript

  #########################################################################
  # Need to get the ENV vars from the linter rules to run in command line #
  #########################################################################
  # Copy orig IFS to var
  ORIG_IFS="$IFS"
  # Set the IFS to newline
  IFS=$'\n'

  #########################################
  # Get list of all environment variables #
  #########################################
  # Only env vars that are marked as true
  GET_ENV_ARRAY=()
  if [[ "$LINTER" == "javascript" ]]; then
    # shellcheck disable=SC2207
    GET_ENV_ARRAY=($(yq .env "$JAVASCRIPT_LINTER_RULES" |grep true))
  elif [[ "$LINTER" == "typescript" ]]; then
    # shellcheck disable=SC2207
    GET_ENV_ARRAY=($(yq .env "$TYPESCRIPT_LINTER_RULES" |grep true))
  fi

  #######################
  # Load the error code #
  #######################
  ERROR_CODE=$?

  ##############################
  # Check the shell for errors #
  ##############################
  if [ $ERROR_CODE -ne 0 ]; then
    # ERROR
    echo "ERROR! Failed to gain list of ENV vars to load!"
    echo "ERROR:[${GET_ENV_ARRAY[*]}]"
    exit 1
  fi

  ##########################
  # Set IFS back to normal #
  ##########################
  # Set IFS back to Orig
  IFS="$ORIG_IFS"

  ######################
  # Set the env string #
  ######################
  ENV_STRING=''

  #############################
  # Pull out the envs to load #
  #############################
  for ENV in "${GET_ENV_ARRAY[@]}"
  do
    #############################
    # remove spaces from return #
    #############################
    ENV="$(echo -e "${ENV}" | tr -d '[:space:]')"
    ################################
    # Get the env to add to string #
    ################################
    ENV="$(echo "${ENV}" | cut -d'"' -f2)"
    # echo "ENV:[$ENV]"
    ENV_STRING+="--env ${ENV} "
  done

  #########################################
  # Remove trailing and ending whitespace #
  #########################################
  if [[ "$LINTER" == "javascript" ]]; then
    JAVASCRIPT_STANDARD_LINTER_RULES="$(echo -e "${ENV_STRING}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
  elif [[ "$LINTER" == "typescript" ]]; then
    TYPESCRIPT_STANDARD_LINTER_RULES="$(echo -e "${ENV_STRING}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
  fi
}
################################################################################
#### Function DetectOpenAPIFile ################################################
DetectOpenAPIFile()
{
  ################
  # Pull in vars #
  ################
  FILE="$1"

  ###############################
  # Check the file for keywords #
  ###############################
  grep -E '"openapi":|"swagger":|^openapi:|^swagger:' "$GITHUB_WORKSPACE/$FILE" > /dev/null

  #######################
  # Load the error code #
  #######################
  ERROR_CODE=$?

  ##############################
  # Check the shell for errors #
  ##############################
  if [ $ERROR_CODE -eq 0 ]; then
    ########################
    # Found string in file #
    ########################
	  return 0
  else
    ###################
    # No string match #
    ###################
	  return 1
  fi
}
################################################################################
#### Function DetectCloudFormationFile #########################################
DetectCloudFormationFile()
{
  ################
  # Pull in Vars #
  ################
  FILE="$1" # File that we need to validate

  # https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-formats.html
  # AWSTemplateFormatVersion is optional
  #######################################
  # Check if file has AWS Template info #
  #######################################
  if grep 'AWSTemplateFormatVersion' "$FILE" > /dev/null; then
    # Found it
    return 0
  fi

  ###################################################
  # Check if file has AWSTemplateFormatVersion info #
  ###################################################
  if shyaml --quiet get-type AWSTemplateFormatVersion > /dev/null < "$FILE"; then
    # Found it
    return 0
  fi

  ###############################
  # check if file has resources #
  ###############################
  if jq -e 'has("Resources")' > /dev/null 2>&1 < "$FILE"; then
    # Check if AWS Alexa or custom
    if jq ".Resources[].Type" 2>/dev/null | grep -q -E "(AWS|Alexa|Custom)" < "$FILE"; then
      # Found it
      return 0
    fi
  fi

  ################################
  # See if it contains resources #
  ################################
  if shyaml values-0 Resources | grep -q -E "Type: (AWS|Alexa|Custom)" < "$FILE"; then
    # Found it
    return 0
  fi

  ##########################################
  # No identifiers of a CFN template found #
  ##########################################
  return 1
}

################################################################################
#### Function GetGitHubVars ####################################################
GetGitHubVars()
{
  ##########
  # Prints #
  ##########
  echo "--------------------------------------------"
  echo "Gathering GitHub information..."

  ###############################
  # Get the Run test cases flag #
  ###############################
  if [ -z "$TEST_CASE_RUN" ]; then
    ##################################
    # No flag passed, set to default #
    ##################################
    TEST_CASE_RUN="$DEFAULT_TEST_CASE_RUN"
  fi

  ###############################
  # Convert string to lowercase #
  ###############################
  TEST_CASE_RUN=$(echo "$TEST_CASE_RUN" | awk '{print tolower($0)}')

  ##########################
  # Get the run local flag #
  ##########################
  if [ -z "$RUN_LOCAL" ]; then
    ##################################
    # No flag passed, set to default #
    ##################################
    RUN_LOCAL="$DEFAULT_RUN_LOCAL"
  fi

  ###############################
  # Convert string to lowercase #
  ###############################
  RUN_LOCAL=$(echo "$RUN_LOCAL" | awk '{print tolower($0)}')

  #################################
  # Check if were running locally #
  #################################
  if [[ "$RUN_LOCAL" != "false" ]]; then
    ##########################################
    # We are running locally for a debug run #
    ##########################################
    echo "NOTE: ENV VAR [RUN_LOCAL] has been set to:[true]"
    echo "bypassing GitHub Actions variables..."

    ############################
    # Set the GITHUB_WORKSPACE #
    ############################
    if [ -z "$GITHUB_WORKSPACE" ]; then
      GITHUB_WORKSPACE="$DEFAULT_WORKSPACE"
    fi

    echo "Linting all files in mapped directory:[$DEFAULT_WORKSPACE]"

    # No need to touch or set the GITHUB_SHA
    # No need to touch or set the GITHUB_EVENT_PATH
    # No need to touch or set the GITHUB_ORG
    # No need to touch or set the GITHUB_REPO


    #################################
    # Set the VALIDATE_ALL_CODEBASE #
    #################################
    VALIDATE_ALL_CODEBASE="$DEFAULT_VALIDATE_ALL_CODEBASE"
  else
    ############################
    # Validate we have a value #
    ############################
    if [ -z "$GITHUB_SHA" ]; then
      echo "ERROR! Failed to get [GITHUB_SHA]!"
      echo "ERROR:[$GITHUB_SHA]"
      exit 1
    else
      echo "Successfully found:[GITHUB_SHA], value:[$GITHUB_SHA]"
    fi

    ############################
    # Validate we have a value #
    ############################
    if [ -z "$GITHUB_WORKSPACE" ]; then
      echo "ERROR! Failed to get [GITHUB_WORKSPACE]!"
      echo "ERROR:[$GITHUB_WORKSPACE]"
      exit 1
    else
      echo "Successfully found:[GITHUB_WORKSPACE], value:[$GITHUB_WORKSPACE]"
    fi

    ############################
    # Validate we have a value #
    ############################
    if [ -z "$GITHUB_EVENT_PATH" ]; then
      echo "ERROR! Failed to get [GITHUB_EVENT_PATH]!"
      echo "ERROR:[$GITHUB_EVENT_PATH]"
      exit 1
    else
      echo "Successfully found:[GITHUB_EVENT_PATH], value:[$GITHUB_EVENT_PATH]"
    fi

    ##################################################
    # Need to pull the GitHub Vars from the env file #
    ##################################################

    ######################
    # Get the GitHub Org #
    ######################
    # shellcheck disable=SC2002
    GITHUB_ORG=$(cat "$GITHUB_EVENT_PATH" | jq -r '.repository.owner.login' )

    ############################
    # Validate we have a value #
    ############################
    if [ -z "$GITHUB_ORG" ]; then
      echo "ERROR! Failed to get [GITHUB_ORG]!"
      echo "ERROR:[$GITHUB_ORG]"
      exit 1
    else
      echo "Successfully found:[GITHUB_ORG], value:[$GITHUB_ORG]"
    fi

    #######################
    # Get the GitHub Repo #
    #######################
    # shellcheck disable=SC2002
    GITHUB_REPO=$(cat "$GITHUB_EVENT_PATH"| jq -r '.repository.name' )

    ############################
    # Validate we have a value #
    ############################
    if [ -z "$GITHUB_REPO" ]; then
      echo "ERROR! Failed to get [GITHUB_REPO]!"
      echo "ERROR:[$GITHUB_REPO]"
      exit 1
    else
      echo "Successfully found:[GITHUB_REPO], value:[$GITHUB_REPO]"
    fi
  fi
}
################################################################################
#### Function Footer ###########################################################
Footer()
{
  echo ""
  echo "----------------------------------------------"
  echo "----------------------------------------------"
  echo "The script has completed"
  echo "----------------------------------------------"
  echo "----------------------------------------------"
  echo ""

  ##############################
  # Prints for errors if found #
  ##############################
  for LANGUAGE in "${LANGUAGE_ARRAY[@]}"
  do
    ###########################
    # Build the error counter #
    ###########################
    ERROR_COUNTER="ERRORS_FOUND_$LANGUAGE"

    ##################
    # Print if not 0 #
    ##################
    if [ "${!ERROR_COUNTER}" -ne 0 ]; then
      # Print the goods
      echo "ERRORS FOUND in $LANGUAGE:[${!ERROR_COUNTER}]"
    fi
  done

  ##################################
  # Exit with 0 if errors disabled #
  ##################################
  if [ "$DISABLE_ERRORS" == "true" ]; then
    echo "WARN! Exiting with exit code:[0] as:[DISABLE_ERRORS] was set to:[$DISABLE_ERRORS]"
    exit 0
  ###############################
  # Exit with 1 if errors found #
  ###############################
  elif [ "$ERRORS_FOUND_YML" -ne 0 ] || \
     [ "$ERRORS_FOUND_JSON" -ne 0 ] || \
     [ "$ERRORS_FOUND_XML" -ne 0 ] || \
     [ "$ERRORS_FOUND_MARKDOWN" -ne 0 ] || \
     [ "$ERRORS_FOUND_BASH" -ne 0 ] || \
     [ "$ERRORS_FOUND_PERL" -ne 0 ] || \
     [ "$ERRORS_FOUND_PHP" -ne 0 ] || \
     [ "$ERRORS_FOUND_PYTHON" -ne 0 ] || \
     [ "$ERRORS_FOUND_COFFEESCRIPT" -ne 0 ] || \
     [ "$ERRORS_FOUND_ANSIBLE" -ne 0 ] || \
     [ "$ERRORS_FOUND_JAVASCRIPT_ES" -ne 0 ] || \
     [ "$ERRORS_FOUND_JAVASCRIPT_STANDARD" -ne 0 ] || \
     [ "$ERRORS_FOUND_TYPESCRIPT_ES" -ne 0 ] || \
     [ "$ERRORS_FOUND_TYPESCRIPT_STANDARD" -ne 0 ] || \
     [ "$ERRORS_FOUND_DOCKER" -ne 0 ] || \
     [ "$ERRORS_FOUND_GO" -ne 0 ] || \
     [ "$ERRORS_FOUND_TERRAFORM" -ne 0 ] || \
     [ "$ERRORS_FOUND_POWERSHELL" -ne 0 ] || \
     [ "$ERRORS_FOUND_RUBY" -ne 0 ] || \
     [ "$ERRORS_FOUND_CSS" -ne 0 ] || \
     [ "$ERRORS_FOUND_CFN" -ne 0 ] || \
     [ "$ERRORS_FOUND_ENV" -ne 0 ] || \
     [ "$ERRORS_FOUND_OPENAPI" -ne 0 ] || \
     [ "$ERRORS_FOUND_PROTOBUF" -ne 0 ] || \
     [ "$ERRORS_FOUND_CLOJURE" -ne 0 ] || \
     [ "$ERRORS_FOUND_KOTLIN" -ne 0 ]; then
    # Failed exit
    echo "Exiting with errors found!"
    exit 1
  else
    #################
    # Footer prints #
    #################
    echo ""
    echo "All file(s) linted successfully with no errors detected"
    echo "----------------------------------------------"
    echo ""
    # Successful exit
    exit 0
  fi
}
################################################################################
############################### MAIN ###########################################
################################################################################

##########
# Header #
##########
Header

#######################
# Get GitHub Env Vars #
#######################
# Need to pull in all the GitHub variables
# needed to connect back and update checks
GetGitHubVars

#########################################
# Get the languages we need to validate #
#########################################
GetValidationInfo

########################
# Get the linter rules #
########################
# Get YML rules
GetLinterRules "$YAML_FILE_NAME" "$YAML_LINTER_RULES"
# Get Markdown rules
GetLinterRules "$MD_FILE_NAME" "$MD_LINTER_RULES"
# Get Python rules
GetLinterRules "$PYTHON_FILE_NAME" "$PYTHON_LINTER_RULES"
# Get Ruby rules
GetLinterRules "$RUBY_FILE_NAME" "$RUBY_LINTER_RULES"
# Get Coffeescript rules
GetLinterRules "$COFFEE_FILE_NAME" "$COFFEESCRIPT_LINTER_RULES"
# Get Ansible rules
GetLinterRules "$ANSIBLE_FILE_NAME" "$ANSIBLE_LINTER_RULES"
# Get JavaScript rules
GetLinterRules "$JAVASCRIPT_FILE_NAME" "$JAVASCRIPT_LINTER_RULES"
# Get TypeScript rules
GetLinterRules "$TYPESCRIPT_FILE_NAME" "$TYPESCRIPT_LINTER_RULES"
# Get Golang rules
GetLinterRules "$GO_FILE_NAME" "$GO_LINTER_RULES"
# Get Docker rules
GetLinterRules "$DOCKER_FILE_NAME" "$DOCKER_LINTER_RULES"
# Get Terraform rules
GetLinterRules "$TERRAFORM_FILE_NAME" "$TERRAFORM_LINTER_RULES"
# Get PowerShell rules
GetLinterRules "$POWERSHELL_FILE_NAME" "$POWERSHELL_LINTER_RULES"
# Get CSS rules
GetLinterRules "$CSS_FILE_NAME" "$CSS_LINTER_RULES"
# Get CFN rules
GetLinterRules "$CFN_FILE_NAME" "$CFN_LINTER_RULES"

#################################
# Check if were in verbose mode #
#################################
if [[ "$ACTIONS_RUNNER_DEBUG" == "true" ]]; then
  ##################################
  # Get and print all version info #
  ##################################
  GetLinterVersions
fi

###########################################
# Check to see if this is a test case run #
###########################################
if [[ "$TEST_CASE_RUN" != "false" ]]; then
  ###########################
  # Run only the test cases #
  ###########################
  # Code will exit from inside this loop
  RunTestCases
fi

#############################################
# check flag for validation of all codebase #
#############################################
if [ "$VALIDATE_ALL_CODEBASE" == "false" ]; then
  ########################################
  # Get list of files changed if env set #
  ########################################
  BuildFileList
fi

###############
# YML LINTING #
###############
if [ "$VALIDATE_YAML" == "true" ]; then
  ######################
  # Lint the Yml Files #
  ######################
  # LintCodebase "FILE_TYPE" "LINTER_NAME" "LINTER_CMD" "FILE_TYPES_REGEX" "FILE_ARRAY"
  LintCodebase "YML" "yamllint" "yamllint -c $YAML_LINTER_RULES" ".*\.\(yml\|yaml\)\$" "${FILE_ARRAY_YML[@]}"
fi

################
# JSON LINTING #
################
if [ "$VALIDATE_JSON" == "true" ]; then
  #######################
  # Lint the json files #
  #######################
  # LintCodebase "FILE_TYPE" "LINTER_NAME" "LINTER_CMD" "FILE_TYPES_REGEX" "FILE_ARRAY"
  LintCodebase "JSON" "jsonlint" "jsonlint" ".*\.\(json\)\$" "${FILE_ARRAY_JSON[@]}"
fi

###############
# XML LINTING #
###############
if [ "$VALIDATE_XML" == "true" ]; then
  ######################
  # Lint the XML Files #
  ######################
  # LintCodebase "FILE_TYPE" "LINTER_NAME" "LINTER_CMD" "FILE_TYPES_REGEX" "FILE_ARRAY"
  LintCodebase "XML" "xmllint" "xmllint" ".*\.\(xml\)\$" "${FILE_ARRAY_XML[@]}"
fi

####################
# MARKDOWN LINTING #
####################
if [ "$VALIDATE_MD" == "true" ]; then
  ###########################
  # Lint the Markdown Files #
  ###########################
  # LintCodebase "FILE_TYPE" "LINTER_NAME" "LINTER_CMD" "FILE_TYPES_REGEX" "FILE_ARRAY"
  LintCodebase "MARKDOWN" "markdownlint" "markdownlint -c $MD_LINTER_RULES" ".*\.\(md\)\$" "${FILE_ARRAY_MD[@]}"
fi

################
# BASH LINTING #
################
if [ "$VALIDATE_BASH" == "true" ]; then
  #######################
  # Lint the bash files #
  #######################
  # LintCodebase "FILE_TYPE" "LINTER_NAME" "LINTER_CMD" "FILE_TYPES_REGEX" "FILE_ARRAY"
  LintCodebase "BASH" "shellcheck" "shellcheck" ".*\.\(sh\)\$" "${FILE_ARRAY_BASH[@]}"
fi

##################
# PYTHON LINTING #
##################
if [ "$VALIDATE_PYTHON" == "true" ]; then
  #########################
  # Lint the python files #
  #########################
  # LintCodebase "FILE_TYPE" "LINTER_NAME" "LINTER_CMD" "FILE_TYPES_REGEX" "FILE_ARRAY"
  LintCodebase "PYTHON" "pylint" "pylint --rcfile $PYTHON_LINTER_RULES" ".*\.\(py\)\$" "${FILE_ARRAY_PYTHON[@]}"
fi

###############
# CFN LINTING #
###############
if [ "$VALIDATE_CLOUDFORMATION" == "true" ]; then
  #################################
  # Lint the CloudFormation files #
  #################################
  # LintCodebase "FILE_TYPE" "LINTER_NAME" "LINTER_CMD" "FILE_TYPES_REGEX" "FILE_ARRAY"
  LintCodebase "CFN" "cfn-lint" "cfn-lint --config-file $CFN_LINTER_RULES" ".*\.\(json\|yml\|yaml\)\$" "${FILE_ARRAY_CFN[@]}"
fi

################
# PERL LINTING #
################
if [ "$VALIDATE_PERL" == "true" ]; then
  #######################
  # Lint the perl files #
  #######################
  # LintCodebase "FILE_TYPE" "LINTER_NAME" "LINTER_CMD" "FILE_TYPES_REGEX" "FILE_ARRAY"
  LintCodebase "PERL" "perl" "perl -Mstrict -cw" ".*\.\(pl\)\$" "${FILE_ARRAY_PERL[@]}"
fi

################
# PHP LINTING #
################
if [ "$VALIDATE_PHP" == "true" ]; then
  #######################
  # Lint the PHP files #
  #######################
  # LintCodebase "FILE_TYPE" "LINTER_NAME" "LINTER_CMD" "FILE_TYPES_REGEX" "FILE_ARRAY"
  LintCodebase "PHP" "php" "php -l" ".*\.\(php\)\$" "${FILE_ARRAY_PHP[@]}"
fi

################
# RUBY LINTING #
################
if [ "$VALIDATE_RUBY" == "true" ]; then
  #######################
  # Lint the ruby files #
  #######################
  # LintCodebase "FILE_TYPE" "LINTER_NAME" "LINTER_CMD" "FILE_TYPES_REGEX" "FILE_ARRAY"
  LintCodebase "RUBY" "rubocop" "rubocop -c $RUBY_LINTER_RULES" ".*\.\(rb\)\$" "${FILE_ARRAY_RUBY[@]}"
fi

########################
# COFFEESCRIPT LINTING #
########################
if [ "$VALIDATE_COFFEE" == "true" ]; then
  #########################
  # Lint the coffee files #
  #########################
  # LintCodebase "FILE_TYPE" "LINTER_NAME" "LINTER_CMD" "FILE_TYPES_REGEX" "FILE_ARRAY"
  LintCodebase "COFFEESCRIPT" "coffeelint" "coffeelint -f $COFFEESCRIPT_LINTER_RULES" ".*\.\(coffee\)\$" "${FILE_ARRAY_COFFEESCRIPT[@]}"
fi

##################
# GOLANG LINTING #
##################
if [ "$VALIDATE_GO" == "true" ]; then
  #########################
  # Lint the golang files #
  #########################
  # LintCodebase "FILE_TYPE" "LINTER_NAME" "LINTER_CMD" "FILE_TYPES_REGEX" "FILE_ARRAY"
  LintCodebase "GO" "golangci-lint" "golangci-lint run -c $GO_LINTER_RULES" ".*\.\(go\)\$" "${FILE_ARRAY_GO[@]}"
fi

#####################
# TERRAFORM LINTING #
#####################
if [ "$VALIDATE_TERRAFORM" == "true" ]; then
  ############################
  # Lint the Terraform files #
  ############################
  # LintCodebase "FILE_TYPE" "LINTER_NAME" "LINTER_CMD" "FILE_TYPES_REGEX" "FILE_ARRAY"
  LintCodebase "TERRAFORM" "tflint" "tflint -c $TERRAFORM_LINTER_RULES" ".*\.\(tf\)\$" "${FILE_ARRAY_TERRAFORM[@]}"
fi

###################
# ANSIBLE LINTING #
###################
if [ "$VALIDATE_ANSIBLE" == "true" ]; then
  ##########################
  # Lint the Ansible files #
  ##########################
  # Due to the nature of how we want to validate Ansible, we cannot use the
  # standard loop, since it looks for an ansible folder, excludes certain
  # files, and looks for additional changes, it should be an outlier
  LintAnsibleFiles
fi

######################
# JAVASCRIPT LINTING #
######################
if [ "$VALIDATE_JAVASCRIPT_ES" == "true" ]; then
  #############################
  # Lint the Javascript files #
  #############################
  # LintCodebase "FILE_TYPE" "LINTER_NAME" "LINTER_CMD" "FILE_TYPES_REGEX" "FILE_ARRAY"
  LintCodebase "JAVASCRIPT_ES" "eslint" "eslint --no-eslintrc -c $JAVASCRIPT_LINTER_RULES" ".*\.\(js\)\$" "${FILE_ARRAY_JAVASCRIPT_ES[@]}"
fi

######################
# JAVASCRIPT LINTING #
######################
if [ "$VALIDATE_JAVASCRIPT_STANDARD" == "true" ]; then
  #################################
  # Get Javascript standard rules #
  #################################
  GetStandardRules "javascript"
  #############################
  # Lint the Javascript files #
  #############################
  # LintCodebase "FILE_TYPE" "LINTER_NAME" "LINTER_CMD" "FILE_TYPES_REGEX" "FILE_ARRAY"
  LintCodebase "JAVASCRIPT_STANDARD" "standard" "standard $JAVASCRIPT_STANDARD_LINTER_RULES" ".*\.\(js\)\$" "${FILE_ARRAY_JAVASCRIPT_STANDARD[@]}"
fi

######################
# TYPESCRIPT LINTING #
######################
if [ "$VALIDATE_TYPESCRIPT_ES" == "true" ]; then
  #############################
  # Lint the Typescript files #
  #############################
  LintCodebase "TYPESCRIPT_ES" "eslint" "eslint --no-eslintrc -c $TYPESCRIPT_LINTER_RULES" ".*\.\(ts\)\$" "${FILE_ARRAY_TYPESCRIPT_ES[@]}"
fi

######################
# TYPESCRIPT LINTING #
######################
if [ "$VALIDATE_TYPESCRIPT_STANDARD" == "true" ]; then
  #################################
  # Get Typescript standard rules #
  #################################
  GetStandardRules "typescript"
  #############################
  # Lint the Typescript files #
  #############################
  LintCodebase "TYPESCRIPT_STANDARD" "standard" "standard --parser @typescript-eslint/parser --plugin @typescript-eslint/eslint-plugin $TYPESCRIPT_STANDARD_LINTER_RULES" ".*\.\(ts\)\$" "${FILE_ARRAY_TYPESCRIPT_STANDARD[@]}"
fi

###############
# CSS LINTING #
###############
if [ "$VALIDATE_CSS" == "true" ]; then
  #################################
  # Get CSS standard rules #
  #################################
  GetStandardRules "stylelint"
  #############################
  # Lint the CSS files #
  #############################
  LintCodebase "CSS" "stylelint" "stylelint --config $CSS_LINTER_RULES" ".*\.\(css\)\$" "${FILE_ARRAY_CSS[@]}"
fi

###############
# ENV LINTING #
###############
if [ "$VALIDATE_ENV" == "true" ]; then
  #######################
  # Lint the env files #
  #######################
  # LintCodebase "FILE_TYPE" "LINTER_NAME" "LINTER_CMD" "FILE_TYPES_REGEX" "FILE_ARRAY"
  LintCodebase "ENV" "dotenv-linter" "dotenv-linter" ".*\.\(env\).*\$" "${FILE_ARRAY_ENV[@]}"
fi

##################
# KOTLIN LINTING #
##################
if [ "$VALIDATE_KOTLIN" == "true" ]; then
  #######################
  # Lint the Kotlin files #
  #######################
  # LintCodebase "FILE_TYPE" "LINTER_NAME" "LINTER_CMD" "FILE_TYPES_REGEX" "FILE_ARRAY"
  LintCodebase "KOTLIN" "ktlint" "ktlint" ".*\.\(kt\|kts\)\$" "${FILE_ARRAY_KOTLIN[@]}"
fi

##################
# DOCKER LINTING #
##################
if [ "$VALIDATE_DOCKER" == "true" ]; then
  #########################
  # Lint the docker files #
  #########################
  # LintCodebase "FILE_TYPE" "LINTER_NAME" "LINTER_CMD" "FILE_TYPES_REGEX" "FILE_ARRAY"
  LintCodebase "DOCKER" "/dockerfilelint/bin/dockerfilelint" "/dockerfilelint/bin/dockerfilelint -c $DOCKER_LINTER_RULES" ".*\(Dockerfile\)\$" "${FILE_ARRAY_DOCKER[@]}"
fi

###################
# CLOJURE LINTING #
###################
if [ "$VALIDATE_CLOJURE" == "true" ]; then
  #################################
  # Get Clojure standard rules #
  #################################
  GetStandardRules "clj-kondo"
  #########################
  # Lint the Clojure files #
  #########################
  LintCodebase "CLOJURE" "clj-kondo" "clj-kondo --config $CLOJURE_LINTER_RULES --lint" ".*\.\(clj\|cljs\|cljc\|edn\)\$" "${FILE_ARRAY_CLOJURE[@]}"
fi

##################
# PROTOBUF LINTING #
##################
if [ "$VALIDATE_PROTOBUF" == "true" ]; then
  #######################
  # Lint the Protocol Buffers files #
  #######################
  # LintCodebase "FILE_TYPE" "LINTER_NAME" "LINTER_CMD" "FILE_TYPES_REGEX" "FILE_ARRAY"
  LintCodebase "PROTOBUF" "protolint" "protolint lint --config_path $PROTOBUF_LINTER_RULES" ".*\.\(proto\)\$" "${FILE_ARRAY_PROTOBUF[@]}"
fi

######################
# POWERSHELL LINTING #
######################
if [ "$VALIDATE_POWERSHELL" == "true" ]; then
  #############################
  # Lint the powershell files #
  #############################
  # LintCodebase "FILE_TYPE" "LINTER_NAME" "LINTER_CMD" "FILE_TYPES_REGEX" "FILE_ARRAY"
  LintCodebase "POWERSHELL" "pwsh" "pwsh -c Invoke-ScriptAnalyzer -EnableExit -Settings $POWERSHELL_LINTER_RULES -Path" ".*\.\(ps1\|psm1\|psd1\|ps1xml\|pssc\|psrc\|cdxml\)\$" "${FILE_ARRAY_POWERSHELL[@]}"
fi

###################
# OPENAPI LINTING #
###################
if [ "$VALIDATE_OPENAPI" == "true" ]; then
  # If we are validating all codebase we need to build file list because not every yml/json file is an OpenAPI file
  if [ "$VALIDATE_ALL_CODEBASE" == "true" ]; then
    ###############################################################################
    # Set the file seperator to newline to allow for grabbing objects with spaces #
    ###############################################################################
    IFS=$'\n'

    # shellcheck disable=SC2207
    LIST_FILES=($(cd "$GITHUB_WORKSPACE" || exit; find . -type f -regex ".*\.\(yml\|yaml\|json\)\$" 2>&1))
    for FILE in "${LIST_FILES[@]}"
    do
      if DetectOpenAPIFile "$FILE"; then
        FILE_ARRAY_OPENAPI+=("$FILE")
      fi
    done

    ###########################
    # Set IFS back to default #
    ###########################
    IFS="$DEFAULT_IFS"
  fi

  ##########################
  # Lint the OpenAPI files #
  ##########################
  # LintCodebase "FILE_TYPE" "LINTER_NAME" "LINTER_CMD" "FILE_TYPES_REGEX" "FILE_ARRAY"
  LintCodebase "OPENAPI" "spectral" "spectral lint -r $OPENAPI_LINTER_RULES" "disabledfileext" "${FILE_ARRAY_OPENAPI[@]}"
fi

##########
# Footer #
##########
Footer
