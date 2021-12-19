/* register_types.cpp */

#include "register_types.h"

#include "core/class_db.h"
#include "graphvis.h"

void register_graphvis_types() {
    ClassDB::register_class<GRAPHVIS>();
}

void unregister_graphvis_types() {
    // Nothing to do here in this example.
}