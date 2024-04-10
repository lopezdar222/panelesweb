/*const sideMenu = document.querySelector("aside");
const menuBtn = document.querySelector("#menu-btn");
const closeBtn = document.querySelector("#close-btn");

menuBtn.addEventListener('click', () => {
	sideMenu.style.display = 'block';
})

closeBtn.addEventListener('click', () => {
	sideMenu.style.display = 'value';
})
*/


// Active button
const sideA = document.querySelectorAll('.sidebar a');

	sideA.forEach(a => {
		a.onclick = function() {
		//active
		sideA.forEach(a => {
			a.className = "";
		})
		a.className = "active";
		}
	})





// Change theme
const themeToggler = document.querySelector(".theme-toggler")

themeToggler.addEventListener('click', () => {
	document.body.classList.toggle('dark-theme-variables');

	//themeToggler.querySelector('span').classList.toggle('active');
	themeToggler.querySelector('span:nth-child(1)').classList.toggle('active');
	themeToggler.querySelector('span:nth-child(2)').classList.toggle('active');
})



// Close Menu button
const body = document.querySelector("body"),
	aside = body.querySelector("aside"),
		toggle = body.querySelector(".toggle");

		toggle.addEventListener("click", () => {
			aside.classList.toggle("close");
		});

