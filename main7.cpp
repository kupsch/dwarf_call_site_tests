#ifdef __clang__
    #define OPTNONE __attribute__((optnone))
#else
    #define OPTNONE
#endif

double OPTNONE __attribute__((noinline)) func(double d)
{
    return d;
}

int main()
{
    return func(1.0);
}
