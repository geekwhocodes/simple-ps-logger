const versions = require("./versions.json");
console.log(versions);
const allDocHomesPaths = [
  "/docs/",
  "/docs/next/",
  ...versions.slice(1).map((version) => `/docs/${version}/`),
];

module.exports = {
  title: "Simple PS Logger",
  tagline: "Simple Powershell Logging Module",
  url: "https://simple-ps-logger.netlify.app/",
  baseUrl: "/",
  favicon: "img/favicon.ico",
  organizationName: "geekwhocodes", // Usually your GitHub org/user name.
  projectName: "simple-ps-logger-docs", // Usually your repo name.
  customFields: {
    description: "Simple Powershell Logging Module",
  },
  plugins: [
    [
      "@docusaurus/plugin-client-redirects",
      {
        fromExtensions: ["html"],
        createRedirects: function (path) {
          // redirect to /docs from /docs/introduction,
          // as introduction has been made the home doc
          if (allDocHomesPaths.includes(path)) {
            return [`${path}/introduction`];
          }
        },
      },
    ],
    [
      "@docusaurus/plugin-ideal-image",
      {
        quality: 70,
        max: 1030, // max resized image's size.
        min: 640, // min resized image's size. if original is lower, use that size.
        steps: 2, // the max number of images generated between min and max (inclusive)
      },
    ],
  ],
  themeConfig: {
    colorMode: {
      defaultMode: "light",
      disableSwitch: false,
      respectPrefersColorScheme: true,
    },
    navbar: {
      hideOnScroll: true,
      title: "Simple PS Logger",
      logo: {
        alt: "Simple PS Logger Logo",
        src: "img/logo.svg",
        srcDark: "img/logo.svg",
      },
      links: [
        {
          label: "Docs",
          to: "docs",
          position: "right",
          items: [
            {
              label: versions[0],
              to: "docs/",
              activeBaseRegex: `docs/(?!${versions.join("|")}|next)`,
            },
            ...versions.slice(1).map((version) => ({
              label: version,
              to: `docs/${version}/`,
            })),
            {
              label: "Master/Unreleased",
              to: "docs/next/",
            },
          ],
        },
        {
          href: "https://github.com/geekwhocodes/simple-ps-logger",
          position: "right",
          className: "header-github-link",
          "aria-label": "GitHub repository",
        },
      ],
    },

    // image: "img/logo.",
    // gtag: {
    //   trackingID: "",
    // },
    // algolia: {
    //   apiKey: "",
    //   indexName: "",
    //   algoliaOptions: {},
    // },
    prism: {
      additionalLanguages: ["powershell"],
      theme: require("prism-react-renderer/themes/vsDark"),
      // darkTheme: require("prism-react-renderer/themes/dracula"),
    },
    footer: {
      style: "dark",
      logo: {
        alt: "SimplePSLogger Logo",
        src: "/img/logo.svg",
      },
      links: [
        {
          title: "Learn",
          items: [
            {
              label: "Introduction",
              to: "docs/",
            },
            {
              label: "Getting Started",
              to: "docs/quick-start",
            },
          ],
        },
        {
          title: "More",
          items: [
            {
              label: "Releases",
              to: "https://github.com/geekwhocodes/simple-ps-logger/releases",
            },
            {
              label: "CI-CD",
              to: "https://dev.azure.com/geekwhocodes/simple-ps-logger",
            },
          ],
        },
        {
          title: "Legal",
          items: [
            {
              label: "License",
              to:
                "https://github.com/geekwhocodes/simple-ps-logger/blob/master/LICENSE",
            },
          ],
        },
      ],
      copyright: `Copyright © ${new Date().getFullYear()} <a href="https://github.com/geekwhocodes" rel="noopener noreferrer">Ganesh Raskar</a>.  Built with Docusaurus`,
    },
  },
  presets: [
    [
      "@docusaurus/preset-classic",
      {
        docs: {
          path: "docs",
          // It is recommended to set document id as docs home page (`docs/` path).
          homePageId: "introduction",
          sidebarPath: require.resolve("./sidebars.js"),
          // Please change this to your repo.
          editUrl:
            "https://github.com/geekwhocodes/simple-ps-logger/edit/master/website",
          showLastUpdateAuthor: true,
          showLastUpdateTime: true,
        },
        blog: {
          showReadingTime: true,
          // Please change this to your repo.
          editUrl:
            "https://github.com/geekwhocodes/simple-ps-logger/edit/master/website/blog",
        },
        theme: {
          customCss: require.resolve("./src/css/custom.css"),
        },
      },
    ],
  ],
};
