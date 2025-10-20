#!/usr/bin/env fish

function disk_check
    if test -f /.dockerenv
        echo "⚠️  Running inside Docker container. Limited disk info available."
        echo ""
        df -h /
        return
    end

    echo "===== Local Disk Usage ====="
    printf "%-30s %-6s %-6s %-6s %-5s\n" "Mount Point" "Size" "Used" "Avail" "Use%"
    for dev in (lsblk -ln -o NAME,TYPE | grep 'disk' | awk '{print $1}')
        for part in (lsblk -ln -o NAME,MOUNTPOINT /dev/$dev | grep -v "^$dev " | awk '{print $2}')
            if test -n "$part"
                df -h $part | awk 'NR==2 {printf "%-30s %-6s %-6s %-6s %-5s\n",$6,$2,$3,$4,$5}'
            end
        end
    end

    echo ""
    echo "===== Disk Usage mounted on /mnt/ ====="
    printf "%-30s %-6s %-6s %-6s %-5s\n" "Mount Point" "Size" "Used" "Avail" "Use%"
    for mp in (mount | awk '{print $3}' | grep '^/mnt/')
        df -h $mp | awk 'NR==2 {printf "%-30s %-6s %-6s %-6s %-5s\n",$6,$2,$3,$4,$5}'
    end
end

