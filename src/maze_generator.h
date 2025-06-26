#ifndef MAZE_GENERATOR_H
#define MAZE_GENERATOR_H

#include <godot_cpp/classes/object.hpp>

namespace godot
{
    class MazeGenerator : public Object
    {
        GDCLASS(MazeGenerator, Object);

    public:
        MazeGenerator();
        ~MazeGenerator();

        static String generate_maze(int width, int height);

    protected:
        static void _bind_methods();
    };
}

#endif // MAZE_GENERATOR_H
