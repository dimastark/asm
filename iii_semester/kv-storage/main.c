#include<stdio.h>
#include<string.h>
#include<arpa/inet.h>
#include<zconf.h>

#include "sock.c"
#include "struct.c"

char server_reply[32768];

int help() {
    puts("Hello! You need some help?");
    puts("Here it is!\n");
    puts("usage: kv-storage-client <command> [<args>]\n");
    puts("  ??               Show this help.");
    puts("  l                List all stored keys");
    puts("  + <key> <value>  Store <value> by <key>");
    puts("  + <filename>     Store file by 'fn' key");
    puts("  ? <key>          Get value by <key>");
    puts("  - <key>          Delete <key> from storage");
    puts("  #                Count all keys in storage\n");
    return 0;
}

int list(int sock) {
    send(sock, "\0\0", 2, 0);
    recv(sock, server_reply, 32768, 0);

    printStrings(server_reply, 2, server_reply[1]);

    return strcmp(server_reply, "\0") == 0;
}

int set(int sock, char const *key, char const *value) {
    char packet[32768] = {1, 2};
    int packedCount = 2;

    packedCount += packString(key, packet, packedCount);
    packedCount += packString(value, packet, packedCount);

    send(sock, packet, (size_t) packedCount, 0);
    recv(sock, server_reply, 32768, 0);

    return strcmp(server_reply, "\0\0");
}

int setFn(int sock, char *filename) {
    char packet[32768] = {1, 2};
    int packedCount = 2;

    packedCount += packString(filename, packet, packedCount);

    char* content = readAllFile(filename);
    if (content == NULL) {
        return 1;
    } else {
        packedCount += packString(content, packet, packedCount);
    }

    send(sock, packet, (size_t) packedCount, 0);
    recv(sock, server_reply, 32768, 0);

    return strcmp(server_reply, "\0\0");
}

int get(int sock, char *key) {
    char packet[32768] = {2, 1};
    int packedCount = 2;

    packedCount += packString(key, packet, packedCount);

    send(sock, packet, (size_t) packedCount, 0);
    recv(sock, server_reply, 32768, 0);

    printStrings(server_reply, 2, server_reply[1]);

    return strcmp(server_reply, "\0") == 0;
}

int delete(int sock, char *key) {
    char packet[32768] = {3, 1};
    int packedCount = 2;

    packedCount += packString(key, packet, packedCount);

    send(sock, packet, (size_t) packedCount, 0);
    recv(sock, server_reply, 32768, 0);

    printStrings(server_reply, 2, server_reply[1]);

    return strcmp(server_reply, "\0");
}

int count(int sock) {
    send(sock, "\4\0", 2, 0);
    recv(sock, server_reply, 32768, 0);

    printStrings(server_reply, 2, server_reply[1]);

    return strcmp(server_reply, "\0") == 0;
}

int main(int argc, char *argv[]) {
    int result = -1;
    int sock = create_client_socket();
    struct sockaddr_in server = get_server_description();

    if (strcmp(argv[1], "??") == 0) {
        return help();
    }

    connect_to(sock, server);

    if (strcmp(argv[1], "l") == 0) {
        result = list(sock);
    } else if (strcmp(argv[1], "+") == 0 && argv[2] != NULL && argv[3] != NULL) {
        result = set(sock, argv[2], argv[3]);
    } else if (strcmp(argv[1], "+") == 0 && argv[2] != NULL) {
        result = setFn(sock, argv[2]);
    } else if (strcmp(argv[1], "?") == 0 && argv[2] != NULL) {
        result = get(sock, argv[2]);
    } else if (strcmp(argv[1], "-") == 0 && argv[2] != NULL) {
        result = delete(sock, argv[2]);
    } else if (strcmp(argv[1], "#") == 0) {
        result = count(sock);
    }

    close(sock);

    if (result == -1) {
        perror("Wrong arguments!");
        exit(1);
    }

    return result;
}
