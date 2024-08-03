#include <math.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <omp.h>

void swaylock_effect(uint32_t *data, int width, int height, int scale) {
    uint32_t *destbuf = calloc(width * height, 4);

#pragma omp parallel for
    for (int y = 0; y < height; ++y) {
        for (int x = 0; x < width; ++x) {
            int dy = y - height / 2;
            int dx = x - width / 2;
            double len = sqrt(dx * dx + dy * dy);
            double angle = len / (300.0 / scale);

            int destdy = (int)(dx * sin(angle) - dy * cos(angle));
            int destdx = (int)(dx * cos(angle) + dy * sin(angle));
            int desty = height / 2 - destdy;
            int destx = width / 2 + destdx;

            if (desty < 0 || desty >= height) continue;
            if (destx < 0 || destx >= width) continue;

            destbuf[desty * width + destx] = data[y * width + x];
        }
    }

    memcpy(data, destbuf, width * height * 4);
    free(destbuf);
}