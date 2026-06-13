async function requisitarJogo() {
  const btn = document.getElementById('action-button');
  const statusMsg = document.getElementById('status-msg');

  btn.disabled = true;
  statusMsg.innerHTML = `
                <div style="color: #58a6ff;">
                    <span class="load-spinner"></span> Conectando ao porteiro e isolando container...
                </div>
            `;

  try {
    const resposta = await fetch('/spawn', { method: 'POST' });

    if (resposta.status === 503) {
      statusMsg.innerHTML = '<span style="color: #f85149;">❌ Servidor lotado (Máximo de 100 jogadores atingido).</span>';
      btn.disabled = false;
      return;
    }

    const dados = await resposta.json();

    if (dados.success) {
      statusMsg.innerHTML = '<span style="color: #56d364;">✓ Sucesso! Redirecionando para o Jogo...</span>';

      setTimeout(() => {
        window.location.href = dados.url;
      }, 1000);
    } else {
      statusMsg.innerHTML = `<span style="color: #f85149;">❌ Falha no sistema: ${dados.error}</span>`;
      btn.disabled = false;
    }

  } catch (erro) {
    statusMsg.innerHTML = '<span style="color: #f85149;">❌ Erro crítico: Não foi possível estabelecer conexão com o porteiro.</span>';
    btn.disabled = false;
  }
}