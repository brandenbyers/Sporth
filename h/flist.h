static sporth_func flist[] = {
    {"add", sporth_add, NULL},
    {"sub", sporth_sub, NULL},
    {"mul", sporth_mul, &plumb_g},
    {"div", sporth_divide, &plumb_g},
    {"sine", sporth_sine, &plumb_g},
    {"c", sporth_constant, &plumb_g},
    {"mix", sporth_mix, &plumb_g},
    {"metro", sporth_metro, &plumb_g},
    {"tenv", sporth_tenv, &plumb_g},
    {NULL, NULL, NULL}
};
