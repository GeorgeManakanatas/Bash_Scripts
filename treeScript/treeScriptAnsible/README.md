# Project Title

Uses Ansible to create Readme markdown file with file structure embedded.
The subsections that will be included are defined as items in the main playbook.
The files are created in the provided root directory and every folder contained
in it.

## File structure
```
.
├── ReadMeCreation.yaml
├── README.md
├── templates
│   ├── acknowledgements.j2
│   ├── authors.j2
│   ├── banner.j2
│   ├── builtWith.j2
│   ├── contributing.j2
│   ├── deployment.j2
│   ├── folderTree.j2
│   ├── gettingStarted.j2
│   ├── license.j2
│   ├── projectTitle.j2
│   ├── runningTests.j2
│   └── versioning.j2
└── treeScriptAnsible.sh

1 directory, 15 files
```

## Prerequisites

Ansible and tree are obviously required and can be installed with the following
commands
```
sudo yum install tree
sudo yum install ansible
```
or
```
sudo apt-get install tree
sudo apt-get install ansible
```

## Authors

* **George Manakanatas** - [GeorgeManakanatas](https://github.com/GeorgeManakanatas)

## Acknowledgments

* **Billie Thompson** - *Initial work on the great readme template used as the basis for this.* - [PurpleBooth](https://github.com/PurpleBooth)
