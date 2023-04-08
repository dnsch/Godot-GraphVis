# Godot-GraphVis
Graph visualization tool made with godot  
using [KaHIP](https://github.com/KaHIP/KaHIP) for internal graph structure  
running on linux

Website: https://pille.iwr.uni-heidelberg.de/~graphvis01/

# Download
You can download the project by using:
```
git clone https://github.com/dnsch/Godot-GraphVis
```
# Installation
In order to run the main program, unzip the [linux.zip](linux.zip) and compile the [modified KaHIP](module/graphvis/kahip_source_modified/) following the instructions in [INSTALL](module/graphvis/kahip_source_modified/INSTALL) and [README](module/graphvis/kahip_source_modified/README.md). You might need to make the ```compile_withcmake.sh``` executable via:
```
chmod +x compile_withcmake.sh
```
assuming you are in the [modified KaHIP](module/graphvis/kahip_source_modified/) directory.  
After the compilation you can find a ```libkahip.so``` file in the newly created directory ```kahip_source_modified/deploy/```.  
Copy this file into the unzipped directory ```linux/lib```.  
After that, you can run the Godot-GraphVis program in the ```linux``` directory via:
```
./launcher_script
```
# Usage
In order to read in a graph, you have to create a folder with at least an adjacacency list file in the [Metis](https://doi.org/10.1137/S1064827595287997) file format (see p.8 in [kahip.pdf](module/graphvis/kahip_source_modified/manual/kahip.pdf)) with the extension ```.graph``` and a coordinate file with the extension .coord, storing the ```x``` and ```y``` coordinates for each node in the associated row. You can calculate the coordinates using a force-directed graph drawing algorithm, such as [Fruchterman–Reingold](https://doi.org/10.1002/spe.4380211102). For the examples found in [linux.zip](linux.zip), [KaDraw](https://github.com/schulzchristian/KaDraw) was used to calculate the coordinates in the respective ```.coord``` files.  
Additionally, if the graph contains a partition file with the extension .prt, which stores the partition id for each node in the associated row, or if it contains a vertex set file with the extension ```.vs```, which stores a ```1``` if the node is in the vertex set and ```0``` if it is not for each node in the associated row, these can also be displayed. For the examples found in [linux.zip](linux.zip), [KaHIP](https://github.com/KaHIP/KaHIP) and [VieClus](https://github.com/VieClus/VieClus) were used to calculate graph partition and graph clustering files (which both can be read in as a ```.prt``` file) and a random walk algorithm to solve the [Minimum Feedback Vertex Set](https://en.wikipedia.org/wiki/Feedback_vertex_set) problem to an optimum was used to calculate the vertex set files.  
The graph folder then can be read in using the ```File``` button on the top left of the gui.  
After that, the graph is displayed in white and an additional ```Options``` button appears next to the ```File``` button. Using the ```Options``` button, the appearance of the graph can be changed. This includes coloring edges and nodes by partitions, clusters, and vertex sets, changing the size of edges and nodes, changing the size of nodes based on their degree and coloring the edges based on their length.  
Clicking the ```Camera``` icon next to the ```Options``` button creates a .png that is stored in the directory of the executable.
# Godot-Plugin
If you want to use the ```GraphVis``` module in Godot, place the [GraphVis](module/graphvis) module in the [modules directory](https://github.com/godotengine/godot/tree/3.4.4-stable/modules) which is located in the root of the [Godot source](https://github.com/godotengine/godot/tree/3.4.4-stable) and follow the instructions for compiling ([Compiling for X11](https://docs.godotengine.org/en/3.0/development/compiling/compiling_for_x11.html), [Custom modules in C++](https://docs.godotengine.org/en/3.0/development/cpp/custom_modules_in_cpp.html?highlight=custom%20modules#custom-modules-in-c)). In addition, you have to copy the ```libkahip.a``` from ```kahip_source_modified/deploy/``` (after compiling it) to usr/lib via:
```
cp libkahip.a usr/lib
```
assuming you are in the ```kahip_source_modified/deploy``` directory. 
This allows you then to call the modified kahip source and additional functions found in [graphis.cpp](module/graphvis/graphvis.cpp) as a class within the Godot editor by using the constructor ```GRAPHVIS.new()```. For further information on using custom modules have a look at [Custom modules in C++](https://docs.godotengine.org/en/3.0/development/cpp/custom_modules_in_cpp.html?highlight=custom%20modules#custom-modules-in-c). You need to edit the [SCsub](module/graphvis/SCsub) if you want to include more functions from [modified KaHIP](module/graphvis/kahip_source_modified).  
Alternatively, you can edit the [existing Godot source code](godot_project/GraphVis/)  for this project.
