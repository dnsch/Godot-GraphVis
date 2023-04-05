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
    std::vector<double> edge_lengths;
    std::vector<double> edge_lengths_sorted;
    std::vector<size_t> edge_lengths_indices_sorted;
    std::vector<float> edge_lengths_pct;

    //edge lengths statistics

    std::vector<double> quartiles;
    std::vector<double> quartiles_indices;
    //array containing nr of quartile array for each edge length
    std::vector<double> edge_lengths_quartile_nr;
    std::vector<double> edge_lengths_quartile_pct;

    double edge_length_min;
    double edge_length_max;
    double one_quartile = 0;    //25 percentile
    double two_quartile = 0;    //50 percentile (median)
    double three_quartile = 0;  //75 percentile

    //arrays containing edge lengths by quartiles
    std::vector<double> edge_lengths_q0q1;
    std::vector<double> edge_lengths_q1q2;
    std::vector<double> edge_lengths_q2q3;
    std::vector<double> edge_lengths_q3q4;

protected:
    static void _bind_methods();

public:

    // *************************** Init *********************************

    void graph_init_edge_length_array();
    void Quantile(Array probs);
    void graph_init_edge_length_quartile_arrays(Array probs);

    // ******************************************************************

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
    //taken from KaDraw:
    Array graph_get_edge_length_array();
    double graph_get_edge_length(EdgeID edge);
    float graph_get_edge_length_pct(EdgeID edge);
    double graph_get_min_edge_length();
    double graph_get_max_edge_length();

    Array graph_get_quartiles_array();
    Array graph_get_quartiles_indices_array();
    int graph_get_edge_quartile_nr(EdgeID edge);
    double graph_get_edge_lengths_quartile_pct(EdgeID edge);

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

    PartitionID graph_getVertexSetIndex(NodeID node);
    void graph_setVertexSetIndex(NodeID node, VertexSetID id);

    PartitionID graph_getSecondPartitionIndex(NodeID node);
    void graph_setSecondPartitionIndex(NodeID node, PartitionID id);

    //to be called if combine in meta heuristic is used
    void graph_resizeSecondPartitionIndex(unsigned no_nodes);

    //fill graph with partition info
    void graph_read_partition(String filename);

    //fill graph with vertex set info
    void graph_read_vertex_set(String filename);

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
    Coord euclidian_distance_2D(NodeID& from_node, NodeID& to_node);
    std::vector<Coord> unit_vector_approx(NodeID& from_node, NodeID& to_node);

    // ******************************************************************

    // ************************ Algorithms ******************************
    void fruchterman_reingold(Coord length_opt, Coord epsilon, int K, float delta);
    std::vector<Coord> fr_force_repulsive(NodeID& node, Coord& length_opt);
    std::vector<Coord> fr_force_attractive(NodeID& node, Coord& length_opt);
    void fruchterman_reingold_original(Coord _window_x, Coord _window_y, int iterations, Coord k, bool capped);

    // ******************************************************************

    // ************************** KaDraw ********************************
    void graph_set_kadraw_coords(String filename, double scale);

    // ******************************************************************


    //constructor
    GRAPHVIS();
    
};

#endif // GODOT_GRAPHVIS_H