import { createWriteStream, write } from "fs";
import { SitemapStream } from "sitemap";
import gadgetRegistry from "./gadgets/GadgetRegistry.js"
import { assemblyRegistry } from "./assembly.js";

const links = [];

// Add gadgets.
for (let gadget of gadgetRegistry.list()) {
    links.push({
        url: `#gadget/${gadget.classId}`,
        changefreq: "yearly",
    })
}

// Add assemblies.
for (let [id, assembly] of Object.entries(assemblyRegistry)) {
    links.push({
        url: `#${id}`,
        changefreq: "yearly",
    })
}

// Write out the sitemap.
const sitemap = new SitemapStream({
    hostname: 'https://encoding.tools',
    xmlns: {
        news: false,
        xhtml: false,
        image: false,
        video: false,
    }
})

const writeStream = createWriteStream("./public/build/sitemap.xml");
sitemap.pipe(writeStream);

for (let link of links) {
    sitemap.write(link);
}

sitemap.end();
