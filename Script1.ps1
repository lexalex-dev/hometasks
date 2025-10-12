#Клонируем репозиторий
   $url="git@github.com:lexalex-dev/hometasks.git"
   git clone $url myrepo_clone

#Переходим в директорию, в которую клонировали репозиторий
   Set-Location myrepo_clone

# Получаем информацию о последнем теге и коммитах
   $desc = git describe --tags

# Определяем есть ли коммиты после тега
   $parts = $desc -split '-'
   if ($parts.Count -eq 1) 
   {    # Нет коммитов после тега
    $tagName = $parts[0]
    Write-Host "Tag: $tagName"
    Write-Host "No changes"} 
   else 
   {    # Есть коммиты после тега
    $tagName = $parts[0]
    $commitCount = $parts[1]
    Write-Host "Found $commitCount new commits after tag $tagName" }

# Увеличиваем патч-версию
    $versionParts = $tagName -split '\.'
    
    if ($versionParts.Count -ne 3) {
    Write-Error "Тег не соответствует формату (major.minor.patch)"
    exit 1    }

    $newPatch = [int]$versionParts[2] + 1
    $newTag = "$($versionParts[0]).$($versionParts[1]).$newPatch"
 
# Создаем новый аннотированный тег
    git tag -a $newTag -m "New release"
    
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Ошибка при создании тега"
        exit 1    }

# Отправляем тег в удаленный репозиторий
    git push origin $newTag

    if ($LASTEXITCODE -ne 0) {
        Write-Error "Ошибка при отправке тега"
        exit 1    }

    Write-Host "Создан новый тег: $newTag"

# Удаляем локальную копию репозитория
    $repoRoot = (git rev-parse --show-toplevel)
    Write-Host "Удаление репозитория в $repoRoot"
    Remove-Item -Recurse -Force $repoRoot
