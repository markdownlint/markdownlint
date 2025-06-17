# Procédure d’installation de `mdl` (markdownlint) sur macOS Sequoia (Intel)

Ce guide explique comment installer la version Ruby de `mdl` (markdownlint) sur un Mac équipé d’un processeur Intel, en utilisant un environnement propre et moderne avec `rbenv`.

## Prérequis

- Disposer d’un terminal
- Avoir les droits d’administration sur la machine

## Étapes détaillées

### 1. Installer Homebrew

Si Homebrew n’est pas déjà installé, exécute la commande suivante :

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 2. Installer rbenv et ruby-build

Installe `rbenv` (gestionnaire de versions Ruby) et `ruby-build` :

```sh
brew install rbenv ruby-build
```

### 3. Initialiser rbenv

Ajoute l’initialisation de `rbenv` à ta configuration shell :

```sh
rbenv init
```

Suis les instructions affichées. Généralement, il suffit d’ajouter la ligne suivante à la fin de ton fichier `~/.zshrc` :

```sh
eval "$(rbenv init - --no-rehash zsh)"
```

Recharge la configuration :

```sh
source ~/.zshrc
```

### 4. Installer une version récente de Ruby

Installe la dernière version stable de Ruby (par exemple : 3.4.4) :

```sh
rbenv install 3.4.4
rbenv global 3.4.4
```

Vérifie la version active :

```sh
ruby -v
```

### 5. Mettre à jour RubyGems

Il est conseillé de mettre à jour RubyGems :

```sh
gem update --system
```

### 6. Installer `mdl`

Installe le gem `mdl` :

```sh
gem install mdl
```

### 7. Vérifier l’installation

Teste la commande :

```sh
mdl --version
```

Tu dois voir la version de `mdl` installée s’afficher.

## Conseils

- Pour utiliser `mdl` dans tous tes projets, il n’est pas nécessaire de modifier manuellement le `PATH` : `rbenv` s’en charge.
- Pour mettre à jour Ruby ou `mdl` plus tard, répète simplement les commandes d’installation avec les nouvelles versions.

## Références

- [Documentation officielle de markdownlint (mdl)](https://github.com/markdownlint/markdownlint)
- [Documentation rbenv](https://github.com/rbenv/rbenv)
- [Homebrew](https://brew.sh/)

---

Fichier ajouté à la racine de mon fork, sous le nom `INSTALLATION-macOS-Sequoia-Intel.md`.

[1] [https://github.com/markdownmint](https://github.com/markdown/markdownlint)
