window.addEventListener('load', function() {
	main.$mount('main');
});

const main = new Vue ({
	delimiters: ['\\(', ')'],
	data() {
		return {
			message: 'hello',
		};
	},
	methods: {
		changeMessage(e) {
			this.message = e.target.value;
		},
	},
});
