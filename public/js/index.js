// En este archivo puedes poner el código del frontend, como el manejo de eventos y la interacción con la interfaz de usuario.
// Ten en cuenta que este archivo se ejecutará en el navegador del usuario, no en el servidor.
// Por lo tanto, no contendrá configuraciones de servidor o interacciones con bases de datos directamente.
document.addEventListener('DOMContentLoaded', () => {
    const loginForm = document.getElementById('loginform');
    const messageDiv = document.getElementById('message');

    // Manejar el inicio de sesión
    loginForm.addEventListener('submit', async (event) => {
        event.preventDefault();
        const username = document.getElementById('loginusername').value;
        const password = document.getElementById('loginpassword').value;
        const version = 'web';
        const ipAddress = await fetch('https://api64.ipify.org?format=json')
        .then(response => response.json())
        .then(data => {
            return data.ip;
        })
        .catch(error => {
            return '0.0.0.0';
        });

        try {
            if (username != '' & password != '') {
                const response = await fetch('/login', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({ username, password, version, ipAddress })
                });

                const data = await response.json();

                if (data.message === 'ok') {
                    // Construir la URL con parámetros de consulta
                    //req.session.id_rol = data.id_rol;
                    //req.session.id_usuario = data.id_usuario;
                    //console.log('llamado a principal');
                    const url = `./html/principal.html?id_usuario=${encodeURIComponent(data.id_usuario)}&usuario=${username}&id_token=${encodeURIComponent(data.id_token)}`;
                    // Redirigir a la nueva URL
                    window.location.href = url;
                } else {
                    showMessage(data.message);
                }
            }
        } catch (error) {
            console.error('Error en el inicio de sesión:', error);
            showMessage('Error en el inicio de sesión.');
        }
    });

    // Mostrar mensajes en el div de mensajes
    function showMessage(message) {
        messageDiv.textContent = message;
    }
});