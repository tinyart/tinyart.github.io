!function(t){var e={};function n(r){if(e[r])return e[r].exports;var o=e[r]={i:r,l:!1,exports:{}};return t[r].call(o.exports,o,o.exports,n),o.l=!0,o.exports}n.m=t,n.c=e,n.d=function(t,e,r){n.o(t,e)||Object.defineProperty(t,e,{enumerable:!0,get:r})},n.r=function(t){"undefined"!=typeof Symbol&&Symbol.toStringTag&&Object.defineProperty(t,Symbol.toStringTag,{value:"Module"}),Object.defineProperty(t,"__esModule",{value:!0})},n.t=function(t,e){if(1&e&&(t=n(t)),8&e)return t;if(4&e&&"object"==typeof t&&t&&t.__esModule)return t;var r=Object.create(null);if(n.r(r),Object.defineProperty(r,"default",{enumerable:!0,value:t}),2&e&&"string"!=typeof t)for(var o in t)n.d(r,o,function(e){return t[e]}.bind(null,o));return r},n.n=function(t){var e=t&&t.__esModule?function(){return t.default}:function(){return t};return n.d(e,"a",e),e},n.o=function(t,e){return Object.prototype.hasOwnProperty.call(t,e)},n.p="",n(n.s=1)}([function(t,e,n){"use strict";function r(t,e,n,o){this.message=t,this.expected=e,this.found=n,this.location=o,this.name="SyntaxError","function"==typeof Error.captureStackTrace&&Error.captureStackTrace(this,r)}!function(t,e){function n(){this.constructor=t}n.prototype=e.prototype,t.prototype=new n}(r,Error),r.buildMessage=function(t,e){var n={literal:function(t){return'"'+o(t.text)+'"'},class:function(t){var e,n="";for(e=0;e<t.parts.length;e++)n+=t.parts[e]instanceof Array?c(t.parts[e][0])+"-"+c(t.parts[e][1]):c(t.parts[e]);return"["+(t.inverted?"^":"")+n+"]"},any:function(t){return"any character"},end:function(t){return"end of input"},other:function(t){return t.description}};function r(t){return t.charCodeAt(0).toString(16).toUpperCase()}function o(t){return t.replace(/\\/g,"\\\\").replace(/"/g,'\\"').replace(/\0/g,"\\0").replace(/\t/g,"\\t").replace(/\n/g,"\\n").replace(/\r/g,"\\r").replace(/[\x00-\x0F]/g,(function(t){return"\\x0"+r(t)})).replace(/[\x10-\x1F\x7F-\x9F]/g,(function(t){return"\\x"+r(t)}))}function c(t){return t.replace(/\\/g,"\\\\").replace(/\]/g,"\\]").replace(/\^/g,"\\^").replace(/-/g,"\\-").replace(/\0/g,"\\0").replace(/\t/g,"\\t").replace(/\n/g,"\\n").replace(/\r/g,"\\r").replace(/[\x00-\x0F]/g,(function(t){return"\\x0"+r(t)})).replace(/[\x10-\x1F\x7F-\x9F]/g,(function(t){return"\\x"+r(t)}))}return"Expected "+function(t){var e,r,o,c=new Array(t.length);for(e=0;e<t.length;e++)c[e]=(o=t[e],n[o.type](o));if(c.sort(),c.length>0){for(e=1,r=1;e<c.length;e++)c[e-1]!==c[e]&&(c[r]=c[e],r++);c.length=r}switch(c.length){case 1:return c[0];case 2:return c[0]+" or "+c[1];default:return c.slice(0,-1).join(", ")+", or "+c[c.length-1]}}(t)+" but "+function(t){return t?'"'+o(t)+'"':"end of input"}(e)+" found."},t.exports={SyntaxError:r,parse:function(t,e){e=void 0!==e?e:{};var n,o={},c={start:G},u=G,a=H("//",!1),i=/^[^\n]/,l=$(["\n"],!0,!1),s=H("\n",!1),f=/^[0-9]/,p=$([["0","9"]],!1,!1),h=H("(",!1),d=H(")",!1),g=H("+",!1),v=H("-",!1),A=H("*",!1),y=H("/",!1),b=/^[ \t\n]/,m=$([" ","\t","\n"],!1,!1),x=H("paper",!1),C=H("pen",!1),w=H("line",!1),S=H("set",!1),_=H("[",!1),E=H("]",!1),j=H("repeat",!1),k=H("{",!1),M=H("}",!1),F=/^[_a-zA-Z]/,O=$(["_",["a","z"],["A","Z"]],!1,!1),T=/^[_a-zA-Z0-9]/,R=$(["_",["a","z"],["A","Z"],["0","9"]],!1,!1),P=0,I=0,L=[{line:1,column:1}],z=0,Z=[];if("startRule"in e){if(!(e.startRule in c))throw new Error("Can't start parsing from rule \""+e.startRule+'".');u=c[e.startRule]}function B(e,n){throw n=void 0!==n?n:W(I,P),D([U(e)],t.substring(I,P),n)}function H(t,e){return{type:"literal",text:t,ignoreCase:e}}function $(t,e,n){return{type:"class",parts:t,inverted:e,ignoreCase:n}}function U(t){return{type:"other",description:t}}function V(e){var n,r=L[e];if(r)return r;for(n=e-1;!L[n];)n--;for(r={line:(r=L[n]).line,column:r.column};n<e;)10===t.charCodeAt(n)?(r.line++,r.column=1):r.column++,n++;return L[e]=r,r}function W(t,e){var n=V(t),r=V(e);return{start:{offset:t,line:n.line,column:n.column},end:{offset:e,line:r.line,column:r.column}}}function q(t){P<z||(P>z&&(z=P,Z=[]),Z.push(t))}function D(t,e,n){return new r(r.buildMessage(t,e),t,e,n)}function G(){var t,e,n;return t=P,(e=J())!==o&&(I=t,n=e,e=function(t){nt=t,n()}),t=e}function J(){var t,e,n,r,c;return t=P,X()!==o&&(e=K())!==o&&(n=J())!==o&&X()!==o?(I=t,r=e,c=n,t=function(){r(),c()}):(P=t,t=o),t===o&&(t=P,X()!==o&&(e=K())!==o?(I=t,t=e):(P=t,t=o)),t}function K(){var e,n,r,c;if((e=function(){var e,n,r;e=P,"paper"===t.substr(P,5)?(n="paper",P+=5):(n=o,q(x));n!==o&&X()!==o&&(r=Y())!==o?(I=e,c=r,e=n=function(){nt.fillStyle=c(),nt.fillRect(0,0,100,100)}):(P=e,e=o);var c;return e}())===o&&(e=function(){var e,n,r;e=P,"pen"===t.substr(P,3)?(n="pen",P+=3):(n=o,q(C));n!==o&&X()!==o&&(r=Y())!==o?(I=e,c=r,e=n=function(){nt.strokeStyle=c()}):(P=e,e=o);var c;return e}())===o&&(e=function(){var e,n,r,c,u,a;e=P,"line"===t.substr(P,4)?(n="line",P+=4):(n=o,q(w));n!==o&&X()!==o&&(r=tt())!==o&&X()!==o&&(c=tt())!==o&&X()!==o&&(u=tt())!==o&&X()!==o&&(a=tt())!==o?(I=e,i=r,l=c,s=u,f=a,e=n=function(){nt.moveTo(i(),l()),nt.lineTo(s(),f()),nt.stroke()}):(P=e,e=o);var i,l,s,f;return e}())===o&&(e=function(){var e,n,r,c,u,a,i;e=P,"set"===t.substr(P,3)?(n="set",P+=3):(n=o,q(S));n!==o&&X()!==o&&(r=et())!==o&&X()!==o&&(c=N())!==o?(I=e,l=r,s=c,e=n=function(){rt[l]=s()}):(P=e,e=o);var l,s;e===o&&(e=P,"set"===t.substr(P,3)?(n="set",P+=3):(n=o,q(S)),n!==o&&X()!==o?(91===t.charCodeAt(P)?(r="[",P++):(r=o,q(_)),r!==o&&X()!==o&&(c=tt())!==o&&X()!==o&&(u=tt())!==o&&X()!==o?(93===t.charCodeAt(P)?(a="]",P++):(a=o,q(E)),a!==o&&X()!==o&&(i=Y())!==o?(I=e,f=c,p=u,h=i,e=n=function(){nt.fillStyle=h(),nt.fillRect(f(),p(),1,1)}):(P=e,e=o)):(P=e,e=o)):(P=e,e=o));var f,p,h;return e}())===o&&(e=function(){var e,n,r,c,u,a,i,l;e=P,"repeat"===t.substr(P,6)?(n="repeat",P+=6):(n=o,q(j));n!==o&&X()!==o&&(r=et())!==o&&X()!==o&&(c=N())!==o&&X()!==o&&(u=N())!==o&&X()!==o?(123===t.charCodeAt(P)?(a="{",P++):(a=o,q(k)),a!==o&&(i=J())!==o?(125===t.charCodeAt(P)?(l="}",P++):(l=o,q(M)),l!==o?(I=e,s=r,f=c,p=u,h=i,e=n=function(){for(rt[s]=f();rt[s]<p();rt[s]++)h()}):(P=e,e=o)):(P=e,e=o)):(P=e,e=o);var s,f,p,h;return e}())===o)if(e=P,"//"===t.substr(P,2)?(n="//",P+=2):(n=o,q(a)),n!==o){for(r=[],i.test(t.charAt(P))?(c=t.charAt(P),P++):(c=o,q(l));c!==o;)r.push(c),i.test(t.charAt(P))?(c=t.charAt(P),P++):(c=o,q(l));r!==o?(10===t.charCodeAt(P)?(c="\n",P++):(c=o,q(s)),c!==o?(I=e,e=n=function(){}):(P=e,e=o)):(P=e,e=o)}else P=e,e=o;return e}function N(){var e,n,r,c,u,a;if(e=P,n=[],f.test(t.charAt(P))?(r=t.charAt(P),P++):(r=o,q(p)),r!==o)for(;r!==o;)n.push(r),f.test(t.charAt(P))?(r=t.charAt(P),P++):(r=o,q(p));else n=o;return n!==o&&(I=e,u=n,n=function(){return parseInt(u.join(""),10)}),(e=n)===o&&(e=P,40===t.charCodeAt(P)?(n="(",P++):(n=o,q(h)),n!==o&&(r=function e(){var n,r,c,u;n=P,(r=Q())!==o&&X()!==o?(43===t.charCodeAt(P)?(c="+",P++):(c=o,q(g)),c!==o&&X()!==o&&(u=e())!==o?(I=n,a=r,i=u,n=r=function(){return a()+i()}):(P=n,n=o)):(P=n,n=o);var a,i;n===o&&(n=P,(r=Q())!==o&&X()!==o?(45===t.charCodeAt(P)?(c="-",P++):(c=o,q(v)),c!==o&&X()!==o&&(u=e())!==o?(I=n,l=r,s=u,n=r=function(){return l()-s()}):(P=n,n=o)):(P=n,n=o),n===o&&(n=Q())===o&&(n=N()));var l,s;return n}())!==o?(41===t.charCodeAt(P)?(c=")",P++):(c=o,q(d)),c!==o?(I=e,e=n=r):(P=e,e=o)):(P=e,e=o),e===o&&(e=P,(n=et())!==o&&(I=e,a=n,n=function(){return rt.hasOwnProperty(a)||B("Variable not defined"),rt[a]}),e=n)),e}function Q(){var e,n,r,c,u,a,i,l;return e=P,(n=N())!==o&&X()!==o?(42===t.charCodeAt(P)?(r="*",P++):(r=o,q(A)),r!==o&&X()!==o&&(c=Q())!==o?(I=e,u=n,a=c,e=n=function(){return u()*a()}):(P=e,e=o)):(P=e,e=o),e===o&&(e=P,(n=N())!==o&&X()!==o?(47===t.charCodeAt(P)?(r="/",P++):(r=o,q(y)),r!==o&&X()!==o&&(c=Q())!==o?(I=e,i=n,l=c,e=n=function(){return i()/l()}):(P=e,e=o)):(P=e,e=o),e===o&&(e=N())),e}function X(){var e,n;for(e=[],b.test(t.charAt(P))?(n=t.charAt(P),P++):(n=o,q(m));n!==o;)e.push(n),b.test(t.charAt(P))?(n=t.charAt(P),P++):(n=o,q(m));return e}function Y(){var t,e,n;return t=P,(e=N())!==o&&(I=t,n=e,e=function(){let t=n();!("_nocheck"in rt&&1==rt._nocheck)&&(t<0||t>100)&&B("Color must be between 0 and 100"),t*=2.55;let e=Math.round(t).toString(16);return e.length<2&&(e="0"+e),"#"+e.repeat(3)}),t=e}function tt(){var t,e,n;return t=P,(e=N())!==o&&(I=t,n=e,e=function(){let t=n();return!("_nocheck"in rt&&1==rt._nocheck)&&(t<0||t>100)&&B("Coordinate must be between 0 and 100, got "+t),t}),t=e}function et(){var e,n,r,c;if(e=P,F.test(t.charAt(P))?(n=t.charAt(P),P++):(n=o,q(O)),n!==o){for(r=[],T.test(t.charAt(P))?(c=t.charAt(P),P++):(c=o,q(R));c!==o;)r.push(c),T.test(t.charAt(P))?(c=t.charAt(P),P++):(c=o,q(R));r!==o?(I=e,e=n=n+r.join("")):(P=e,e=o)}else P=e,e=o;return e}let nt;const rt={};if((n=u())!==o&&P===t.length)return n;throw n!==o&&P<t.length&&q({type:"end"}),D(Z,z<t.length?t.charAt(z):null,z<t.length?W(z,z+1):W(z,z))}}},function(t,e,n){"use strict";n.r(e);var r=n(0);const o=document.getElementById("code");o.innerHTML="paper 50";const c=document.getElementById("output"),u=document.getElementById("canvas").getContext("2d");function a(){console.log("Code:",o.value),u.clearRect(0,0,100,100);try{c.innerHTML="";Object(r.parse)(o.value)(u)}catch(t){c.innerHTML=`${t.location.end.line}:${t.location.end.column}: ${t.message}`}}o.addEventListener("keyup",a),window.addEventListener("hashchange",(function(){const t=location.hash.substr(1);0==t.length?(console.log("Clear"),o.value="",a()):t.startsWith("https:")?(console.log("Fetch:",t),fetch("https://cors-anywhere.herokuapp.com/"+t).then(t=>t.text()).then(t=>{console.log("Code:",t),o.value=t,a()})):(console.log("Code:",t),o.value=decodeURI(t),a())}),!1),a()}]);