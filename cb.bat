for /f %%B in ('git rev-parse --abbrev-ref HEAD') do (set current_branch=%%B)
for /f %%C in ('git rev-parse HEAD') do (set current_commit=%%C)
for /f %%M in ('git merge-base %current_branch% master') do (set master_commit=%%M)
for /f %%D in ('git merge-base %current_branch% develop') do (set develop_commit=%%D)
for /f %%O in ('git merge-base %master_commit% %develop_commit%') do (set oldest_commit=%%O)
:: parent branch is develop -> create branch from master
if %oldest_commit%==%master_commit% (
git checkout master
git pull
git checkout -b %current_branch%_master
git cherry-pick %develop_commit%..%current_commit%
) else (
:: parent branch is master -> create branch from develop
git checkout develop
git pull
git checkout -b %current_branch%_dev
git cherry-pick %master_commit%..%current_commit%
)
ar
git push