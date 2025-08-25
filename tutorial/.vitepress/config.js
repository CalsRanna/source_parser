import { defineConfig } from 'vitepress'

export default defineConfig({
  title: "元夕 - 书源编写教程",
  description: "元夕书源编写指南",
  base: "/",
  head: [
    ['link', { rel: 'icon', href: '/favicon.ico' }]
  ],
  themeConfig: {
    logo: '/logo.png',
    nav: [
      { text: '首页', link: '/' },
      { text: '指南', link: '/guide/' }
    ],
    sidebar: [
      {
        text: '入门指南',
        items: [
          { text: '介绍', link: '/guide/' },
          { text: '基本概念', link: '/guide/basic-concepts' },
          { text: '实践', link: '/guide/practical' }
        ]
      },
      {
        text: '核心功能',
        items: [
          { text: '搜索规则', link: '/guide/search-rules' },
          { text: '信息规则', link: '/guide/information-rules' },
          { text: '目录规则', link: '/guide/catalogue-rules' },
          { text: '内容规则', link: '/guide/content-rules' }
        ]
      },
      {
        text: '高级功能',
        items: [
          { text: '探索规则', link: '/guide/explore-rules' }
        ]
      },
      {
        text: '高级技巧',
        items: [
          { text: '高级技巧', link: '/guide/advanced' }
        ]
      }
    ],
    socialLinks: [
      { icon: 'github', link: 'https://github.com/CalsRanna/source_parser' }
    ],
    footer: {
      message: 'Released under the MIT License',
      copyright: 'Copyright © 2025 Cals'
    }
  }
})