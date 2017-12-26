#include <stdio.h>

int pack_int(int const data, int offset, char *result) {
    result[offset] = (unsigned char) ((data >> 24) & 0xFF);
    result[offset + 1] = (unsigned char) ((data >> 16) & 0xFF);
    result[offset + 2] = (unsigned char) ((data >> 8) & 0xFF);
    result[offset + 3] = (unsigned char) (data & 0xFF);

    return 4;
}

int unpack_int(const char *data, int offset) {
    unsigned char result[4];

    result[3] = (unsigned char) ((data[offset + 3] >> 24) & 0xFF);
    result[2] = (unsigned char) ((data[offset + 2] >> 16) & 0xFF);
    result[1] = (unsigned char) ((data[offset + 1] >> 8) & 0xFF);
    result[0] = (unsigned char) (data[offset + 0] & 0xFF);

    return *(int *)result;
}

int pack(const char from[], char result[], int offset) {
    int packed;

    for (packed = 0; from[packed] != '\0'; packed++) {
        result[offset + packed] = from[packed];
    }

    return packed;
}

int pack_string(const char *data, char *result, int offset) {
    int blockLength = pack(data, result, offset + 4);

    return blockLength + pack_int(blockLength, offset, result);
}

int unpack_string(const char *data, char *result, int offset) {
    char blockSize[4];
    for (int i = 0; i < 4; i++) {
        blockSize[3 - i] = data[offset + i];
    }

    int blockLength = unpack_int(blockSize, 0);
    for (int i = 0; i < blockLength; i++) {
        result[i] = data[offset + 4 + i];
    }
    result[blockLength] = '\0';

    return blockLength + 4;
}

void print_strings(const char *data, int offset, int count) {
    for (int i = 0; i < count; i++) {
        char output[32768];
        offset += unpack_string(data, output, offset);
        puts(output);
    }
}
