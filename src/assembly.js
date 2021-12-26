export const assemblyRegistry = {
    md5_hex_data: {
        title: "MD5 of Hex Data",
        gadgets: [
            {
                classId: "input.text_input",
                x: 20,
                y: 20,
            },
            {
                "classId": "change_base.hex_decode",
                x: 80,
                y: 200,
            },
            {
                "classId": "hash.md5",
                x: 20,
                y: 340,
            },
        ],
        edges: [
            {
                sourceGadget: 0,
                sourcePort: 0,
                destGadget: 1,
                destPort: 0,
            },
            {
                sourceGadget: 1,
                sourcePort: 0,
                destGadget: 2,
                destPort: 0,
            },
        ],
    },
    triple_hash: {
        title: "Triple Hash",
        gadgets: [
            {
                classId: "input.text_input",
                x: 20,
                y: 20,
            },
            {
                "classId": "hash.md5",
                x: 140,
                y: 200,
            },
            {
                "classId": "hash.sha-1",
                x: 80,
                y: 320,
            },
            {
                "classId": "hash.sha-2",
                x: 20,
                y: 440,
            },
        ],
        edges: [
            {
                sourceGadget: 0,
                sourcePort: 0,
                destGadget: 1,
                destPort: 0,
            },
            {
                sourceGadget: 0,
                sourcePort: 0,
                destGadget: 2,
                destPort: 0,
            },
            {
                sourceGadget: 0,
                sourcePort: 0,
                destGadget: 3,
                destPort: 0,
            },
        ],
    },
}
