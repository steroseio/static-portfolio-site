import { execSync } from 'child_process'
import { statSync } from 'fs'

export function remarkModifiedTime() {
	return function (tree, file) {
		const filepath = file.history[0]
		let lastModified

		try {
			const result = execSync(`git log -1 --pretty="format:%cI" -- "${filepath}"`, {
				stdio: ['ignore', 'pipe', 'ignore'],
			})
			lastModified = result.toString().trim()
		} catch (error) {
			// Fall back to filesystem modified time when git history isn't available
			lastModified = statSync(filepath).mtime.toISOString()
		}

		file.data.astro.frontmatter.lastModified = lastModified
	}
}
