from __future__ import print_function
# import mypkg.sibling
# from mypkg import sibling
# from mypkg.sibling import example
# from . import sibling
# from .sibling import example


def sum_nums(n):
    s = 0
    for i in range(n):
        s += i
        print(s)


if __name__ == '__main__':
    sum_nums(5)
