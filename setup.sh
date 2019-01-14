# Invoked without shebang so that we can query the caller shell
# This script is meant to be shell independent. Aim for POSIX compliance.

# get the current shell 
current_shell=$(readlink /proc/$$/exe | rev | cut -d'/' -f1 | rev)
scripts_base_dir=scripts
scripts_dir=${scripts_base_dir}/${current_shell}

echo_w() {
  echo "Warning: $@"
}

echo_e() {
  echo "Error: $@"
}

# check if we have scripts for the current shell 
if [ ! -d "${scripts_dir}" ]; then
  echo_e "Not a supported shell: ${current_shell}"
  exit 1
fi

# run all the scripts for the shell
line=$(printf '%.0s-' {1..80})
for application in $(ls ${scripts_dir}); do
  application_setup_script=${scripts_dir}/${application}/setup.sh
  if [ ! -x "${application_setup_script}" ]; then
    echo_w "Setup not found for application: ${application}"
    continue
  fi
  echo ${line}
  echo "Running setup for: ${application}"
  ${application_setup_script}
done


