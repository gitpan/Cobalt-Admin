# hints/cobalt.sh
. hints/linux.sh

# Cobalt installs perl in /usr/bin and we need to respect that
# Allow a command line override, e.g. Configure -Dprefix=/foo/bar
case "$prefix" in
 '') prefix='/usr' ;;
esac

# Need this to get the vendor supplied Cobalt::* modules
inc_version_list='5.005/i386-linux 5.005'
inc_version_list_init='"5.005/i386-linux","5.005",0'
