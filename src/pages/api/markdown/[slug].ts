import type { APIContext, GetStaticPaths } from 'astro';
import { getCollection } from 'astro:content';
import { site } from '@/config/site';

export const getStaticPaths: GetStaticPaths = async () => {
  const blog = await getCollection('blog');

  return blog.map((post) => ({
    params: { slug: post.id.replace('.md', '') },
  }));
};

export async function GET({ params }: APIContext) {
  const slug = params.slug;
  if (!slug) {
    return new Response('Missing slug parameter', { status: 400 });
  }

  const blog = await getCollection('blog');
  const post = blog.find((item) => item.id.replace('.md', '') === slug);

  if (!post) {
    return new Response('Post not found', { status: 404 });
  }

  const yamlString = (value: string) => JSON.stringify(value);
  const yamlArray = (values: string[]) =>
    `[${values.map((value) => JSON.stringify(value)).join(', ')}]`;

  const postUrl = `${site.url}/blog/${slug}/`;
  const tags = post.data.tags || [];
  const tagsText = tags.length > 0 ? tags.join(', ') : 'None';

  const markdown = `---
title: ${yamlString(post.data.title)}
author: ${yamlString(site.author)}
published: ${yamlString(post.data.pubDate.toISOString())}
updated: ${yamlString(post.data.updatedDate?.toISOString() || post.data.pubDate.toISOString())}
category: ${yamlString(post.data.category)}
tags: ${yamlArray(tags)}
url: ${yamlString(postUrl)}
license: ${yamlString('CC-BY-4.0')}
---

# ${post.data.title}

${post.data.description}

**Category:** ${post.data.category}  
**Tags:** ${tagsText}  
**Published:** ${post.data.pubDate.toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
  })}

---

${post.body}

---

**Source:** Steve Rose  
**URL:** ${postUrl}  
**License:** CC-BY-4.0 - Attribution Required
`;

  return new Response(markdown, {
    headers: {
      'Content-Type': 'text/markdown; charset=utf-8',
      'Cache-Control': 'public, max-age=3600',
      'Access-Control-Allow-Origin': '*',
    },
  });
}
