#ifndef FOO_H
#define FOO_H

#include <godot_cpp/classes/node.hpp>
#include <godot_cpp/variant/string.hpp>

namespace godot
{
    class Foo : public Node
    {
        GDCLASS(Foo, Node)

    private:
        String name;

    protected:
        static void _bind_methods();

    public:
        Foo();
        ~Foo();

        void _ready() override;

        void set_name(const String &p_value);
        String get_name() const;
    };
}

#endif
