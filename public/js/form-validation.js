const userNameField = document.querySelector("[name=username]");
const passwordField = document.querySelector("[name=password]");

/*console.log(userNameField, passwordField);*/

const validateEmptyField = (message, e) => {
	/*console.log("Saliste del campo Nombre")*/
	/*console.log(e.target.value);*/
	const field = e.target;
	const fieldValue = e.target.value;
	if (fieldValue.trim().length == 0) {
		/*No funciona por error autocompletado
		console.log("Escribi el nombre de Usuario");*/
		field.classList.add("invalid");
		field.previousElementSibling.classList.add("error");
		field.previousElementSibling.innerText = message;
	} else {
		field.classList.remove("invalid");
		field.previousElementSibling.classList.remove("error");
		field.previousElementSibling.innerText = "";
	}
}

userNameField.addEventListener("blur", (e) => validateEmptyField('Usuario requerido', e));
passwordField.addEventListener("blur", (e) => validateEmptyField('Contraseña requerida', e));
