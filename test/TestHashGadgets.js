import assert from 'assert';
import {
    convertBufferToWordArray,
    convertWordArrayToBuffer,
    Md5Gadget,
    Sha1Gadget,
    Sha2Gadget,
} from '../src/gadgets/HashGadgets.js';

describe('Hash Gadgets', function () {
    describe('conversion', function () {
        it('should convert word array to byte array', function () {
            let wordArray = { words: [0x11223344, 0x55667788], sigBytes: 8 }
            let expected = Buffer.from([0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88]);
            assert.deepEqual(convertWordArrayToBuffer(wordArray), expected);
        });

        it('should convert byte array to word array', function () {
            let wordArray = convertBufferToWordArray([0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88]);
            let expected = [0x11223344, 0x55667788];
            assert.equal(wordArray.sigBytes, 8);
            assert.deepEqual(wordArray.words, expected);
        });
    });

    describe('Md5Gadget', function () {
        it('should MD5 hash "ABCD"', function () {
            let gadget = new Md5Gadget(0, 0);
            let display;
            let out;

            gadget.display.subscribe((d) => display = d);
            gadget.outputPorts[0].store.subscribe((o) => out = o);
            gadget.inputPorts[0].value = Buffer.from("ABCD", "ascii");
            gadget.transform();

            assert.equal(display.text, "cb08ca4a7bb5f9683c19133a84872ca7");
            assert.deepEqual(Buffer.from([0xcb, 0x08, 0xca, 0x4a, 0x7b, 0xb5,
                0xf9, 0x68, 0x3c, 0x19, 0x13, 0x3a, 0x84, 0x87, 0x2c, 0xa7]), out);
        });
    });

    describe('Sha1Gadget', function () {
        it('should SHA1 hash "ABCD"', function () {
            let gadget = new Sha1Gadget(0, 0);
            let display;
            let out;

            gadget.display.subscribe((d) => display = d);
            gadget.outputPorts[0].store.subscribe((o) => out = o);
            gadget.inputPorts[0].value = Buffer.from("ABCD", "ascii");
            gadget.transform();

            assert.equal(display.text, "fb2f85c88567f3c8ce9b799c7c54642d0c7b41f6");
            assert.deepEqual(Buffer.from([0xfb, 0x2f, 0x85, 0xc8, 0x85, 0x67, 0xf3,
                0xc8, 0xce, 0x9b, 0x79, 0x9c, 0x7c, 0x54, 0x64, 0x2d, 0x0c, 0x7b, 0x41,
                0xf6]), out);
        });
    });

    describe('Sha2Gadget', function () {
        it('should SHA2 hash "ABCD"', function () {
            let gadget = new Sha2Gadget(0, 0);
            let display;
            let out;

            gadget.display.subscribe((d) => display = d);
            gadget.outputPorts[0].store.subscribe((o) => out = o);
            gadget.inputPorts[0].value = Buffer.from("ABCD", "ascii");
            gadget.transform();

            assert.equal(display.text, "e12e115acf4552b2568b55e93cbd39394c4ef81c82447fafc997882a02d23677");
            assert.deepEqual(Buffer.from([0xe1, 0x2e, 0x11, 0x5a, 0xcf, 0x45, 0x52,
                0xb2, 0x56, 0x8b, 0x55, 0xe9, 0x3c, 0xbd, 0x39, 0x39, 0x4c, 0x4e, 0xf8,
                0x1c, 0x82, 0x44, 0x7f, 0xaf, 0xc9, 0x97, 0x88, 0x2a, 0x02, 0xd2, 0x36,
                0x77]), out);
        });
    });
});
