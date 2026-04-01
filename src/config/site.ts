import type { Site } from "@/types";

const configuredSiteUrl = (
	import.meta.env.PUBLIC_SITE_URL ??
	import.meta.env.SITE_URL ??
	'https://www.sterose.io'
).replace(/\/$/, '');

export const site: Site = {
    title: "Steve Rose",
    description: "Site Reliability, coffee enthusiasm, and occasional debugging of life's mysteries",
    author: "Steve Rose",
    creator: "@sterose",
    url: configuredSiteUrl,
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
		url: '/_steve_rose_resume_2026.pdf',
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
