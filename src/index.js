import { parse, SyntaxError } from "./dbn";

const code = document.getElementById('code');
code.innerHTML = `paper 100
pen 10
line 0 0 100 100
pen 10
line 100 0 1 100`;

const output = document.getElementById('output');

code.addEventListener('keyup', function () {
    console.log("Code:", code.value);

    try {
        output.innerHTML = '';
        const program = parse(code.value);
        console.log("Parsed:", program);
        program();
    }
    catch (e) {
        output.innerHTML = e;
    }
});
