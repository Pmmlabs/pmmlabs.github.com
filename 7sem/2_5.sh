#!/bin/bash

# Задача 2(5).
# Используя /proc/cpuinfo, вывести количество cpu cores в системе.

cat /proc/cpuinfo | grep "cpu cores" | uniq

