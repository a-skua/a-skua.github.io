window.addEventListener('load', function() {
	footer.$mount('footer');
});

const footer = new Vue ({
	delimiters: ['\\(', ')'],
	data() {
		return {
			list: [
				{
					title: 'About',
					url: '#',
				}, {
					title: 'Link',
					url: '#',
				}, {
					title: 'This repository',
					url: 'https://github.com/19700101000000/19700101000000.github.io',
				},
			],
			create_year: '2018',
		};
	},
	methods: {
	},
});
