function unpack_downloaded_data --description "Recursively unzip files from source to target directory"
    # --- 内部 Usage 函数 ---
    function __unpack_usage
        set_color yellow; echo "Usage:"; set_color normal
        echo "  unpack_downloaded_data <source_dir> <target_dir>"
    end

    # --- 1. 参数检查 ---
    if test (count $argv) -eq 0; or contains -- -h $argv; or contains -- --help $argv
        __unpack_usage
        return 0
    end

    if test (count $argv) -lt 2
        set_color red; echo "Error: 参数不足。"; set_color normal
        __unpack_usage
        return 1
    end

    set -l source_root $argv[1]
    set -l target_root $argv[2]

    # --- 2. 目录检查 ---
    if not test -d $source_root
        set_color red; echo "Error: 源目录 '$source_root' 不存在。"; set_color normal
        return 1
    end

    if not test -d $target_root
        mkdir -p $target_root
    end

    set -l count 0
    set -l zip_files $source_root/**/*.zip

    if test (count $zip_files) -eq 0
        set_color red; echo "Warning: 未找到 zip 文件。"; set_color normal
        return 0
    end

    # --- 3. 核心循环 (关键修改部分) ---
    for zip_file in $zip_files
        set -l folder_name (path basename $zip_file .zip)
        set -l output_path "$target_root/$folder_name"

        echo -n "正在解压: "
        set_color cyan; echo -n $folder_name; set_color normal
        echo " -> $output_path"

        # 执行解压 (安静模式 + 覆盖模式)
        unzip -q -o "$zip_file" -d "$output_path"
        
        # --- [关键点] 获取并检查退出状态 ---
        set -l cmd_status $status

        # 状态码 130 代表被 SIGINT 信号中断 (即 Ctrl + C)
        if test $cmd_status -eq 130
            echo ""
            set_color red
            echo "🛑 检测到中断信号 (Ctrl + C)。正在停止任务..."
            set_color normal
            return 130 # 退出整个函数
        end
        # --------------------------------

        if test $cmd_status -eq 0
            set count (math $count + 1)
        else
            set_color red
            echo "解压失败: $zip_file (错误码: $cmd_status)"
            set_color normal
        end
    end

    echo "------------------------------------------------"
    set_color green
    echo "全部完成！共解压了 $count 个文件。"
    set_color normal
end
