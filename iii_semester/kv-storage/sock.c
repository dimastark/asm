#include <stdio.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <stdlib.h>

#define PORT 31000
#define ADDR "10.96.19.24"

int create_client_socket() {
    int sock = socket(AF_INET, SOCK_STREAM , 0);
    if (sock == -1) {
        perror("Couldn't create socket");
        exit(1);
    }

    return sock;
}

struct sockaddr_in get_server_description() {
    struct sockaddr_in server = {
            .sin_addr.s_addr = inet_addr(ADDR),
            .sin_family = AF_INET,
            .sin_port = htons(PORT)
    };

    return server;
}

void connect_to(int sock, struct sockaddr_in server) {
    if (connect(sock, (struct sockaddr *)&server, sizeof(server)) < 0) {
        perror("Couldn't connect to server");
        exit(1);
    }
}

char* readAllFile(char *filename) {
    size_t read_size;
    long string_size;

    char *buffer = NULL;
    FILE *handler = fopen(filename, "r");

    if (handler) {
        fseek(handler, 0, SEEK_END);
        string_size = ftell(handler);
        rewind(handler);

        buffer = (char*) malloc(sizeof(char) * (string_size + 1));

        read_size = fread(buffer, sizeof(char), (size_t) string_size, handler);

        buffer[string_size] = '\0';

        if (string_size != read_size) {
            free(buffer);
            buffer = NULL;
        }

        fclose(handler);
    }

    return buffer;
}
