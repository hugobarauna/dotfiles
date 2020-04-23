##
# Reloads bash configs
#
function reload () {
  source ~/.bash_profile
}


##
# Shows erlang version
#
function erlang_version () {
  erl -eval '{ok, Version} = file:read_file(filename:join([code:root_dir(), "releases", erlang:system_info(otp_release), "OTP_VERSION"])), io:fwrite(Version), halt().' -noshell
}

##
# Search for a string inside a bundled gem
#
function bag () {
  gem_path=`bundle show $2`
  ag "$1" "$gem_path/$3"
}

##
# Delete remote branches merged in master
#
function rmb () {
  current_branch=$(git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')

  if [ "$current_branch" != "master" ]; then
    echo "WARNING: You are on branch $current_branch, NOT master."
  fi

  echo "Fetching merged branches..."

  git remote prune origin

  remote_branches=$(git branch -r --merged | grep -v '/master$' | grep -v "/$current_branch$")
  local_branches=$(git branch --merged | grep -v 'master$' | grep -v "$current_branch$")

  if [ -z "$remote_branches" ] && [ -z "$local_branches" ]; then
    echo "No existing branches have been merged into $current_branch."
  else
    echo "This will remove the following branches:"

    if [ -n "$remote_branches" ]; then
      echo "$remote_branches"
    fi

    if [ -n "$local_branches" ]; then
      echo "$local_branches"
    fi

    read -p "Continue? (y/n): " -n 1 choice
    echo
    if [ "$choice" == "y" ] || [ "$choice" == "Y" ]; then
      # Remove remote branches
      git push origin `git branch -r --merged | grep -v '/master$' | grep -v "/$current_branch$" | sed 's/origin\//:/g' | tr -d '\n'`
      # Remove local branches
      git branch -d `git branch --merged | grep -v 'master$' | grep -v "$current_branch$" | sed 's/origin\///g' | tr -d '\n'`
    else
      echo "No branches removed."
    fi
  fi
}

##
# Transform a .mov into a nice .gif
#
# How to use:
#
#   gifify screencap.mov
#   gifify screencap.mov --good
#
# Credits: https://gist.github.com/SlexAxton/4989674
#
gifify() {
  if [[ -n "$1" ]]; then
    if [[ $2 == '--good' ]]; then
      ffmpeg -i $1 -r 10 -vcodec png out-static-%05d.png
      time convert -verbose +dither -layers Optimize -resize 600x600\> out-static*.png  GIF:- | gifsicle --colors 128 --delay=5 --loop --optimize=3 --multifile - > $1.gif
      rm out-static*.png
    else
      ffmpeg -i $1 -s 600x400 -pix_fmt rgb24 -r 10 -f gif - | gifsicle --optimize=3 --delay=3 > $1.gif
    fi
  else
    echo "proper usage: gifify <input_movie.mov>. You DO need to include extension."
  fi
}

