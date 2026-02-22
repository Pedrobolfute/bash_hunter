# --- ESTÁGIO 1: COMPILAÇÃO (O "Canteiro de Obras") ---
FROM debian:bookworm-slim AS builder

# Instalar ferramentas de compilação
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    libjson-c-dev \
    libwebsockets-dev \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Clonar e compilar o ttyd exatamente como você fez
WORKDIR /src
RUN git clone https://github.com/tsl0922/ttyd.git && \
    cd ttyd && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make && \
    make install


# --- ESTÁGIO 2: EXECUÇÃO (A "Sala de Aula" Limpa) ---
FROM debian:bookworm-slim

# Instalar apenas as bibliotecas necessárias para o ttyd rodar (runtime)
# e ferramentas para o seu jogo
RUN apt-get update && apt-get install -y \
    locales \
    bash \
    coreutils \
    procps \
    libjson-c5 \
    libwebsockets1* \
    libwebsockets-evlib-uv \
    libuv1 \
    libssl3 \
    whiptail \
    && rm -rf /var/lib/apt/lists/*

RUN sed -i -e 's/# pt_BR.UTF-8 UTF-8/pt_BR.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen

ENV LANG pt_BR.UTF-8
ENV LANGUAGE pt_BR:pt
ENV LC_ALL pt_BR.UTF-8

# Copiar APENAS o executável do ttyd que compilamos no estágio anterior
COPY --from=builder /usr/local/bin/ttyd /usr/local/bin/ttyd

# Configuração do usuário e jogo (como fizemos antes)
RUN useradd -m -s /bin/bash jogador
WORKDIR /home/jogador/bash_hunter

# Copia o seu repositório do jogo
COPY --chown=jogador:jogador . .

# Permissões
RUN chmod +x init_game.sh play/room_01/carregar_cenario_01.sh

USER jogador
EXPOSE 7681

# Iniciar o jogo
CMD ["ttyd", "-once", "-t", "1", "-p", "7681", "-W", "/home/jogador/bash_hunter/init_game.sh"]
