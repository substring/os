#!/bin/bash

# configures network on host system according to installer settings
# if some variables are not set, we handle that transparantly
# however, at least $DHCP must be set, so we know what do to
# we assume that you checked whether networking has been setup before calling us
target_configure_network()
{
	# networking setup could have happened in a separate process (eg partial-configure-network),
	# so check if the settings file was created to be sure
	if [ -f $RUNTIME_DIR/aif-network-settings ]; then

        debug NETWORK "Configuring network settings on target system according to installer settings"

        source $RUNTIME_DIR/aif-network-settings 2>/dev/null || return 1

        IFO=${INTERFACE_PREV:-eth0} # old iface: a previously entered one, or the arch default
        IFN=${INTERFACE:-eth0} # new iface: a specified one, or the arch default

        # comment out any existing uncommented entries, whether specified by us, or arch defaults.
        for var in eth0 $IFO INTERFACES gateway ROUTES
        do
            sed -i "s/^$var=/#$var=/" ${var_TARGET_DIR}/etc/rc.conf || return 1
        done
        sed -i "s/^nameserver/#nameserver/" ${var_TARGET_DIR}/etc/resolv.conf || return 1
        if [ -f ${var_TARGET_DIR}/etc/profile.d/proxy.sh ]
        then
            sed -i "s/^export/#export/" ${var_TARGET_DIR}/etc/profile.d/proxy.sh || return 1
        fi

        if [ "$DHCP" = 0 ] ; then
            local line="$IFN=\"$IFN ${IPADDR:-192.168.0.2} netmask ${SUBNET:-255.255.255.0} broadcast ${BROADCAST:-192.168.0.255}\""
            append_after_last "/$IFO\|eth0/" "$line" ${var_TARGET_DIR}/etc/rc.conf || return 1

            if [ -n "$GW" ]; then
                append_after_last "/gateway/" "gateway=\"default gw $GW\"" ${var_TARGET_DIR}/etc/rc.conf || return 1
                append_after_last "/ROUTES/" "ROUTES=(gateway)" ${var_TARGET_DIR}/etc/rc.conf || return 1
            fi
            if [ -n "$DNS" ]
            then
                echo "nameserver $DNS" >> ${var_TARGET_DIR}/etc/resolv.conf || return 1
            fi
        else
            append_after_last "/$IFO\|eth0/" "$IFN=\"dhcp\"" ${var_TARGET_DIR}/etc/rc.conf || return 1
        fi

        append_after_last "/$IFO\|eth0/" "INTERFACES=($IFN)" ${var_TARGET_DIR}/etc/rc.conf || return 1

        if [ -n "$PROXY_HTTP" ]; then
            echo "export http_proxy=$PROXY_HTTP" >> ${var_TARGET_DIR}/etc/profile.d/proxy.sh || return 1
            chmod a+x ${var_TARGET_DIR}/etc/profile.d/proxy.sh || return 1
        fi

        if [ -n "$PROXY_FTP" ]; then
            echo "export ftp_proxy=$PROXY_FTP" >> ${var_TARGET_DIR}/etc/profile.d/proxy.sh || return 1
            chmod a+x ${var_TARGET_DIR}/etc/profile.d/proxy.sh || return 1
        fi
    else
        debug NETWORK "Skipping Host Network Configuration - aif-network-settings not found"
    fi
    return 0
}
