/**
 * Return a URL slug for the given text.
 * @param {String} text
 * @returns String
 */
export default function slug(text) {
    return text.toLocaleLowerCase().replace(/ /g, "_");
}
