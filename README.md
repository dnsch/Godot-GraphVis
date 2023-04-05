# Godot-GraphVis
Graph Visualization Tool Made With Godot  
using [KaHIP](https://github.com/KaHIP/KaHIP) for internal graph structure  
running on linux

# Download
You can download the project by using:
```
git clone https://github.com/dnsch/Godot-GraphVis
```
# Installation
In order to run the main program, unzip the [linux.zip](linux.zip) and compile the [modified KaHIP](module/graphvis/kahip_source_modified/) following the instructions in [INSTALL](module/graphvis/kahip_source_modified/INSTALL) and [README](module/graphvis/kahip_source_modified/README.md). After the compilation you can find a ```libkahip.so``` file in the newly created directory ```kahip_source_modified/deploy/```.  
Copy this file into the unzipped directory ```linux/lib```.  
After that, you can run the program in the ```linux``` directory via:
```
./launcher_script
```
# Usage
