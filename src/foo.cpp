#include "foo.h"

#include <godot_cpp/core/class_db.hpp>

using namespace godot;

void Foo::_bind_methods()
{
    ClassDB::bind_method(D_METHOD("set_name"), &Foo::set_name);
    ClassDB::bind_method(D_METHOD("get_name"), &Foo::get_name);
    ADD_PROPERTY(PropertyInfo(Variant::STRING, "name"), "set_name", "get_name");
}

Foo::Foo()
{
}

Foo::~Foo()
{
}

void Foo::_ready()
{
    UtilityFunctions::print("Foo node is ready with name: " + name);
}

void Foo::set_name(const String &p_value)
{
    name = p_value;
}

String Foo::get_name() const
{
    return name;
}