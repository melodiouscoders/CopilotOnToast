import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

export default defineConfig({
  site: 'https://melodiouscoders.github.io/CopilotOnToast',
  base: '/CopilotOnToast',
  integrations: [
    starlight({
      title: 'CopilotOnToast 🍞',
      description: 'Desktop toast notifications for GitHub Copilot CLI — get notified when your agent finishes, needs approval, hits an error, and more.',
      social: [
        { icon: 'github', label: 'GitHub', href: 'https://github.com/melodiouscoders/CopilotOnToast' },
      ],
      editLink: {
        baseUrl: 'https://github.com/melodiouscoders/CopilotOnToast/edit/main/docs/',
      },
      sidebar: [
        { label: 'Getting Started', slug: 'getting-started' },
        {
          label: 'Guides',
          items: [
            { label: 'Configuration', slug: 'guides/configuration' },
          ],
        },
        {
          label: 'Reference',
          items: [
            { label: 'Events', slug: 'reference/events' },
          ],
        },
      ],
      head: [
        {
          tag: 'meta',
          attrs: { property: 'og:image', content: 'https://raw.githubusercontent.com/melodiouscoders/CopilotOnToast/main/.github/hooks/copilot-icon.png' },
        },
      ],
    }),
  ],
});
