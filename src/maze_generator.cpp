#include "maze_generator.h"

#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/classes/random_number_generator.hpp>
#include <vector>

using namespace godot;

void MazeGenerator::_bind_methods()
{
    ClassDB::bind_static_method("MazeGenerator", D_METHOD("generate_maze", "width", "height"), &MazeGenerator::generate_maze);
}

MazeGenerator::MazeGenerator()
{
}

MazeGenerator::~MazeGenerator()
{
}

Ref<MazeGraph> MazeGenerator::generate_maze(int width, int height)
{
    Ref<MazeGraph> maze_graph;
    maze_graph.instantiate();

    maze_graph->set_width(width);
    maze_graph->set_height(height);

    // -2 is visited
    // -1 is not available
    // otherwise, available (parent index)
    std::vector<std::vector<int>> grid(width, std::vector<int>(height, -1));
    std::vector<std::pair<int, int>> available_cells;
    std::vector<std::pair<int, int>> edges;

    RandomNumberGenerator *rng = memnew(RandomNumberGenerator);
    rng->randomize();

    int start_x = rng->randi_range(0, width - 1);
    int start_y = rng->randi_range(0, height - 1);
    available_cells.push_back({start_x, start_y});
    grid[start_x][start_y] = width * height; // root

    while (!available_cells.empty())
    {
        int random_index = rng->randi_range(0, available_cells.size() - 1);
        auto [x, y] = available_cells[random_index];

        if (grid[x][y] >= 0 && grid[x][y] < width * height)
        {
            edges.push_back({x * height + y, grid[x][y]});
        }

        available_cells.erase(available_cells.begin() + random_index);
        grid[x][y] = -2;

        if (x > 0 && grid[x - 1][y] == -1)
        {
            available_cells.push_back({x - 1, y});
            grid[x - 1][y] = x * height + y;
        }
        if (x < width - 1 && grid[x + 1][y] == -1)
        {
            available_cells.push_back({x + 1, y});
            grid[x + 1][y] = x * height + y;
        }
        if (y > 0 && grid[x][y - 1] == -1)
        {
            available_cells.push_back({x, y - 1});
            grid[x][y - 1] = x * height + y;
        }
        if (y < height - 1 && grid[x][y + 1] == -1)
        {
            available_cells.push_back({x, y + 1});
            grid[x][y + 1] = x * height + y;
        }
    }

    UtilityFunctions::print("Maze generation complete. Edges count: " + String::num_int64(edges.size()));
    for (const auto &edge : edges)
    {
        UtilityFunctions::print("Edge: " + String::num_int64(edge.first) + " -> " + String::num_int64(edge.second));
    }

    return maze_graph;
}
