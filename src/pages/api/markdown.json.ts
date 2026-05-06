import type { APIContext } from 'astro';
import { getCollection } from 'astro:content';

export async function GET(_context: APIContext) {
  const blog = await getCollection('blog');
  const slugs = blog.map((post) => post.id.replace('.md', ''));

  return new Response(
    JSON.stringify(
      {
        message: 'Use the path-based markdown endpoint for static hosting compatibility.',
        endpointTemplate: '/api/markdown/{slug}',
        examples: slugs.slice(0, 5).map((slug) => `/api/markdown/${slug}`),
      },
      null,
      2,
    ),
    {
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Cache-Control': 'public, max-age=86400',
        'Access-Control-Allow-Origin': '*',
      },
    },
  );
}
