    console.log("dentro script sound")
        let audioCtx = null;

        function initAudio() {
            if (!audioCtx) {
                audioCtx = new (window.AudioContext || window.webkitAudioContext)();
            }
            if (audioCtx.state === 'suspended') {
                audioCtx.resume();
            }
        }

        function playKeySound() {
            // Se o contexto não foi criado ou o navegador bloqueou, ignora para não dar erro no console
            if (!audioCtx || audioCtx.state === 'suspended') return;

            const osc = audioCtx.createOscillator();
            const gainNode = audioCtx.createGain();

            osc.connect(gainNode);
            gainNode.connect(audioCtx.destination);

            osc.type = 'triangle'; 
            
            // Tom de clique mecânico estalado com variação sutil
            const frequency = 500 + Math.random() * 120; 
            osc.frequency.setValueAtTime(frequency, audioCtx.currentTime);

            // Volume e tempo de decaimento curtíssimo (estalo seco)
            gainNode.gain.setValueAtTime(0.15, audioCtx.currentTime); 
            gainNode.gain.exponentialRampToValueAtTime(0.00001, audioCtx.currentTime + 0.03);

            osc.start(audioCtx.currentTime);
            osc.stop(audioCtx.currentTime + 0.03);
        }

        // CORREÇÃO: Destrava o áudio no primeiro clique do mouse na tela
        window.addEventListener('click', initAudio, { once: true });

        // Escuta o teclado e garante a inicialização do áudio caso o usuário use o TAB ou digite direto
        window.addEventListener('keydown', function(e) {
            initAudio(); // Força o resume a cada interação por segurança

            if (e.key !== 'Shift' && e.key !== 'Control' && e.key !== 'Alt') {
                playKeySound();
            }
        });