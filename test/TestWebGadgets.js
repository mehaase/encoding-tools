import assert from 'assert';
import {
    UrlDecodeGadget,
    UrlEncodeGadget,
    HtmlDecodeGadget,
    HtmlEncodeGadget,
} from '../src/gadgets/WebGadgets.js';

describe('Web Gadgets', function () {
    describe('UrlEncoderGadget', function () {
        it('should URL encode "foo:bar" to "foo%3Abar"', function () {
            let gadget = new UrlEncodeGadget(0, 0);
            let display;
            let out;

            gadget.display.subscribe((d) => display = d);
            gadget.outputPorts[0].store.subscribe((o) => out = o);
            gadget.inputPorts[0].value = Buffer.from("foo:bar", "ascii");
            gadget.transform();

            assert.equal(display.text, "foo%3Abar");
            assert.deepEqual(Buffer.from([0x66, 0x6f, 0x6f, 0x25, 0x33, 0x41, 0x62, 0x61, 0x72]), out);
        });
    });

    describe('UrlDecoderGadget', function () {
        it('should URL decode "foo%3Abar" to "foo:bar"', function () {
            let gadget = new UrlDecodeGadget(0, 0);
            let display;
            let out;

            gadget.display.subscribe((d) => display = d);
            gadget.outputPorts[0].store.subscribe((o) => out = o);
            gadget.inputPorts[0].value = Buffer.from([0x66, 0x6f, 0x6f, 0x25, 0x33, 0x41, 0x62, 0x61, 0x72]);
            gadget.transform();

            assert.equal(display.text, "foo:bar");
            assert.deepEqual(Buffer.from(Buffer.from([0x66, 0x6f, 0x6f, 0x3A, 0x62, 0x61, 0x72])), out);
        });
    });

    describe('HtmlEncoderGadget', function () {
        it('should HTML encode "foo&bar" to "foo&amp;bar"', function () {
            let gadget = new HtmlEncodeGadget(0, 0);
            let display;
            let out;

            gadget.display.subscribe((d) => display = d);
            gadget.outputPorts[0].store.subscribe((o) => out = o);
            gadget.inputPorts[0].value = Buffer.from("foo&bar", "ascii");
            gadget.transform();

            assert.equal(display.text, "foo&amp;bar");
            assert.deepEqual(Buffer.from([0x66, 0x6f, 0x6f, 0x26, 0x61, 0x6d, 0x70, 0x3b, 0x62, 0x61, 0x72]), out);
        });
    });

    describe('HtmlDecoderGadget', function () {
        it('should HTML decode "foo&amp;bar" to "foo&bar"', function () {
            let gadget = new HtmlDecodeGadget(0, 0);
            let display;
            let out;

            gadget.display.subscribe((d) => display = d);
            gadget.outputPorts[0].store.subscribe((o) => out = o);
            gadget.inputPorts[0].value = Buffer.from([0x66, 0x6f, 0x6f, 0x26, 0x61, 0x6d, 0x70, 0x3b, 0x62, 0x61, 0x72]);
            gadget.transform();

            assert.equal(display.text, "foo&bar");
            assert.deepEqual(Buffer.from([0x66, 0x6f, 0x6f, 0x26, 0x62, 0x61, 0x72]), out);
        });
    });
});
