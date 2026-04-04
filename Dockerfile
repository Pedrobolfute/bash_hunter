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

# Clonar e compilar o ttyd
WORKDIR /src
RUN git clone --depth 1 https://github.com/tsl0922/ttyd.git && \
    cd ttyd && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make && \
    make install

# --- ESTÁGIO 2: EXECUÇÃO (A "Sala de Aula" Blindada) ---
FROM debian:bookworm-slim

# 1. Instalar apenas bibliotecas de runtime e ferramentas do jogo
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
    vim \
    htop \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# 2. Configurar Locale pt_BR (Essencial para ícones e menus do whiptail)
RUN sed -i -e 's/# pt_BR.UTF-8 UTF-8/pt_BR.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG=pt_BR.UTF-8
ENV LANGUAGE=pt_BR:pt
ENV LC_ALL=pt_BR.UTF-8

# 3. Trazer o binário do ttyd do estágio de compilação
COPY --from=builder /usr/local/bin/ttyd /usr/local/bin/ttyd

# 4. Configurar usuário e estrutura de pastas
RUN useradd -m -s /bin/bash jogador
WORKDIR /home/jogador/bash_hunter

# 5. Organizar e Proteger o Motor (.engine)
# Copia todo o repositório e organiza os arquivos sensíveis
COPY . .



# Executa como root para garantir que as permissões de proteção funcionem
RUN mkdir -p /home/jogador/bash_hunter/.engine && \
    mv init_game.sh /home/jogador/bash_hunter/.engine/ 2>/dev/null || true && \
    mv LICENSE /home/jogador/bash_hunter/.engine/ 2>/dev/null || true && \
    mv Dockerfile /home/jogador/bash_hunter/.engine 2>/dev/null || true && \
    mv app.py /home/jogador/bash_hunter/.engine 2>/dev/null || true && \
    mv README.md /home/jogador/bash_hunter/.engine 2>/dev/null || true && \
    mv .git /home/jogador/bash_hunter/.engine 2>/dev/null || true && \
    mv .gitignore /home/jogador/bash_hunter/.engine 2>/dev/null || true && \
    chown -R root:root /home/jogador/bash_hunter/.engine && \
    chown -R jogador:jogador /home/jogador/bash_hunter/.engine/.out && \
    # 711: Jogador pode atravessar (+x) para rodar o jogo, mas não pode dar ls (-r)
    chmod 711 /home/jogador/bash_hunter/.engine && \
    chmod +x /home/jogador/bash_hunter/.engine/init_game.sh



# 6. Permissões de escrita para as pastas de jogo do aluno
RUN chown -R jogador:jogador /home/jogador/bash_hunter/play

#7. passwd
RUN echo "jogador:arise" | chpasswd && \
  adduser jogador sudo

# 8. Configuração Final
USER jogador
EXPOSE 7681

# -o: encerra o container ao desconectar (reset total para o aluno)
CMD ["ttyd", "-o", "-p", "7681", "-W", "/home/jogador/bash_hunter/.engine/init_game.sh"]
