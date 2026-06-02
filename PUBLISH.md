# 🚀 Инструкция по публикации проекта на GitHub

Пошаговое руководство для загрузки CNC Programming проекта на GitHub.

## 📋 Что вам понадобится

- ✅ Аккаунт на GitHub ([создать](https://github.com/signup))
- ✅ Git установлен на компьютере ([скачать](https://git-scm.com/))
- ✅ Этот проект на вашем компьютере

## 🔐 Шаг 1: Настройка Git (если еще не сделано)

Откройте PowerShell и выполните:

```powershell
# Настройте ваше имя
git config --global user.name "iiivendettaiii"

# Настройте email
git config --global user.email "ramazanargon@gmail.com"

# Проверьте настройки
git config --global --list
```

## 🌐 Шаг 2: Создайте репозиторий на GitHub

1. Перейдите на [GitHub](https://github.com/)
2. Войдите в аккаунт
3. Нажмите `+` (вверху справа) → `New repository`
4. Заполните форму:
   - **Repository name:** `CNC-Programming`
   - **Description:** `Комплексный образовательный курс по CNC программированию на русском языке`
   - **Public или Private:**
     - ✅ **Public** - рекомендуется для образовательных проектов
     - 🔒 **Private** - можно дать доступ конкретным людям
   - **НЕ выбирайте** "Initialize with README" (у нас уже есть)
5. Нажмите `Create repository`

## 💻 Шаг 3: Инициализация и загрузка проекта

### Вариант A: Через PowerShell (рекомендуется)

```powershell
# Перейдите в папку проекта
cd "C:\Users\ramaz\Desktop\CNC-Programming\CNC-Programming"

# Инициализируйте Git (если еще не сделано)
git init

# Добавьте все файлы
git add .

# Создайте первый commit
git commit -m "Initial commit: Complete CNC Programming educational project"

# Добавьте удаленный репозиторий (замените USERNAME на ваш GitHub username)
git remote add origin https://github.com/iiivendettaiii/CNC-Programming.git

# Переименуйте ветку в main (если нужно)
git branch -M main

# Загрузите на GitHub
git push -u origin main
```

### Вариант B: Через GitHub Desktop (проще для новичков)

1. Скачайте [GitHub Desktop](https://desktop.github.com/)
2. Войдите в аккаунт GitHub
3. File → Add Local Repository
4. Выберите папку `C:\Users\ramaz\Desktop\CNC-Programming\CNC-Programming`
5. Напишите commit message: "Initial commit"
6. Нажмите "Publish repository"
7. Выберите Public/Private
8. Нажмите "Publish"

## 🔑 Шаг 4: Аутентификация (если потребуется)

Если Git запросит логин/пароль:

### Метод 1: Personal Access Token (рекомендуется)

1. GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Generate new token → Classic
3. Выберите права: `repo` (все галочки)
4. Срок действия: 90 days или No expiration
5. Generate token
6. **СКОПИРУЙТЕ токен** (он показывается только один раз!)
7. При запросе пароля в Git введите этот токен

### Метод 2: GitHub CLI (уже настроен у вас)

```powershell
# Используйте готовый скрипт
powershell -ExecutionPolicy Bypass -File ".\GITHUB\github-login-and-check.ps1" -UserName "iiivendettaiii" -UserEmail "ramazanargon@gmail.com"
```

## 📸 Шаг 5: Добавьте изображения (опционально)

Чтобы сделать README красивее:

1. Создайте скриншоты:
   - SSCNC Simulator с вашим кодом
   - Примеры обработанных деталей
   - Схемы и диаграммы

2. Сохраните в папку `images/`

3. Добавьте в README:
```markdown
![SSCNC Simulator](images/sscnc-example.png)
```

4. Загрузите на GitHub:
```powershell
git add images/
git commit -m "Добавлены скриншоты и примеры"
git push
```

## 🎯 Шаг 6: Настройка репозитория на GitHub

После загрузки перейдите на GitHub в ваш репозиторий:

### Settings → General
- ✅ **Description:** Добавьте описание проекта
- ✅ **Website:** Добавьте ссылку (если есть)
- ✅ **Topics:** Добавьте теги: `cnc`, `gcode`, `russian`, `education`, `haas`, `mastercam`, `cnc-programming`

### Settings → Features
- ✅ Включите **Issues** (для обратной связи)
- ✅ Включите **Discussions** (для вопросов)
- ✅ Включите **Projects** (опционально)

### Repository → About (справа)
Нажмите ⚙️ и добавьте:
- Description
- Website (если есть)
- Topics (теги)

## 🔒 Управление доступом (для Private репозитория)

Если выбрали Private, но хотите дать доступ учителю:

1. Settings → Collaborators and teams
2. Add people
3. Введите email или username учителя
4. Выберите роль: **Write** (может редактировать) или **Read** (только просмотр)
5. Отправьте приглашение

## 📤 Обновление проекта в будущем

Когда добавляете новые материалы:

```powershell
# Перейдите в папку проекта
cd "C:\Users\ramaz\Desktop\CNC-Programming\CNC-Programming"

# Добавьте измененные файлы
git add .

# Создайте commit с описанием
git commit -m "Добавлен новый урок по подпрограммам"

# Загрузите на GitHub
git push
```

## 🆘 Решение проблем

### Проблема: "fatal: not a git repository"
```powershell
git init
git remote add origin https://github.com/iiivendettaiii/CNC-Programming.git
```

### Проблема: "failed to push"
```powershell
# Сначала получите изменения с GitHub
git pull origin main --rebase

# Потом загрузите свои
git push origin main
```

### Проблема: "Username/Password required"
- Используйте Personal Access Token вместо пароля
- Или настройте GitHub CLI: `gh auth login`

### Проблема: Кириллица в именах файлов
```powershell
# Настройте Git для корректной работы с кириллицей
git config --global core.quotepath false
```

## ✅ Проверка успешной загрузки

После выполнения всех шагов:

1. Перейдите на `https://github.com/iiivendettaiii/CNC-Programming`
2. Вы должны увидеть:
   - ✅ README.md с красивым оформлением
   - ✅ Все папки и файлы проекта
   - ✅ Описание репозитория
   - ✅ Теги (topics)

## 📧 Поделиться с учителем

### Для Public репозитория:
Просто отправьте ссылку:
```
https://github.com/iiivendettaiii/CNC-Programming
```

### Для Private репозитория:
1. Добавьте учителя как Collaborator (см. выше)
2. Отправьте ему ссылку после приглашения

## 📱 QR-код (опционально)

Создайте QR-код для быстрого доступа:
1. Перейдите на [qr-code-generator.com](https://www.qr-code-generator.com/)
2. Вставьте ссылку на репозиторий
3. Скачайте QR-код
4. Добавьте в презентацию или распечатайте

## 🎉 Готово!

Теперь ваш проект доступен на GitHub и другие студенты могут:
- Просматривать материалы
- Скачивать коды
- Задавать вопросы (через Issues)
- Предлагать улучшения (через Pull Requests)

---

**Вопросы?** Смотрите [CONTRIBUTING.md](CONTRIBUTING.md) или создайте Issue.

**Удачи с проектом! 🚀**
