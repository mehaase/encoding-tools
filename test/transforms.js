import assert from 'assert';
import {
    HexDecodeGadget,
    HexEncodeGadget
} from '../src/gadgets/ChangeBaseGadgets.js';

describe('Change Base Gadgets', function () {
    describe('HexEncoderGadget', function () {
        it('should convert string to hex', function () {
            let gadget = new HexEncodeGadget(0, 0);
            let display;
            let out;

            gadget.display.subscribe((d) => display = d);
            gadget.outputPorts[0].store.subscribe((o) => out = o);
            gadget.inputPorts[0].value = Buffer.from("ABCD", "ascii");
            gadget.transform();

            assert.equal(display.text, "41424344");
            assert.deepEqual(out, Buffer.from([0x34, 0x31, 0x34, 0x32, 0x34, 0x33, 0x34, 0x34]));
        });
    });

    describe('HexDecoderGadget', function () {
        it('should convert hex to string', function () {
            let gadget = new HexDecodeGadget(0, 0);
            let display;
            let out;

            gadget.display.subscribe((d) => display = d);
            gadget.outputPorts[0].store.subscribe((o) => out = o);
            // Input: ABCD
            gadget.inputPorts[0].value = Buffer.from([0x34, 0x31, 0x34, 0x32, 0x34, 0x33, 0x34, 0x34]);
            gadget.transform();

            assert.equal(display.text, "ABCD");
            assert.deepEqual(out, Buffer.from([0x41, 0x42, 0x43, 0x44]));
        });
    });
});
