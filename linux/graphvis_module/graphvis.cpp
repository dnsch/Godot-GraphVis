/* graphvis.cpp */

#include "graphvis.h"
//#include "mpi.h"

#include "balance_configuration.h"
//#include "graph_access.h"
#include "normal_matrix.h"
#include "online_distance_matrix.h"
#include "graph_io.h"
#include "macros_assertions.h"
#include "mapping_algorithms.h"
#include "mmap_graph_io.h"
#include "parse_parameters.h"
#include "graph_partitioner.h"
#include "partition_config.h"
#include "cycle_refinement.h"
#include "quality_metrics.h"
#include "random_functions.h"
#include "timer.h"
#include "strongly_connected_components.h"
#include "graph_extractor.h"
#include "cycle_search.h"
#include <kaHIP_interface.h>

#include <iostream>
#include <random>
//#include <Godot.hpp>



// **************************** UI **********************************
Coord GRAPHVIS::ui_get_window_x() {
    return window_x;
}

void GRAPHVIS::ui_set_window_x(Coord _x) {
    window_x = _x;
}

Coord GRAPHVIS::ui_get_window_y() {
    return window_y;
}

void GRAPHVIS::ui_set_window_y(Coord _y) {
    window_y = _y;
}

// ******************************************************************

// **************************** IO **********************************
void GRAPHVIS::graph_read_file(String filename) {
    std::string temp = filename.utf8().get_data();
    kahip::mmap_io::graph_from_metis_file(G, temp);
}

// ******************************************************************


// ********************* Graph statistics ***************************
NodeID GRAPHVIS::graph_number_of_nodes() {
    return G.number_of_nodes();
}

EdgeID GRAPHVIS::graph_number_of_edges() {
    return G.number_of_edges();
}

PartitionID GRAPHVIS::graph_get_partition_count() {
    return G.get_partition_count();
}

void GRAPHVIS::graph_set_partition_count(PartitionID count) {
    G.set_partition_count(count);
}

PartitionID GRAPHVIS::graph_getSeparatorBlock() {
    return G.getSeparatorBlock();
}

void GRAPHVIS::graph_setSeparatorBlock(PartitionID id) {
    G.setSeparatorBlock(id);
}

// ******************************************************************

// ********************* Graph access *******************************
EdgeID GRAPHVIS::graph_get_first_edge(NodeID node) {
    return G.get_first_edge(node);
}

EdgeID GRAPHVIS::graph_get_first_invalid_edge(NodeID node) {
    return G.get_first_invalid_edge(node);
}

NodeWeight GRAPHVIS::graph_getNodeWeight(NodeID node) {
    return G.getNodeWeight(node);
}

void GRAPHVIS::graph_setNodeWeight(NodeID node, NodeWeight weight) {
    G.setNodeWeight(node, weight);
}

EdgeWeight GRAPHVIS::graph_getNodeDegree(NodeID node) {
    return G.getNodeDegree(node);
}

EdgeWeight GRAPHVIS::graph_getWeightedNodeDegree(NodeID node) {
    return G.getWeightedNodeDegree(node);
}

EdgeWeight GRAPHVIS::graph_getMaxDegree() {
    return G.getMaxDegree();
}

EdgeWeight GRAPHVIS::graph_getEdgeWeight(EdgeID edge){
    return G.getEdgeWeight(edge);
}
void GRAPHVIS::graph_setEdgeWeight(EdgeID edge, EdgeWeight weight) {
    G.setEdgeWeight(edge, weight);
}

NodeID GRAPHVIS::graph_getEdgeTarget(EdgeID edge) {
    return G.getEdgeTarget(edge);
}

EdgeRatingType GRAPHVIS::graph_getEdgeRating(EdgeID edge) {
    return G.getEdgeRating(edge);
}

void GRAPHVIS::graph_setEdgeRating(EdgeID edge, EdgeRatingType rating) {
    G.setEdgeRating(edge, rating);
}

// access the contraction offset of a node
NodeWeight GRAPHVIS::graph_get_contraction_offset(NodeID node) const {
    return G.get_contraction_offset(node);
}
void GRAPHVIS::graph_set_contraction_offset(NodeID node, NodeWeight offset) {
    G.set_contraction_offset(node, offset);
}

PartitionID GRAPHVIS::graph_getPartitionIndex(NodeID node) {
    return G.getPartitionIndex(node);
}
void GRAPHVIS::graph_setPartitionIndex(NodeID node, PartitionID id) {
    G.setPartitionIndex(node, id);
}

PartitionID GRAPHVIS::graph_getSecondPartitionIndex(NodeID node) {
    return G.getSecondPartitionIndex(node);
}
void GRAPHVIS::graph_setSecondPartitionIndex(NodeID node, PartitionID id) {
    G.setSecondPartitionIndex(node, id);
}

//to be called if combine in meta heuristic is used
void GRAPHVIS::graph_resizeSecondPartitionIndex(unsigned no_nodes) {
    G.resizeSecondPartitionIndex(no_nodes);
}

// ******************************************************************

// ************************* Drawing ********************************
void GRAPHVIS::graph_setCoords(NodeID node, Coord x, Coord y) {
    G.setCoords(node, x, y);
}

Coord GRAPHVIS::graph_getX(NodeID node) {
    return G.getX(node);
}

Coord GRAPHVIS::graph_getY(NodeID node) {
    return G.getY(node);
}

void GRAPHVIS::init_pos_random() {
    random_functions rf;
    forall_nodes(G, node)
    {
        G.setCoords(node,random(0, window_x),random(0, window_y));
    } endfor
}

void GRAPHVIS::draw_pos_random(Coord _window_x, Coord _window_y) {
    random_functions rf;
    forall_nodes(G, node) 
    {
        G.setCoords(node,random(0, _window_x),random(0, _window_y));
    } endfor
}

// ******************************************************************

// ************************* Position storage ***********************
Array GRAPHVIS::graph_get_current_coords() {
    Array godot_array;
    forall_nodes(G, node) 
    {
        Array godot_temp_array;
        godot_temp_array.push_back(G.getX(node));
        godot_temp_array.push_back(G.getY(node));
        godot_array.push_back(godot_temp_array);
    } endfor
    return godot_array;
}

// ******************************************************************

// ************************* Transform ******************************

Array GRAPHVIS::array_node_positions_random() {
    Array godot_array;
    for (int entry = 0; entry < node_positions_random.size(); entry ++) 
    {
        Array godot_temp_array;
        godot_temp_array.push_back(node_positions_random[entry][0]);
        godot_temp_array.push_back(node_positions_random[entry][1]);
        godot_array.push_back(godot_temp_array);
    }
    return godot_array;
}

void GRAPHVIS::array_set_node_positions_random(Array _node_positions_random) {
    godot_array_node_positions_random = _node_positions_random;
}

Array GRAPHVIS::array_get_node_positions_random() {
    return godot_array_node_positions_random;
}

// ******************************************************************


// ***************************** Tools ******************************

//rng taken from Galik's answer:
//https://stackoverflow.com/questions/2704521/generate-random-double-numbers-in-c

/*
template<typename Numeric, typename Generator = std::mt19937>
Numeric random(Numeric from, Numeric to)
{
    thread_local static Generator gen(std::random_device{}());

    using dist_type = typename std::conditional
    <
        std::is_integral<Numeric>::value
        , std::uniform_int_distribution<Numeric>
        , std::uniform_real_distribution<Numeric>
    >::type;

    thread_local static dist_type dist;

    return dist(gen, typename dist_type::param_type{from, to});
}*/

Coord GRAPHVIS::random(Coord from, Coord to)
{
    thread_local static std::mt19937 gen(std::random_device{}());

    using dist_type = typename std::conditional
    <
        std::is_integral<Coord>::value
        , std::uniform_int_distribution<Coord>
        , std::uniform_real_distribution<Coord>
    >::type;

    thread_local static dist_type dist;

    return dist(gen, typename dist_type::param_type{from, to});
}

// ******************************************************************

// ********************* Godot binding *******************************
void GRAPHVIS::_bind_methods() {
    // **************************** UI **********************************
    ClassDB::bind_method(D_METHOD("ui_get_window_x"), &GRAPHVIS::ui_get_window_x);
    ClassDB::bind_method(D_METHOD("ui_set_window_x"), &GRAPHVIS::ui_set_window_x);
    ClassDB::bind_method(D_METHOD("ui_get_window_y"), &GRAPHVIS::ui_get_window_y);
    ClassDB::bind_method(D_METHOD("ui_set_window_y"), &GRAPHVIS::ui_set_window_y);
    // **************************** IO **********************************
    ClassDB::bind_method(D_METHOD("graph_read_file"), &GRAPHVIS::graph_read_file);
    // ********************* Graph statistics ***************************
    ClassDB::bind_method(D_METHOD("graph_number_of_nodes"), &GRAPHVIS::graph_number_of_nodes);
    ClassDB::bind_method(D_METHOD("graph_number_of_edges"), &GRAPHVIS::graph_number_of_edges);
    ClassDB::bind_method(D_METHOD("graph_get_partition_count"), &GRAPHVIS::graph_get_partition_count);
    ClassDB::bind_method(D_METHOD("graph_set_partition_count"), &GRAPHVIS::graph_set_partition_count);
    ClassDB::bind_method(D_METHOD("graph_getSeparatorBlock"), &GRAPHVIS::graph_getSeparatorBlock);
    ClassDB::bind_method(D_METHOD("graph_setSeparatorBlock"), &GRAPHVIS::graph_setSeparatorBlock);
    // ********************* Graph access *******************************
    ClassDB::bind_method(D_METHOD("graph_get_first_edge"), &GRAPHVIS::graph_get_first_edge);
    ClassDB::bind_method(D_METHOD("graph_get_first_invalid_edge"), &GRAPHVIS::graph_get_first_invalid_edge);
    ClassDB::bind_method(D_METHOD("graph_getNodeWeight"), &GRAPHVIS::graph_getNodeWeight);
    ClassDB::bind_method(D_METHOD("graph_setNodeWeight"), &GRAPHVIS::graph_setNodeWeight);
    ClassDB::bind_method(D_METHOD("graph_getNodeDegree"), &GRAPHVIS::graph_getNodeDegree);
    ClassDB::bind_method(D_METHOD("graph_getWeightedNodeDegree"), &GRAPHVIS::graph_getWeightedNodeDegree);
    ClassDB::bind_method(D_METHOD("graph_getMaxDegree"), &GRAPHVIS::graph_getMaxDegree);
    ClassDB::bind_method(D_METHOD("graph_getEdgeWeight"), &GRAPHVIS::graph_getEdgeWeight);
    ClassDB::bind_method(D_METHOD("graph_setEdgeWeight"), &GRAPHVIS::graph_setEdgeWeight);
    ClassDB::bind_method(D_METHOD("graph_getEdgeTarget"), &GRAPHVIS::graph_getEdgeTarget);
    ClassDB::bind_method(D_METHOD("graph_getEdgeRating"), &GRAPHVIS::graph_getEdgeRating);
    ClassDB::bind_method(D_METHOD("graph_setEdgeRating"), &GRAPHVIS::graph_setEdgeRating);
    ClassDB::bind_method(D_METHOD("graph_get_contraction_offset"), &GRAPHVIS::graph_get_contraction_offset);
    ClassDB::bind_method(D_METHOD("graph_set_contraction_offset"), &GRAPHVIS::graph_set_contraction_offset);
    ClassDB::bind_method(D_METHOD("graph_getPartitionIndex"), &GRAPHVIS::graph_getPartitionIndex);
    ClassDB::bind_method(D_METHOD("graph_setPartitionIndex"), &GRAPHVIS::graph_setPartitionIndex);
    ClassDB::bind_method(D_METHOD("graph_getSecondPartitionIndex"), &GRAPHVIS::graph_getSecondPartitionIndex);
    ClassDB::bind_method(D_METHOD("graph_setSecondPartitionIndex"), &GRAPHVIS::graph_setSecondPartitionIndex);
    ClassDB::bind_method(D_METHOD("graph_resizeSecondPartitionIndex"), &GRAPHVIS::graph_resizeSecondPartitionIndex);
    // ************************* Drawing ********************************
    ClassDB::bind_method(D_METHOD("graph_setCoords"), &GRAPHVIS::graph_setCoords);
    ClassDB::bind_method(D_METHOD("graph_getX"), &GRAPHVIS::graph_getX);
    ClassDB::bind_method(D_METHOD("graph_getY"), &GRAPHVIS::graph_getY);
    ClassDB::bind_method(D_METHOD("init_pos_random"), &GRAPHVIS::init_pos_random);
    ClassDB::bind_method(D_METHOD("draw_pos_random"), &GRAPHVIS::draw_pos_random);
    // ************************* Position storage ***********************
    ClassDB::bind_method(D_METHOD("graph_get_current_coords"), &GRAPHVIS::graph_get_current_coords);
    // ************************* Transform ******************************
    ClassDB::bind_method(D_METHOD("array_node_positions_random"), &GRAPHVIS::array_node_positions_random);
    ClassDB::bind_method(D_METHOD("array_set_node_positions_random"), &GRAPHVIS::array_set_node_positions_random);
    ClassDB::bind_method(D_METHOD("array_get_node_positions_random"), &GRAPHVIS::array_get_node_positions_random);
    // ***************************** Tools ******************************
    ClassDB::bind_method(D_METHOD("random"), &GRAPHVIS::random);
}


// ********************* Constructor ********************************
GRAPHVIS::GRAPHVIS() {


}

// ******************************************************************