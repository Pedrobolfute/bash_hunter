        const OriginalWebSocket = window.WebSocket;
        window.WebSocket = function(url, protocols){
            const ws = new OriginalWebSocket(url, protocols);
            ws.addEventListener("error", function(e){
                e.preventDefault();     
            });
            return ws;
        };

        window.addEventListener("unhandledrejection", function(event){
            if(event.reason && event.reason.message && event.reason.message.includes("not valid JSON")){
                event.preventDefault();
            }       
        });

        window.addEventListener("beforeunload", function(e){
            window.location.href = "http://bashhunter.com.br/";     
        });

        const observar = new MutationObserver((mutations) => {
            if(document.body.innerText.includes("Press ⏎ to Reconnect") || document.body.innerText.includes("Press ↵ to Reconnect") || document.querySelector(".xterm-overlay")){
                observar.disconnect();
                console.log("Redirecionando em 3 segundos para página inicial.");
                setTimeout(() => {
                    window.location.href = "http://bashhunter.com.br/"; 
                }, 3000);
            }
        });

        window.addEventListener("DOMContentLoaded", () => {
            observar.observe(document.body, { childList: true, subtree: true });     
        });