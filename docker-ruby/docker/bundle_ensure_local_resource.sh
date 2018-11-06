echo "Setting-Up RVM environment..."
find /mnt -name Gemfile -execdir sh -c "sed -i '1 i\source \"https://artifactory.qvantel.net/artifactory/all-gems/\"' Gemfile" \;
find /mnt -name Gemfile -execdir sh -c "sed -i '1 i\source \"https://gems.qvantel.net/\"' Gemfile" \;
# declare -a sources=(
#     "https://gems.qvantel.net"
#     "https://artifactory.qvantel.net/artifactory/all-gems/"
# )
# for s in "${sources[@]}"; do
#     find -name Gemfile -execdir sh -c "sed -i '1 i\source \"$s\"' Gemfile" \;
# done

echo "Running bundle install in multiple folders..."
## RUN find -name Gemfile -execdir sh -c "pwd && bundle install" \;
# RUN find -name Gemfile -execdir sh -c "tput setaf 7; pwd && tput sgr0; bundle install" \;
gemfile_paths=$(find /mnt -name Gemfile -execdir sh -c "pwd" \;)
#gemfile_paths_counter= $(printf '%s\n' "${gemfile_paths[@]}" | wc -w)
for p in $gemfile_paths; do
    #echo "BUNDLE $p/$gemfile_paths_counter"
    pwd && cd $p && bundle install
done

find -name Gemfile -execdir sh -c "sed -i '1,2d' Gemfile" \;
# RUN find -name Gemfile -execdir sh -c "sed -i '1,2d' Gemfile" \;