import { spawnSync } from 'child_process'
import { statSync } from 'fs'

const cache = new Map()

export function remarkModifiedTime() {
	return function (tree, file) {
		const filepath = file.history[0]

		if (cache.has(filepath)) {
			file.data.astro.frontmatter.lastModified = cache.get(filepath)
			return
		}

		let lastModified

		try {
			const result = spawnSync('git', ['log', '-1', '--pretty=format:%cI', '--', filepath], {
				encoding: 'utf8',
			})
			lastModified = result.stdout.trim() || statSync(filepath).mtime.toISOString()
		} catch {
			// Fall back to filesystem modified time when git history isn't available
			lastModified = statSync(filepath).mtime.toISOString()
		}

		cache.set(filepath, lastModified)
		file.data.astro.frontmatter.lastModified = lastModified
	}
}
