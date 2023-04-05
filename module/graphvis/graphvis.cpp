/* graphvis.cpp */

#include "graphvis.h"

#include "balance_configuration.h"
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

#include "quality_metrics.h"

#include <iostream>
#include <random>
#include <cmath>
#include <vector>
#include <numeric>      // std::iota
#include <algorithm>    // std::sort, std::stable_sort


// *************************** Init *********************************

//taken (mostly) from KaDraw
void GRAPHVIS::graph_init_edge_length_array() {
    edge_lengths.resize(G.number_of_edges());
    forall_nodes(G, node) {
            forall_out_edges(G, e, node) {
                    NodeID target = G.getEdgeTarget(e);
                    edge_lengths[e] = std::hypot(G.getX(target) - G.getX(node), G.getY(target) - G.getY(node));
            } endfor
    } endfor
    edge_length_min = *min_element(edge_lengths.begin(), edge_lengths.end());
    edge_length_max = *max_element(edge_lengths.begin(), edge_lengths.end());
    edge_lengths_pct.resize(G.number_of_edges());
    forall_nodes(G, node) {
            forall_out_edges(G, e, node) {
                    NodeID target = G.getEdgeTarget(e);
                    edge_lengths_pct[e] = (((edge_lengths[e] - edge_length_min) * 100) / (edge_length_max - edge_length_min))/100;
            } endfor
    } endfor

}    



//taken (mostly) from 'Yury' on https://stackoverflow.com/questions/11964552/finding-quartiles
template<typename T>
static inline double Lerp(T v0, T v1, T t) {
    return (1 - t)*v0 + t*v1;
}



template <typename T>
std::vector<size_t> sort_indexes(const std::vector<T> &v) {

  // initialize original index locations
  std::vector<size_t> idx(v.size());
  std::iota(idx.begin(), idx.end(), 0);

  // sort indexes based on comparing values in v
  // using std::stable_sort instead of std::sort
  // to avoid unnecessary index re-orderings
  // when v contains elements of equal values 
  std::stable_sort(idx.begin(), idx.end(),
       [&v](size_t i1, size_t i2) {return v[i1] < v[i2];});

  return idx;
}


void GRAPHVIS::Quantile(Array probs) {

    edge_lengths_sorted = edge_lengths;

    int lo = 0;

    edge_lengths_indices_sorted = sort_indexes(edge_lengths_sorted); 
    std::stable_sort(edge_lengths_sorted.begin(), edge_lengths_sorted.end());

    if (edge_lengths_sorted.empty())
    {
        quartiles = std::vector<double>();
    }

    if (1 == edge_lengths_sorted.size())
    {
        quartiles = std::vector<double>(1, edge_lengths_sorted[0]);
    }

    std::vector<double> data = edge_lengths_sorted;
    std::vector<double> quantiles;
    std::vector<double> quantiles_indices;

    quantiles_indices.push_back(0);
    quantiles.push_back(0);
    for (size_t i = 0; i < probs.size(); ++i)
    {
        double poi = Lerp<double>(-0.5, data.size() - 0.5, probs[i]);

        size_t left = std::max(int64_t(std::floor(poi)), int64_t(0));
        size_t right = std::min(int64_t(std::ceil(poi)), int64_t(data.size() - 1));

        double datLeft = data.at(left);
        double datRight = data.at(right);

        double quantile = Lerp<double>(datLeft, datRight, poi - left);

        quantiles.push_back(quantile);
        quantiles_indices.push_back(right);
    }

    quantiles_indices.push_back(edge_lengths_sorted.size()-1);
    quantiles.push_back(edge_lengths_sorted[edge_lengths_sorted.size()-1]);

    quartiles = quantiles;
    quartiles_indices = quantiles_indices;
}


void GRAPHVIS::graph_init_edge_length_quartile_arrays(Array probs) {

    Quantile(probs);

    edge_lengths_quartile_nr.resize(G.number_of_edges());
    edge_lengths_quartile_pct.resize(G.number_of_edges());

    for (size_t i = 0; i < quartiles_indices.size(); ++i)
    {
        for (size_t j = quartiles_indices[i]; j < quartiles_indices[i+1]; ++j)
        {
            double quartile_edge_length_min = quartiles[i];
            double quartile_edge_length_max = quartiles[i+1];
            double quartile_edge_length_min_max_diff = quartile_edge_length_max - quartile_edge_length_min;
            int current_edge_index = edge_lengths_indices_sorted[j];
            edge_lengths_quartile_nr[current_edge_index] = i;
            edge_lengths_quartile_pct[current_edge_index] = (((edge_lengths[current_edge_index] - quartile_edge_length_min) * 100) / (quartile_edge_length_min_max_diff))/100;
        }
    }

}


// ******************************************************************



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
    graph_io::readGraphWeighted(G, temp);
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

Array GRAPHVIS::graph_get_edge_length_array() {
    Array godot_array;
    forall_nodes(G, node) 
    {
        godot_array.push_back(edge_lengths[node]);
    } endfor
    return godot_array;
}

double GRAPHVIS::graph_get_min_edge_length() {
    return edge_length_min;
}

double GRAPHVIS::graph_get_max_edge_length() {
    return edge_length_max;
}

Array GRAPHVIS::graph_get_quartiles_array() {
    Array quartiles_array;

    for (int i = 0; i < quartiles.size(); ++i)
    {
        quartiles_array.push_back(quartiles[i]);
    }

    return quartiles_array;
}

Array GRAPHVIS::graph_get_quartiles_indices_array() {
    Array quartiles_indices_array;

    for (int i = 0; i < quartiles_indices.size(); ++i)
    {
        quartiles_indices_array.push_back(quartiles_indices[i]);
    }

    return quartiles_indices_array;
}

int GRAPHVIS::graph_get_edge_quartile_nr(EdgeID edge) {

    return edge_lengths_quartile_nr[edge];
}

double GRAPHVIS::graph_get_edge_lengths_quartile_pct(EdgeID edge) {

    return edge_lengths_quartile_pct[edge];
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

PartitionID GRAPHVIS::graph_getVertexSetIndex(NodeID node) {
    return G.getVertexsetIndex(node);
}
void GRAPHVIS::graph_setVertexSetIndex(NodeID node, VertexSetID id) {
    G.setVertexsetIndex(node, id);
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

void GRAPHVIS::graph_read_partition(String filename) {
    std::string temp = filename.utf8().get_data();
    graph_io::readPartition(G, temp);
}

void GRAPHVIS::graph_read_vertex_set(String filename) {
    std::string temp = filename.utf8().get_data();
    graph_io::readVertexSet(G, temp);
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
    ui_set_window_x(_window_x);
    ui_set_window_y(_window_y);
    random_functions rf;
    forall_nodes(G, node) 
    {
        G.setCoords(node,random(0, _window_x),random(0, _window_y));
    } endfor
}

double GRAPHVIS::graph_get_edge_length(EdgeID edge) {
    return edge_lengths[edge];
}

float GRAPHVIS::graph_get_edge_length_pct(EdgeID edge) {
    return edge_lengths_pct[edge];
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

Coord GRAPHVIS::random(Coord from, Coord to) {
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

Coord GRAPHVIS::euclidian_distance_2D(NodeID& from_node, NodeID& to_node) {
    return std::hypot(G.getX(to_node) - G.getX(from_node), G.getY(to_node) - G.getY(from_node));
}

//unit vector function taken from: https://www.h3xed.com/programming/fast-unit-vector-calculation-for-2d-games

std::vector<Coord> GRAPHVIS::unit_vector_approx(NodeID& from_node, NodeID& to_node) {
    Coord x = G.getX(to_node) - G.getX(from_node);
    Coord y = G.getY(to_node) - G.getY(from_node);
    Coord a_x = std::abs(x);
    Coord a_y = std::abs(y);
    Coord ratio = 1 / std::max(a_x, a_y);
    ratio = ratio * (1.29289 - (a_x + a_y) * ratio * 0.29289);
    std::vector<Coord> vec = {x * ratio, y * ratio};
    return vec;
}


// ******************************************************************

// ************************ Algorithms ******************************
//Fruchterman-Reingold
void GRAPHVIS::fruchterman_reingold(Coord length_opt, Coord epsilon, int K, float delta) {
    float multi = 1;
    int t = 0;
    std::vector<std::vector<Coord>> new_positions;
    int max_force = epsilon+1;
    while ((t < K) && (max_force > epsilon))
    {
        forall_nodes(G, node) 
        {
            Coord sum_0 = GRAPHVIS::fr_force_repulsive(node, length_opt)[0] + GRAPHVIS::fr_force_attractive(node, length_opt)[0];
            Coord sum_1 = GRAPHVIS::fr_force_repulsive(node, length_opt)[1] + GRAPHVIS::fr_force_attractive(node, length_opt)[1];

            G.setCoords(node, G.getX(node)+(sum_0*multi), G.getY(node)+(sum_1*multi));
            Coord current_max_force = std::hypot(sum_0, sum_1);

            if(current_max_force > max_force)
            {
                max_force = std::abs(current_max_force);
            }
            multi *= delta;
            t++;
        } endfor
    }

}

std::vector<Coord> GRAPHVIS::fr_force_repulsive(NodeID& node, Coord& length_opt) {
    std::vector<Coord> forces_sum = {0,0};
    forall_nodes(G,other_node)
    {
        if(node == other_node)
        {
            continue;
        }
        Coord current_scalar = (length_opt*length_opt)/GRAPHVIS::euclidian_distance_2D(node, other_node);
        std::vector<Coord> current_force = {current_scalar * GRAPHVIS::unit_vector_approx(node, other_node)[0], current_scalar * GRAPHVIS::unit_vector_approx(node, other_node)[1]};
        forces_sum[0] += current_force[0];
        forces_sum[1] += current_force[1];
    } endfor
    return forces_sum;
}

std::vector<Coord> GRAPHVIS::fr_force_attractive(NodeID& node, Coord& length_opt) {
    std::vector<Coord> forces_sum = {0,0};
    forall_out_edges(G, e, node) {
        NodeID other_node = G.getEdgeTarget(e);
        Coord current_scalar = (GRAPHVIS::euclidian_distance_2D(node, other_node) * GRAPHVIS::euclidian_distance_2D(node, other_node))/length_opt;
        std::vector<Coord> current_force = {current_scalar * GRAPHVIS::unit_vector_approx(node, other_node)[0], current_scalar * GRAPHVIS::unit_vector_approx(node, other_node)[1]};
        forces_sum[0] += current_force[0];
        forces_sum[1] += current_force[1];
        forces_sum[1] += current_force[1];
    } endfor
    return forces_sum;
}

void GRAPHVIS::fruchterman_reingold_original(Coord _window_x, Coord _window_y, int iterations, Coord k, bool capped) {
    Coord k_squared = k*k;
    std::vector<Coord> temp_vec(2, 0);
    std::vector<std::vector<Coord>> displacement(G.number_of_nodes(),temp_vec);
    double temp_ = 10 * std::sqrt(G.number_of_nodes());

    for (int i = 0; i < iterations; i++)
    {
        forall_nodes(G,node)
        {
            //Repulsion forces between vertex pairs
            forall_nodes(G,other_node)
            {
                if(node != other_node)
                {
                    std::vector<Coord> delta = {G.getX(node) - G.getX(other_node), G.getY(node) - G.getY(other_node)};
                    Coord distance = std::hypot(delta[0], delta[1]);
                    Coord repulsion = k_squared / distance;
                    displacement[node][0] += (delta[0] / distance) * repulsion;
                    displacement[node][1] += (delta[1] / distance) * repulsion;
                    displacement[other_node][0] -= (delta[0] / distance) * repulsion;
                    displacement[other_node][1] -= (delta[1] / distance) * repulsion;
                }
            } endfor
            //Attraction forces between adjacent vertices
            forall_out_edges(G, e, node) {
                NodeID other_node = G.getEdgeTarget(e);
                std::vector<Coord> delta = {G.getX(node) - G.getX(other_node), G.getY(node) - G.getY(other_node)};
                Coord distance = std::hypot(delta[0], delta[1]);
                Coord attraction = (distance * distance) / k;
                displacement[node][0] -= (delta[0] / distance) * attraction;
                displacement[node][1] -= (delta[1] / distance) * attraction;
                displacement[other_node][0] += (delta[0] / distance) * attraction;
                displacement[other_node][1] += (delta[1] / distance) * attraction;
            } endfor
        } endfor

        forall_nodes(G,node)
        {
            Coord displacement_norm = std::hypot(displacement[node][0], displacement[node][1]);
            Coord capped_norm = std::min(displacement_norm, temp_);
            std::vector<Coord> capped_mvmt_temp(2,0);
            std::vector<std::vector<Coord>> capped_mvmt(G.number_of_nodes(),capped_mvmt_temp);
            capped_mvmt[node][0] = ((displacement[node][0] / displacement_norm) * capped_norm)+G.getX(node);
            capped_mvmt[node][1] = ((displacement[node][1] / displacement_norm) * capped_norm)+G.getY(node);
            if (capped == true)
            {
                capped_mvmt[node][0] = std::min(window_x, std::max(0.0, capped_mvmt[node][0]));
                capped_mvmt[node][1] = std::min(window_y, std::max(0.0, capped_mvmt[node][1]));
            }
            

            G.setCoords(node,capped_mvmt[node][0],capped_mvmt[node][1]);
        } endfor

        if (temp_ > 1.5) 
        {
            temp_ *= 0.85;
        } else 
        {
            temp_ = 1.5;
        }

    }
}

// ************************ KaDraw ******************************



void GRAPHVIS::graph_set_kadraw_coords(String filename, double scale) {
    std::string temp = filename.utf8().get_data();
    kahip::mmap_io::readCoordinates(G,temp);
    int max_dim_px = ui_get_window_x();
    const double border = 0.0;

    double x_min = G.getX(0);
    double x_max = G.getX(0);
    double y_min = G.getY(0);
    double y_max = G.getY(0);

    forall_nodes(G, node) {
            x_min = std::min(x_min, G.getX(node));
            x_max = std::max(x_max, G.getX(node));
            y_min = std::min(y_min, G.getY(node));
            y_max = std::max(y_max, G.getY(node));
    } endfor

    float width  = x_max - x_min + 2 * border;
    float height = y_max - y_min + 2 * border;

    
    if (width > height) {
            scale = 1.0 * max_dim_px / width;
    } else {
            scale = 1.0 * max_dim_px / height;
    }

    // ********* set coordinates with resolution scale *********  
    forall_nodes(G, node) {
            G.setCoords(node, (G.getX(node)*scale)+(ui_get_window_x()/2), (G.getY(node)*scale)+(ui_get_window_y()/2));
    } endfor

}





// ********************* Godot binding *******************************
void GRAPHVIS::_bind_methods() {
    // *************************** Init *********************************
    ClassDB::bind_method(D_METHOD("graph_init_edge_length_array"), &GRAPHVIS::graph_init_edge_length_array);
    ClassDB::bind_method(D_METHOD("Quantile"), &GRAPHVIS::Quantile);
    ClassDB::bind_method(D_METHOD("graph_init_edge_length_quartile_arrays"), &GRAPHVIS::graph_init_edge_length_quartile_arrays);
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
    ClassDB::bind_method(D_METHOD("graph_get_edge_length_array"), &GRAPHVIS::graph_get_edge_length_array);
    ClassDB::bind_method(D_METHOD("graph_get_edge_length"), &GRAPHVIS::graph_get_edge_length);
    ClassDB::bind_method(D_METHOD("graph_get_edge_lengths_pct"), &GRAPHVIS::graph_get_edge_length_pct);
    ClassDB::bind_method(D_METHOD("graph_get_min_edge_length"), &GRAPHVIS::graph_get_min_edge_length);
    ClassDB::bind_method(D_METHOD("graph_get_max_edge_length"), &GRAPHVIS::graph_get_max_edge_length);
    ClassDB::bind_method(D_METHOD("graph_get_quartiles_array"), &GRAPHVIS::graph_get_quartiles_array);
    ClassDB::bind_method(D_METHOD("graph_get_quartiles_indices_array"), &GRAPHVIS::graph_get_quartiles_indices_array);
    ClassDB::bind_method(D_METHOD("graph_get_edge_quartile_nr"), &GRAPHVIS::graph_get_edge_quartile_nr);
    ClassDB::bind_method(D_METHOD("graph_get_edge_lengths_quartile_pct"), &GRAPHVIS::graph_get_edge_lengths_quartile_pct);
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
    ClassDB::bind_method(D_METHOD("graph_getVertexSetIndex"), &GRAPHVIS::graph_getVertexSetIndex);
    ClassDB::bind_method(D_METHOD("graph_setVertexSetIndex"), &GRAPHVIS::graph_setVertexSetIndex);
    ClassDB::bind_method(D_METHOD("graph_getSecondPartitionIndex"), &GRAPHVIS::graph_getSecondPartitionIndex);
    ClassDB::bind_method(D_METHOD("graph_setSecondPartitionIndex"), &GRAPHVIS::graph_setSecondPartitionIndex);
    ClassDB::bind_method(D_METHOD("graph_resizeSecondPartitionIndex"), &GRAPHVIS::graph_resizeSecondPartitionIndex);
    ClassDB::bind_method(D_METHOD("graph_read_partition"), &GRAPHVIS::graph_read_partition);
    ClassDB::bind_method(D_METHOD("graph_read_vertex_set"), &GRAPHVIS::graph_read_vertex_set);
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
    // ************************ Algorithms ******************************
    ClassDB::bind_method(D_METHOD("fruchterman_reingold"), &GRAPHVIS::fruchterman_reingold);
    ClassDB::bind_method(D_METHOD("fruchterman_reingold_original"), &GRAPHVIS::fruchterman_reingold_original);
    // ************************** KaDraw ********************************
    ClassDB::bind_method(D_METHOD("graph_set_kadraw_coords"), &GRAPHVIS::graph_set_kadraw_coords);
}


// ********************* Constructor ********************************
GRAPHVIS::GRAPHVIS() {


}

// ******************************************************************