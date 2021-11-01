double __attribute__((noinline)) f(double d)
{
    return d;
}

int main()
{
    f(1.0);
    return 0;
}
