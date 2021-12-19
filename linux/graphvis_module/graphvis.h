/* graphvis.h */

#ifndef GODOT_GRAPHVIS_H
#define GODOT_GRAPHVIS_H

#include "core/reference.h"
#include "graph_access.h"
#include <vector>

class GRAPHVIS : public Reference {
    GDCLASS(GRAPHVIS, Reference);

    graph_access G;

    Coord window_x;
    Coord window_y;

    std::vector<std::vector<Coord>> node_positions_random;
    Array godot_array_node_positions_random;
    std::vector<std::vector<Coord>> node_positions_fruchterman_reingold;


protected:
    static void _bind_methods();

public:

    // **************************** UI **********************************
    Coord ui_get_window_x();
    void ui_set_window_x(Coord _x);
    Coord ui_get_window_y();
    void ui_set_window_y(Coord _y);

    // ******************************************************************

    // **************************** IO **********************************
    void graph_read_file(String filename);

    // ******************************************************************

    // ********************* Graph statistics ***************************
    NodeID graph_number_of_nodes();
    EdgeID graph_number_of_edges();
    PartitionID graph_get_partition_count(); 
    void graph_set_partition_count(PartitionID count); 
    PartitionID graph_getSeparatorBlock();
    void graph_setSeparatorBlock(PartitionID id);

    // ******************************************************************

    // ********************* Graph access *******************************
    //graph access
    EdgeID graph_get_first_edge(NodeID node);
    EdgeID graph_get_first_invalid_edge(NodeID node);

    NodeWeight graph_getNodeWeight(NodeID node);
    void graph_setNodeWeight(NodeID node, NodeWeight weight);

    EdgeWeight graph_getNodeDegree(NodeID node);
    EdgeWeight graph_getWeightedNodeDegree(NodeID node);
    EdgeWeight graph_getMaxDegree();
    
    EdgeWeight graph_getEdgeWeight(EdgeID edge);
    void graph_setEdgeWeight(EdgeID edge, EdgeWeight weight);

    NodeID graph_getEdgeTarget(EdgeID edge);

    EdgeRatingType graph_getEdgeRating(EdgeID edge);
    void graph_setEdgeRating(EdgeID edge, EdgeRatingType rating);

    // access the contraction offset of a node
    NodeWeight graph_get_contraction_offset(NodeID node) const;
    void graph_set_contraction_offset(NodeID node, NodeWeight offset);

    PartitionID graph_getPartitionIndex(NodeID node);
    void graph_setPartitionIndex(NodeID node, PartitionID id);

    PartitionID graph_getSecondPartitionIndex(NodeID node);
    void graph_setSecondPartitionIndex(NodeID node, PartitionID id);

    //to be called if combine in meta heuristic is used
    void graph_resizeSecondPartitionIndex(unsigned no_nodes);

    // ******************************************************************

    // ************************* Drawing ********************************
    void graph_setCoords(NodeID node, Coord x, Coord y); 
    Coord graph_getX(NodeID node); 
    Coord graph_getY(NodeID node); 
    void init_pos_random();
    void draw_pos_random(Coord _window_x, Coord _window_y);

    // ******************************************************************

    // ************************* Position storage ***********************
    Array graph_get_current_coords();

    // ******************************************************************

    // ************************* Transform ******************************
    Array array_node_positions_random();
    void array_set_node_positions_random(Array _node_positions_random);
    Array array_get_node_positions_random();
    // ******************************************************************

    // ***************************** Tools ******************************
    //Numeric random(Numeric from, Numeric to);
    Coord random(Coord from, Coord to);


    // ******************************************************************

    //constructor
    GRAPHVIS();
    
};

#endif // GODOT_GRAPHVIS_H