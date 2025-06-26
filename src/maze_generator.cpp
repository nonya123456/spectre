#include "maze_generator.h"

#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/classes/random_number_generator.hpp>

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
    Ref<RandomNumberGenerator> rng;
    rng.instantiate();
    rng->set_seed(0);

    std::vector<std::set<int>> adj(width * height, std::set<int>());

    // 0 is not available, 1 is available, 2 is visited
    std::vector<std::vector<int>> grid(height, std::vector<int>(width, 0));
    std::vector<std::pair<int, int>> available_cells;

    int start_x = rng->randi_range(0, height - 1);
    int start_y = rng->randi_range(0, width - 1);
    available_cells.push_back({start_x, start_y});
    grid[start_x][start_y] = 1;

    while (!available_cells.empty())
    {
        int random_index = rng->randi_range(0, available_cells.size() - 1);
        auto [x, y] = available_cells[random_index];

        std::vector<std::pair<int, int>> visited_neighbors;
        if (x > 0 && grid[x - 1][y] == 2)
        {
            visited_neighbors.push_back({x - 1, y});
        }
        if (x < height - 1 && grid[x + 1][y] == 2)
        {
            visited_neighbors.push_back({x + 1, y});
        }
        if (y > 0 && grid[x][y - 1] == 2)
        {
            visited_neighbors.push_back({x, y - 1});
        }
        if (y < width - 1 && grid[x][y + 1] == 2)
        {
            visited_neighbors.push_back({x, y + 1});
        }

        if (!visited_neighbors.empty())
        {
            int random_neighbor_index = rng->randi_range(0, visited_neighbors.size() - 1);
            auto [nx, ny] = visited_neighbors[random_neighbor_index];
            adj[nx * width + ny].insert(x * width + y);
            adj[x * width + y].insert(nx * width + ny);
        }

        available_cells.erase(available_cells.begin() + random_index);
        grid[x][y] = 2;

        if (x > 0 && grid[x - 1][y] == 0)
        {
            available_cells.push_back({x - 1, y});
            grid[x - 1][y] = 1;
        }
        if (x < height - 1 && grid[x + 1][y] == 0)
        {
            available_cells.push_back({x + 1, y});
            grid[x + 1][y] = 1;
        }
        if (y > 0 && grid[x][y - 1] == 0)
        {
            available_cells.push_back({x, y - 1});
            grid[x][y - 1] = 1;
        }
        if (y < width - 1 && grid[x][y + 1] == 0)
        {
            available_cells.push_back({x, y + 1});
            grid[x][y + 1] = 1;
        }
    }

    Ref<MazeGraph> maze_graph;
    maze_graph.instantiate();

    maze_graph->set_width(width);
    maze_graph->set_height(height);
    maze_graph->set_adj(adj);

    return maze_graph;
}
