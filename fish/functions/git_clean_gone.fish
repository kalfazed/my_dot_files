function git_clean_gone --description "Delete local branches that have been deleted on remote"
    # 1. Fetch from remote and prune deleted branches
    #    'git fetch -p' updates local knowledge of remote branches and removes references that no longer exist on remote.
    echo "🔄 Fetching and pruning remote..."
    git fetch -p

    # 2. Find branches marked as '[gone]'
    #    'git branch -vv': Lists branches with upstream info.
    #    'grep': Filters for branches that track a missing remote branch.
    #    'awk': Extracts just the branch name (first column).
    set -l gone_branches (git branch -vv | grep ': gone]' | awk '{print $1}')

    # 3. Check if there are any branches to delete
    if test (count $gone_branches) -eq 0
        set_color green
        echo "✅ Local branches are clean. No 'gone' branches found."
        set_color normal
        return 0
    end

    # 4. List the branches to be deleted
    echo ""
    set_color yellow
    echo "⚠️  The following local branches have been deleted on remote:"
    set_color normal
    
    for branch in $gone_branches
        echo "  - $branch"
    end
    echo ""

    # 5. Ask for confirmation
    read -l -P "❓ Do you want to delete these branches? [y/N] " confirm

    if test "$confirm" = "y"; or test "$confirm" = "Y"
        for branch in $gone_branches
            # We use -D (force delete) because sometimes Git doesn't realize
            # a branch is fully merged if 'Squash and Merge' was used.
            git branch -D $branch
        end
        
        echo ""
        set_color green
        echo "🎉 Cleanup complete!"
        set_color normal
    else
        echo "Operation cancelled."
    end
end
