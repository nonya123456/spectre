#ifndef MAZE_GRAPH_H
#define MAZE_GRAPH_H

#include <godot_cpp/classes/ref_counted.hpp>

namespace godot
{
    class MazeGraph : public RefCounted
    {
        GDCLASS(MazeGraph, RefCounted)

    public:
        MazeGraph();
        ~MazeGraph();

        void set_width(int p_width);
        int get_width() const;

        void set_height(int p_height);
        int get_height() const;

        void set_adj(const std::vector<std::set<int>> &p_adj);

        int get_num_edges() const;

        bool is_adjacent(int ax, int ay, int bx, int by) const;

    protected:
        static void _bind_methods();

    private:
        int width;
        int height;
        std::vector<std::set<int>> adj;
    };
}

#endif // MAZE_GRAPH_H
