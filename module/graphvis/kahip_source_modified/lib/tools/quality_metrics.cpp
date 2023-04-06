/******************************************************************************
 * quality_metrics.cpp 
 * *
 * Source of KaHIP -- Karlsruhe High Quality Partitioning.
 * Christian Schulz <christian.schulz.phone@gmail.com>
 *****************************************************************************/

#include <algorithm>
#include <cmath>

#include "quality_metrics.h"
#include "data_structure/union_find.h"

#include <unordered_map>
#include <numeric>

//MODIFIED: added library as in KaDraw's quality_metrics.cpp

#include <iomanip>
#include "algorithms/shortest_paths.h"


quality_metrics::quality_metrics() {
}

quality_metrics::~quality_metrics () {
}

EdgeWeight quality_metrics::edge_cut(graph_access & G) {
        EdgeWeight edgeCut = 0;
        forall_nodes(G, n) { 
                PartitionID partitionIDSource = G.getPartitionIndex(n);
                forall_out_edges(G, e, n) {
                        NodeID targetNode = G.getEdgeTarget(e);
                        PartitionID partitionIDTarget = G.getPartitionIndex(targetNode);

                        if (partitionIDSource != partitionIDTarget) {
                                edgeCut += G.getEdgeWeight(e);
                        }
                } endfor 
        } endfor
        return edgeCut/2;
}

EdgeWeight quality_metrics::edge_cut(graph_access & G, int * partition_map) {
        EdgeWeight edgeCut = 0;
        forall_nodes(G, n) { 
                PartitionID partitionIDSource = partition_map[n];
                forall_out_edges(G, e, n) {
                        NodeID targetNode = G.getEdgeTarget(e);
                        PartitionID partitionIDTarget = partition_map[targetNode];

                        if (partitionIDSource != partitionIDTarget) {
                                edgeCut += G.getEdgeWeight(e);
                        }
                } endfor 
        } endfor
        return edgeCut/2;
}

EdgeWeight quality_metrics::edge_cut(graph_access & G, PartitionID lhs, PartitionID rhs) {
        EdgeWeight edgeCut = 0;
        forall_nodes(G, n) { 
                PartitionID partitionIDSource = G.getPartitionIndex(n);
                if(partitionIDSource != lhs) continue;
                forall_out_edges(G, e, n) {
                        NodeID targetNode = G.getEdgeTarget(e);
                        PartitionID partitionIDTarget = G.getPartitionIndex(targetNode);

                        if(partitionIDTarget == rhs) {
                                edgeCut += G.getEdgeWeight(e);
                        }
                } endfor 
        } endfor
        return edgeCut;
}

EdgeWeight quality_metrics::edge_cut_connected(graph_access & G, int * partition_map) {
        EdgeWeight edgeCut = 0;
        EdgeWeight sumEW = 0;
        forall_nodes(G, n) { 
                PartitionID partitionIDSource = partition_map[n];
                forall_out_edges(G, e, n) {
                        NodeID targetNode = G.getEdgeTarget(e);
                        PartitionID partitionIDTarget = partition_map[targetNode];

                        if (partitionIDSource != partitionIDTarget) {
                                edgeCut += G.getEdgeWeight(e);
                        }
                        sumEW+=G.getEdgeWeight(e);
                } endfor 
        } endfor
        union_find uf(G.number_of_nodes());
        forall_nodes(G, node) {
                forall_out_edges(G, e, node) {
                        NodeID target = G.getEdgeTarget(e);
                        if(partition_map[node] == partition_map[target]) {
                                uf.Union(node, target); 
                        }
                } endfor
        } endfor

        std::unordered_map<NodeID, NodeID> size_right;
        forall_nodes(G, node) {
                size_right[uf.Find(node)] = 1;
        } endfor


        std::cout <<  "number of connected comp " <<  size_right.size()  << std::endl;
        if( size_right.size() == G.get_partition_count()) {
                return edgeCut/2;
        } else {
                return edgeCut/2+sumEW*size_right.size();
        }

}


EdgeWeight quality_metrics::max_communication_volume(graph_access & G, int * partition_map) {
    std::vector<EdgeWeight> block_volume(G.get_partition_count(),0);
    forall_nodes(G, node) {
        PartitionID block = partition_map[node];
        std::vector<bool> block_incident(G.get_partition_count(), false);
        block_incident[block] = true;

        int num_incident_blocks = 0;

        forall_out_edges(G, e, node) {
            NodeID target = G.getEdgeTarget(e);
            PartitionID target_block = partition_map[target];
            if(!block_incident[target_block]) {
                block_incident[target_block] = true;
                num_incident_blocks++;
            }
        } endfor
        block_volume[block] += num_incident_blocks;
    } endfor

    EdgeWeight max_comm_volume = *(std::max_element(block_volume.begin(), block_volume.end()));
    return max_comm_volume;
}

EdgeWeight quality_metrics::min_communication_volume(graph_access & G) {
    std::vector<EdgeWeight> block_volume(G.get_partition_count(),0);
    forall_nodes(G, node) {
        PartitionID block = G.getPartitionIndex(node);
        std::vector<bool> block_incident(G.get_partition_count(), false);
        block_incident[block] = true;
        int num_incident_blocks = 0;

        forall_out_edges(G, e, node) {
            NodeID target = G.getEdgeTarget(e);
            PartitionID target_block = G.getPartitionIndex(target);
            if(!block_incident[target_block]) {
                block_incident[target_block] = true;
                num_incident_blocks++;
            }
        } endfor
        block_volume[block] += num_incident_blocks;
    } endfor

    EdgeWeight min_comm_volume = *(std::min_element(block_volume.begin(), block_volume.end()));
    return min_comm_volume;
}

EdgeWeight quality_metrics::max_communication_volume(graph_access & G) {
    std::vector<EdgeWeight> block_volume(G.get_partition_count(),0);
    forall_nodes(G, node) {
        PartitionID block = G.getPartitionIndex(node);
        std::vector<bool> block_incident(G.get_partition_count(), false);
        block_incident[block] = true;
        int num_incident_blocks = 0;

        forall_out_edges(G, e, node) {
            NodeID target = G.getEdgeTarget(e);
            PartitionID target_block = G.getPartitionIndex(target);
            if(!block_incident[target_block]) {
                block_incident[target_block] = true;
                num_incident_blocks++;
            }
        } endfor
        block_volume[block] += num_incident_blocks;
    } endfor

    EdgeWeight max_comm_volume = *(std::max_element(block_volume.begin(), block_volume.end()));
    return max_comm_volume;
}

EdgeWeight quality_metrics::total_communication_volume(graph_access & G) {
    std::vector<EdgeWeight> block_volume(G.get_partition_count(),0);
    forall_nodes(G, node) {
        PartitionID block = G.getPartitionIndex(node);
        std::vector<bool> block_incident(G.get_partition_count(), false);
        block_incident[block] = true;
        int num_incident_blocks = 0;

        forall_out_edges(G, e, node) {
            NodeID target = G.getEdgeTarget(e);
            PartitionID target_block = G.getPartitionIndex(target);
            if(!block_incident[target_block]) {
                block_incident[target_block] = true;
                num_incident_blocks++;
            }
        } endfor
        block_volume[block] += num_incident_blocks;
    } endfor

    EdgeWeight total_comm_volume = std::accumulate(block_volume.begin(), block_volume.end(),0);
    return total_comm_volume;
}



int quality_metrics::boundary_nodes(graph_access& G) {
        int no_of_boundary_nodes = 0;
        forall_nodes(G, n) { 
                PartitionID partitionIDSource = G.getPartitionIndex(n);

                forall_out_edges(G, e, n) {
                        NodeID targetNode = G.getEdgeTarget(e);
                        PartitionID partitionIDTarget = G.getPartitionIndex(targetNode);

                        if (partitionIDSource != partitionIDTarget) {
                                no_of_boundary_nodes++;
                                break; 
                        }
                } endfor 
        }       endfor
        return no_of_boundary_nodes;
}

double quality_metrics::balance_separator(graph_access& G) {
        std::vector<PartitionID> part_weights(G.get_partition_count(), 0);

        double overallWeight = 0;

        forall_nodes(G, n) {
                PartitionID curPartition = G.getPartitionIndex(n);
                part_weights[curPartition] += G.getNodeWeight(n);
                overallWeight += G.getNodeWeight(n);
        } endfor

        double balance_part_weight = ceil(overallWeight / (double)(G.get_partition_count()-1));
        double cur_max             = -1;

        PartitionID separator_block = G.getSeparatorBlock();
        forall_blocks(G, p) {
                if( p == separator_block ) continue;
                double cur = part_weights[p];
                if (cur > cur_max) {
                        cur_max = cur;
                }
        } endfor

        double percentage = cur_max/balance_part_weight;
        return percentage;
}

NodeWeight quality_metrics::separator_weight(graph_access& G) {
        NodeWeight separator_size = 0;
        PartitionID separator_ID = G.getSeparatorBlock();
        forall_nodes(G, node) {
                if( G.getPartitionIndex(node) == separator_ID) {
                        separator_size += G.getNodeWeight(node);
		}
        } endfor

        return separator_size;
}

double quality_metrics::balance(graph_access& G) {
        std::vector<PartitionID> part_weights(G.get_partition_count(), 0);

        double overallWeight = 0;

        forall_nodes(G, n) {
                PartitionID curPartition = G.getPartitionIndex(n);
                part_weights[curPartition] += G.getNodeWeight(n);
                overallWeight += G.getNodeWeight(n);
        } endfor

        double balance_part_weight = ceil(overallWeight / (double)G.get_partition_count());
        double cur_max             = -1;

        forall_blocks(G, p) {
                double cur = part_weights[p];
                if (cur > cur_max) {
                        cur_max = cur;
                }
        } endfor

        double percentage = cur_max/balance_part_weight;
        return percentage;
}

double quality_metrics::edge_balance(graph_access &G, const std::vector<PartitionID> &edge_partition) {
    std::vector<PartitionID> part_weights(G.get_partition_count(), 0);

    double overallWeight = 0;

    forall_edges(G, e) {
        PartitionID curPartition = edge_partition[e];
        ++part_weights[curPartition];
        ++overallWeight;
    } endfor

    double balance_part_weight = ceil(overallWeight / (double)G.get_partition_count());
    double cur_max             = -1;

    forall_blocks(G, p) {
        double cur = part_weights[p];
        if (cur > cur_max) {
            cur_max = cur;
        }
    } endfor

    double percentage = cur_max/balance_part_weight;
    return percentage;
}

double quality_metrics::balance_edges(graph_access& G) {
        std::vector<PartitionID> part_weights(G.get_partition_count(), 0);

        double overallWeight = 0;

        forall_nodes(G, n) {
                PartitionID curPartition = G.getPartitionIndex(n);
                part_weights[curPartition] += G.getNodeDegree(n);
                overallWeight += G.getNodeDegree(n);
        } endfor

        double balance_part_weight = ceil(overallWeight / (double)G.get_partition_count());
        double cur_max             = -1;

        forall_blocks(G, p) {
                double cur = part_weights[p];
                if (cur > cur_max) {
                        cur_max = cur;
                }
        } endfor

        double percentage = cur_max/balance_part_weight;
        return percentage;
}

EdgeWeight quality_metrics::objective(const PartitionConfig & config, graph_access & G, int* partition_map) {
        if(config.mh_optimize_communication_volume) {
                return max_communication_volume(G, partition_map);
        } else if(config.mh_penalty_for_unconnected) {
                return edge_cut_connected(G, partition_map);
        } else {
                return edge_cut(G, partition_map);
        }
}

NodeWeight quality_metrics::total_qap(graph_access & C, matrix & D, std::vector< NodeID > & rank_assign) {
        NodeWeight total_volume = 0;
        forall_nodes(C, node) {
                forall_out_edges(C, e, node) {
                        NodeID target           = C.getEdgeTarget(e);
                        NodeWeight comm_vol     = C.getEdgeWeight(e);
                        NodeID perm_rank_node   = rank_assign[node];
                        NodeID perm_rank_target = rank_assign[target];
                        NodeWeight cur_vol      = comm_vol*D.get_xy(perm_rank_node, perm_rank_target);
                        total_volume           += cur_vol; 
                } endfor
        } endfor
        return total_volume;
}

NodeWeight quality_metrics::total_qap(matrix & C, matrix & D, std::vector< NodeID > & rank_assign) {
        NodeWeight total_volume = 0;
        for( unsigned int i = 0; i < C.get_x_dim(); i++) {
                for( unsigned int j = 0; j < C.get_y_dim(); j++) {
                        NodeID perm_rank_node      = rank_assign[i];
                        NodeID perm_rank_target    = rank_assign[j];
                        total_volume += C.get_xy(i,j)*D.get_xy(perm_rank_node, perm_rank_target);
                }
        }
        return total_volume;
}

// ************************ KaDraw ******************************

//MODIFIED: added KaDraw quality_metrics functions


void quality_metrics::print_distances( graph_access & G) {
        forall_nodes(G, node) {
                forall_out_edges(G, e, node) {
                        NodeID target = G.getEdgeTarget(e);
                        if( node < target ) {
                                double distance = sqrt((G.getX(node) - G.getX(target))*(G.getX(node) - G.getX(target))+ (G.getY(node) - G.getY(target))*(G.getY(node) - G.getY(target)));
                                std::cout <<  "distance node " <<  node <<  " target " <<  target << " is " <<  std::setprecision(200) <<  distance << std::endl;
                        }
                } endfor          
        } endfor
}

double quality_metrics::maxent_unitweight( graph_access & G, double q, double alpha, std::string prefix ) {
        double energy  = 0;
        double entropy = 0;

        forall_nodes_parallel_reduce(G, source, +, entropy) {
                forall_nodes(G, target) {
                        if(source == target) continue;

                        double diffX       = G.getX(source) - G.getX(target);
                        double diffY       = G.getY(source) - G.getY(target);
                        double dist_square = diffX*diffX+diffY*diffY;
                        double dist        = sqrt(dist_square);

                        if(abs(q) < 0.001) {
                                entropy += log(dist);
                        } else {
                                entropy += pow(dist,-q);
                        }
                } endfor
        } endfor

        forall_nodes(G, source) {
                forall_out_edges(G, e, source) {
                        NodeID target = G.getEdgeTarget(e);
                        double diffX       = G.getX(source) - G.getX(target);
                        double diffY       = G.getY(source) - G.getY(target);
                        double dist_square = diffX*diffX+diffY*diffY;
                        double dist        = sqrt(dist_square);

                        int best_distance = 1;
                        energy += (dist - best_distance)*(dist - best_distance)/(best_distance*best_distance);

                        // we added those in the previous iteration but they do not belong here
                        if(abs(q) < 0.001) {
                                entropy -= log(dist);
                        } else {
                                entropy -= pow(dist,-q);
                        }

                } endfor
        } endfor

        if(abs(q) > 0.001) {
               entropy *= -sgn(q);
        }

        std::cout <<  prefix << "sgn(q="<<q<<") is " << sgn(q) << std::endl;
        std::cout <<  prefix << "energy is " <<  energy << std::endl;
        std::cout <<  prefix << "entropy is " <<  entropy  << std::endl;
        std::cout <<  prefix << "alpha*entropy is " <<  alpha*entropy  << std::endl;
        std::cout <<  prefix <<"alpha is " << std::setprecision(4) <<  alpha  << std::endl;

        energy -= alpha*entropy;
        return energy;
}


double quality_metrics::maxent_unitweight( graph_access & G, double q, double alpha ) {
        double energy  = 0;
        double entropy = 0;

        forall_nodes_parallel_reduce(G, source, +, entropy) {
                forall_nodes(G, target) {
                        if(source == target) continue;

                        double diffX       = G.getX(source) - G.getX(target);
                        double diffY       = G.getY(source) - G.getY(target);
                        double dist_square = diffX*diffX+diffY*diffY;
                        double dist        = sqrt(dist_square);

                        if(abs(q) < 0.001) {
                                entropy += log(dist);
                        } else {
                                entropy += pow(dist,-q);
                        }
                } endfor
        } endfor

        forall_nodes(G, source) {
                forall_out_edges(G, e, source) {
                        NodeID target = G.getEdgeTarget(e);
                        double diffX       = G.getX(source) - G.getX(target);
                        double diffY       = G.getY(source) - G.getY(target);
                        double dist_square = diffX*diffX+diffY*diffY;
                        double dist        = sqrt(dist_square);

                        int best_distance = 1;
                        energy += (dist - best_distance)*(dist - best_distance)/(best_distance*best_distance);

                        // we added those in the previous iteration but they do not belong here
                        if(abs(q) < 0.001) {
                                entropy -= log(dist);
                        } else {
                                entropy -= pow(dist,-q);
                        }

                } endfor
        } endfor

        if(abs(q) > 0.001) {
               entropy *= -sgn(q);
        }

        std::cout <<  "sgn(q="<<q<<") is " << sgn(q) << std::endl;
        std::cout <<  "energy is " <<  energy << std::endl;
        std::cout <<  "entropy is " <<  entropy  << std::endl;
        std::cout <<  "alpha*entropy is " <<  alpha*entropy  << std::endl;
        std::cout <<  "alpha is " << std::setprecision(4) <<  alpha  << std::endl;

        energy -= alpha*entropy;
        return energy/2;
}

double quality_metrics::full_stress_measure_unit_weight( graph_access & G ) {
        double energy = 0;
        double scaling_factor = compute_fsm_scaling_factor_unit_weight(G);
        std::cout <<  "scaling factor is " << scaling_factor  << std::endl;
        forall_nodes_parallel_reduce(G, source,+,energy) {
	        shortest_paths sp;
	        std::vector<int> deepth(G.number_of_nodes(), -1);
                sp.one_to_many_unit_weight(G, source, deepth);

                forall_nodes(G, target) {
                        double diffX       = G.getX(source) - G.getX(target);
                        double diffY       = G.getY(source) - G.getY(target);
                        double dist_square = diffX*diffX+diffY*diffY;
                        double dist        = sqrt(dist_square);

                        int best_distance = deepth[target];
                        if( best_distance == 0 ) continue;
                        energy += (scaling_factor*dist - best_distance)*(scaling_factor*dist - best_distance)/(best_distance*best_distance);
                } endfor
        } endfor

        return energy/2;
}

double quality_metrics::compute_fsm_scaling_factor_unit_weight( graph_access & G ) {
        double top_fraction    = 0;
        double bottom_fraction = 0;
        forall_nodes_parallel_reduce(G, source,+,top_fraction) {
                shortest_paths sp;
	        std::vector<int> deepth(G.number_of_nodes(), -1);
                sp.one_to_many_unit_weight(G, source, deepth);

                forall_nodes(G, target) {
                        double diffX       = G.getX(source) - G.getX(target);
                        double diffY       = G.getY(source) - G.getY(target);
                        double dist_square = diffX*diffX+diffY*diffY;
                        double dist        = sqrt(dist_square);

                        int best_distance = deepth[target];
                        if( best_distance == 0 ) continue;
                        top_fraction += (dist / best_distance);

                } endfor
        } endfor

        forall_nodes_parallel_reduce(G, source,+,bottom_fraction) {
                shortest_paths sp;
	        std::vector<int> deepth(G.number_of_nodes(), -1);
                sp.one_to_many_unit_weight(G, source, deepth);

                forall_nodes(G, target) {
                        double diffX       = G.getX(source) - G.getX(target);
                        double diffY       = G.getY(source) - G.getY(target);
                        double dist_square = diffX*diffX+diffY*diffY;
                        double dist        = sqrt(dist_square);

                        int best_distance = deepth[target];
                        if( best_distance == 0 ) continue;
                        bottom_fraction += (dist*dist) / (best_distance*best_distance);

                } endfor
        } endfor


        return top_fraction/bottom_fraction;
}

double quality_metrics::compute_sparse_scaling_factor_unit_weight( graph_access & G ) {
        double top_fraction    = 0;
        double bottom_fraction = 0;
        forall_nodes_parallel_reduce(G, source,+,top_fraction) {

                forall_out_edges(G, e, source) {
                        NodeID target = G.getEdgeTarget(e);
                        double diffX       = G.getX(source) - G.getX(target);
                        double diffY       = G.getY(source) - G.getY(target);
                        double dist_square = diffX*diffX+diffY*diffY;
                        double dist        = sqrt(dist_square);

                        int best_distance = 1;
                        if( best_distance == 0 ) continue;
                        top_fraction += (dist / best_distance);

                } endfor
        } endfor

        forall_nodes_parallel_reduce(G, source,+,bottom_fraction) {

                forall_out_edges(G, e, source) {
                        NodeID target = G.getEdgeTarget(e);
                        double diffX       = G.getX(source) - G.getX(target);
                        double diffY       = G.getY(source) - G.getY(target);
                        double dist_square = diffX*diffX+diffY*diffY;
                        double dist        = sqrt(dist_square);

                        int best_distance = 1;
                        if( best_distance == 0 ) continue;
                        bottom_fraction += (dist*dist) / (best_distance*best_distance);

                } endfor
        } endfor


        return top_fraction/bottom_fraction;
}


double quality_metrics::avg_infeasibility_per_edge( graph_access & G) {
        double total_infisibility = 0;

        forall_nodes(G, source) {
                forall_out_edges(G, e, source) {
                        NodeID target = G.getEdgeTarget(e);

                        double diffX       = G.getX(source) - G.getX(target);
                        double diffY       = G.getY(source) - G.getY(target);
                        double dist_square = diffX*diffX+diffY*diffY;
                        double dist        = sqrt(dist_square);

                        total_infisibility += fabs(1.0-dist);
                } endfor
        } endfor
        
        return total_infisibility/(double)G.number_of_edges();
}

