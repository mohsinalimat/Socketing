//
//  Socketing
//
//  Created by Meniny on 2017-05-13.
//  Copyright © 2017年 Meniny. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <sys/types.h>
#include <string.h>
#include <unistd.h>
#include <netdb.h>
#define c_udp_socket_buff_len 8192

//return socket fd
int c_udp_socket_server(const char *address, int port) {
  
    //create socket
    int socketfd=socket(AF_INET, SOCK_DGRAM, 0);
    int reuseon = 1;
    int r = -1;
  
    //bind
    struct sockaddr_in serv_addr;
    memset( &serv_addr, '\0', sizeof(serv_addr));
    serv_addr.sin_len = sizeof(struct sockaddr_in);
    serv_addr.sin_family = AF_INET;
    if (address == NULL || strlen(address) == 0 || strcmp(address, "255.255.255.255") == 0) {
        r = setsockopt(socketfd, SOL_SOCKET, SO_BROADCAST, &reuseon, sizeof(reuseon));
        serv_addr.sin_port = htons(port);
        serv_addr.sin_addr.s_addr = htonl(INADDR_ANY);
    } else {
        r = setsockopt(socketfd, SOL_SOCKET, SO_REUSEADDR, &reuseon, sizeof(reuseon));
        serv_addr.sin_addr.s_addr = inet_addr(address);
        serv_addr.sin_port = htons(port);
    }
  
    if (r == -1) {
       return -1;
    }
  
    r = bind(socketfd, (struct sockaddr *) &serv_addr, sizeof(serv_addr));
    if (r == 0) {
        return socketfd;
    } else {
        return -1;
    }
}

int c_udp_socket_recive(int socket_fd, char *outdata, int expted_len, char *remoteip, int *remoteport) {
    struct sockaddr_in cli_addr;
    socklen_t clilen = sizeof(cli_addr);
    memset(&cli_addr, 0x0, sizeof(struct sockaddr_in));
    int len = (int)recvfrom(socket_fd, outdata, expted_len, 0, (struct sockaddr *)&cli_addr, &clilen);
    char *clientip = inet_ntoa(cli_addr.sin_addr);
    memcpy(remoteip, clientip, strlen(clientip));
    *remoteport = cli_addr.sin_port;
  
    return len;
}

int c_udp_socket_close(int socket_fd) {
    return close(socket_fd);
}

//return socket fd
int c_udp_socket_client() {
    //create socket
    int socketfd = socket(AF_INET, SOCK_DGRAM, 0);
    int reuseon = 1;
    setsockopt(socketfd, SOL_SOCKET, SO_REUSEADDR, &reuseon, sizeof(reuseon));
  
    return socketfd;
}

//enable broadcast
void enable_broadcast(int socket_fd) {
    int reuseon = 1;
    setsockopt(socket_fd, SOL_SOCKET, SO_BROADCAST, &reuseon, sizeof(reuseon));
}

int c_udp_socket_get_server_ip(char *host, char *ip) {
    struct hostent *hp;
    struct sockaddr_in address;
  
    hp = gethostbyname(host);
    if (hp == NULL) {
        return -1;
    }
  
    bcopy((char *)hp->h_addr, (char *)&address.sin_addr, hp->h_length);
    char *clientip = inet_ntoa(address.sin_addr);
    memcpy(ip, clientip, strlen(clientip));
  
    return 0;
}

//send message to address and port
int c_udp_socket_sentto(int socket_fd, char *msg, int len, char *toaddr, int topotr) {
    struct sockaddr_in address;
    socklen_t addrlen = sizeof(address);
    memset(&address, 0x0, sizeof(struct sockaddr_in));
    address.sin_family = AF_INET;
    address.sin_port = htons(topotr);
    address.sin_addr.s_addr = inet_addr(toaddr);
    int sendlen = (int)sendto(socket_fd, msg, len, 0, (struct sockaddr *)&address, addrlen);
  
    return sendlen;
}
