import { parse, SyntaxError } from "./dbn";

const code = document.getElementById('code');
code.addEventListener('keyup', function () {
    console.log("Code:", code.value);

    const parsed = parse(code.value);
    console.log("Parsed:", parsed);    
});
