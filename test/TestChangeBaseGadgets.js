import assert from 'assert';
import {
    Base64DecodeGadget,
    Base64EncodeGadget,
    HexDecodeGadget,
    HexEncodeGadget,
} from '../src/gadgets/ChangeBaseGadgets.js';

describe('Change Base Gadgets', function () {
    describe('HexEncoderGadget', function () {
        it('should convert "ABCD" in bytes to hex', function () {
            let gadget = new HexEncodeGadget(0, 0);
            let display;
            let out;

            gadget.display.subscribe((d) => display = d);
            gadget.outputPorts[0].store.subscribe((o) => out = o);
            gadget.inputPorts[0].value = Buffer.from("ABCD", "ascii");
            gadget.transform();

            assert.equal(display.text, "41424344");
            assert.deepEqual(Buffer.from([0x34, 0x31, 0x34, 0x32, 0x34, 0x33, 0x34, 0x34]), out);
        });
    });

    describe('HexDecoderGadget', function () {
        it('should convert hex to "ABCD" in bytes', function () {
            let gadget = new HexDecodeGadget(0, 0);
            let display;
            let out;

            gadget.display.subscribe((d) => display = d);
            gadget.outputPorts[0].store.subscribe((o) => out = o);
            gadget.inputPorts[0].value = Buffer.from([0x34, 0x31, 0x34, 0x32, 0x34, 0x33, 0x34, 0x34]);
            gadget.transform();

            assert.equal(display.text, "ABCD");
            assert.deepEqual(Buffer.from([0x41, 0x42, 0x43, 0x44]), out);
        });
    });

    describe('Base64EncoderGadget', function () {
        it('should convert "ABCD" in bytes to base64', function () {
            let gadget = new Base64EncodeGadget(0, 0);
            let display;
            let out;

            gadget.display.subscribe((d) => display = d);
            gadget.outputPorts[0].store.subscribe((o) => out = o);
            gadget.inputPorts[0].value = Buffer.from("ABCD", "ascii");
            gadget.transform();

            assert.equal(display.text, "QUJDRA==");
            assert.deepEqual(Buffer.from([0x51, 0x55, 0x4a, 0x44, 0x52, 0x41, 0x3d, 0x3d]), out);
        });
    });

    describe('Base64DecoderGadget', function () {
        it('should convert base64 to "ABCD" in bytes', function () {
            let gadget = new Base64DecodeGadget(0, 0);
            let display;
            let out;

            gadget.display.subscribe((d) => display = d);
            gadget.outputPorts[0].store.subscribe((o) => out = o);
            gadget.inputPorts[0].value = Buffer.from([0x51, 0x55, 0x4a, 0x44, 0x52, 0x41, 0x3d, 0x3d]);
            gadget.transform();

            assert.equal(display.text, "ABCD");
            assert.deepEqual(Buffer.from([0x41, 0x42, 0x43, 0x44]), out);
        });
    });
});

