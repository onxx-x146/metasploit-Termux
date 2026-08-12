#!/data/data/com.termux/files/usr/bin/bash

# ===== Current time =====
current_time=$(date +"%H:%M:%S")

# ===== Open GitHub =====
echo -e "\033[38;5;214m[$current_time]\033[0m \033[1;32m[INFO]:\033[0m Opening GitHub in Chrome..."
am start -a android.intent.action.VIEW -d "https://github.com/onxx-x146" com.android.chrome >/dev/null 2>&1 || {
    echo -e "\033[38;5;214m[$current_time]\033[0m \033[1;33m[WARNING]:\033[0m Could not open Chrome."
}
'clear'
# ===== NEW BANNER (Metasploit ASCII) =====
echo -e "\e[1;31m"
cat << "EOF"
    __  __________________   _____ ____  __    ____  __________
   /  |/  / ____/_  __/   | / ___// __ \/ /   / __ \/  _/_  __/
  / /|_/ / __/   / / / /| | \__ \/ /_/ / /   / / / // /  / /
 / /  / / /___  / / / ___ |___/ / ____/ /___/ /_/ // /  / /
/_/  /_/_____/ /_/ /_/  |_/____/_/   /_____/\____/___/ /_/
                                     
                                           BY : ONXX 🦅 
                                           V.1.2
                                           Follow __.l2l__🔥
EOF
echo -e "\e[0m"

# ===== Center function =====
center() {
    termwidth=$(stty size | cut -d" " -f2)
    padding="$(printf '%0.1s' ={1..500})"
    printf '%*.*s %s %*.*s\n' 0 "$(((termwidth-2-${#1})/2))" "$padding" "$1" 0 "$(((termwidth-1-${#1})/2))" "$padding"
}

# ===== Loading spinner =====
source <(echo "c3Bpbm5lcj0oICd8JyAnLycgJy0nICdcJyApOwoKY291bnQoKXsKICBzcGluICYKICBwaWQ9JCEKICBmb3IgaSBpbiBgc2VxIDEgMTBgCiAgZG8KICAgIHNsZWVwIDE7CiAgZG9uZQoKICBraWxsICRwaWQgIAp9CgpzcGluKCl7CiAgd2hpbGUgWyAxIF0KICBkbyAKICAgIGZvciBpIGluICR7c3Bpbm5lcltAXX07IAogICAgZG8gCiAgICAgIGVjaG8gLW5lICJcciRpIjsKICAgICAgc2xlZXAgMC4yOwogICAgZG9uZTsKICBkb25lCn0KCmNvdW50" | base64 -d)

# ===== Dependencies =====
center "* Dependencies installation..."
count &
SPIN_PID=$!

if ! grep -q "packages.termux.dev" /data/data/com.termux/files/usr/etc/apt/sources.list 2>/dev/null; then
    pkg update -y
else
    apt update -y
fi
DEBIAN_FRONTEND=noninteractive pkg upgrade -y -o Dpkg::Options::="--force-confnew"
pkg install -y binutils python autoconf bison clang coreutils curl findutils apr apr-util postgresql openssl readline libffi libgmp libpcap libsqlite libgrpc libtool libxml2 libxslt ncurses make ncurses-utils ncurses git wget unzip zip tar termux-tools termux-elf-cleaner pkg-config git ruby -o Dpkg::Options::="--force-confnew"
python3 -m pip install requests

kill $SPIN_PID 2>/dev/null
wait $SPIN_PID 2>/dev/null
echo -e "\r✅ Dependencies installed."

# ===== Erase old folders =====
center "* Erasing old metasploit folders..."
for old in "metasploit-framework" ".metasploit-framework"; do
    if [ -d "${PREFIX}/opt/$old" ]; then
        rm -rf "${PREFIX}/opt/$old"
    fi
done

# ===== Download into hidden folder =====
center "* Downloading (hidden folder)..."
mkdir -p ${PREFIX}/opt
git clone https://github.com/rapid7/metasploit-framework.git --depth=1 ${PREFIX}/opt/.metasploit-framework

# ===== Install =====
center "* Installation..."
cd ${PREFIX}/opt/.metasploit-framework || { echo "ERROR: Can't enter folder"; exit 1; }
gem install bundler

NOKOGIRI_VERSION=$(grep -i nokogiri Gemfile.lock | sed 's/nokogiri [\(\)]/(/g' | cut -d ' ' -f 5 | grep -oP "(.).[[:digit:]][\w+]?[.].")
gem install nokogiri -v "$NOKOGIRI_VERSION" -- --with-cflags="-Wno-implicit-function-declaration -Wno-deprecated-declarations -Wno-incompatible-function-pointer-types" --use-system-libraries

bundle install
gem install actionpack
bundle update activesupport
bundle update --bundler
bundle install -j$(nproc --all)

# ===== Fix ActionView =====
center "* Fixing ActionView version compatibility..."
sed -i 's/raise unless ActionView::VERSION::STRING == .*$/# Version check disabled for ARM64 compatibility/' config/application.rb

# ===== Link executables =====
ln -sf ${PREFIX}/opt/.metasploit-framework/msfconsole ${PREFIX}/bin/
ln -sf ${PREFIX}/opt/.metasploit-framework/msfvenom ${PREFIX}/bin/
ln -sf ${PREFIX}/opt/.metasploit-framework/msfrpcd ${PREFIX}/bin/
termux-elf-cleaner ${PREFIX}/lib/ruby/gems/*/gems/pg-*/lib/pg_ext.so 2>/dev/null

# ===== SECURE THE REPOSITORY =====
center "* Hiding and protecting the repository..."

chmod -R go-w ${PREFIX}/opt/.metasploit-framework 2>/dev/null
chmod -R 755 ${PREFIX}/opt/.metasploit-framework 2>/dev/null

if command -v chattr &>/dev/null; then
    chattr +i ${PREFIX}/opt/.metasploit-framework 2>/dev/null && \
    echo "  → Immutable flag set (super-protection)" || \
    echo "  → Immutable flag not supported, but permissions are locked."
else
    echo "  → chattr not available, using standard permissions only."
fi

chmod 755 "$0" 2>/dev/null

echo -e "\033[32m"
center "Installation complete"
echo -e "\nMetasploit is now installed in:"
echo "  ${PREFIX}/opt/.metasploit-framework"
echo -e "\n✅ This folder is hidden and write-protected for others."
echo "   Only you (the owner) can modify it."
echo -e "\nStart Metasploit with: msfconsole"
echo -e "\033[0m"
