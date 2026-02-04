import type { Site } from "@/types";

export const site: Site = {
    title: "Ste Rose",
    description: "Site Reliability, coffee enthusiasm, and occasional debugging of life's mysteries",
    author: "Ste Rose",
    creator: "@sterose",
    url: "http://localhost:4321",
};

export const WebsiteLinks = [
	{
		name: 'Home',
		url: '/',
	},
	{
		name: 'Blog',
		url: '/blog',
	},
	{
		name: 'Résumé',
		url: '/resume_steve_rose_2026.pdf',
	},
	{
		name: 'Now',
		url: '/now',
	},
	{
		name: 'About',
		url: '/about',
	},
]

export const SocialLinks = [
	{
		name: 'LinkedIn',
		url: 'https://www.linkedin.com/in/steroseio/',
		icon: 'mdi:linkedin',
	},
	{
		name: 'GitHub',
		url: 'https://github.com/steroseio',
		icon: 'mdi:github',
	},
	{
		name: 'X / Twitter',
		url: 'https://twitter.com/steroseio',
		icon: 'mdi:twitter',
	},
]
