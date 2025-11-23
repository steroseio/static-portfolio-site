import type { Site } from "@/types";

export const site: Site = {
    title: "Ste Rose",
    description: "Site Reliability, coffee enthusiasm, and occasional debugger of life's mysteries",
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
		name: 'Projects',
		url: '/projects',
	},
	{
		name: 'Hire Me',
		url: '/hire',
	},
	{
		name: 'Uses',
		url: '/uses',
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
        name: 'GitHub',
        url: 'https://github.com/steroseio',
        icon: 'mdi:github',
    },
    {
        name: 'LinkedIn',
        url: 'https://www.linkedin.com/in/steroseio/',
        icon: 'mdi:linkedin',
    },
    {
        name: 'X / Twitter',
        url: 'https://twitter.com/steroseio',
        icon: 'mdi:twitter',
    },
    {
        name: 'Mastodon',
        url: 'https://mastodon.social/@steroseio',
        icon: 'mdi:mastodon',
    },
]
