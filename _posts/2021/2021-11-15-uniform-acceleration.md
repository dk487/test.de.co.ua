---
title: Рівноприскорений рух
date: 2021-11-15 18:17:06 +02:00
styles: |
  .formula { font-size: 135%; text-align: center }

  .z {
    display: block; margin: .15em; width: 1em; height: 1em;
    border: thin solid #363; border-radius: 50%;
    background: #363; background: linear-gradient(#593, #030);
  }

  @media (min-width: 30em) {
    @supports not (display: grid) {
      .container { display: flex }
      .demo { margin: 0 1em }
    }
    @supports (display: grid) {
      .container {
        display: grid; gap: 1em;
        grid-template-columns: minmax(10em, auto) 2em 15em;
      }
    }
  }

  .zzz { background: #6c3; background: linear-gradient(#af3, #6c3) }
---

Намагаюся пригадати шкільний підручник з фізики.

Уявіть, що якась красива металева кулька падає поруч з вертикально розташованою линійкою, починаючи з відмітки «0&nbsp;см». Питання таке: у які моменти часу вона досягне позначок «1&nbsp;см», «2&nbsp;см», «3&nbsp;см» і так далі?

А _насправді_ питання ось яке: як би я міг, керуючи світлодіодами на линійці, зобразити цей рух?

<div class="container" markdown=1>

  <div class="intro" markdown=1>

Координати тіла (формула з [Вікіпедії][1]):

<p class="formula">
  <math>
    <mrow>
      <mi>x</mi>
      <mo>=</mo>
      <msub>
        <mi>x</mi>
        <mn>0</mn>
      </msub>
      <mo>+</mo>
      <mrow>
        <msub>
          <mi>v</mi>
          <mn>0</mn>
        </msub>
        <mo></mo>
        <mi>t</mi>
      </mrow>
      <mo>+</mo>
      <mrow>
        <mfrac>
          <mn>1</mn>
          <mn>2</mn>
        </mfrac>
        <mo></mo>
        <mi>a</mi>
        <mo></mo>
        <msup>
          <mi>t</mi>
          <mn>2</mn>
        </msup>
      </mrow>
    </mrow>
  </math>
</p>

Для спрощення, нехай <math><msub><mi>x</mi><mn>0</mn></msub><mo>=</mo><mn>0</mn></math> та <math><msub><mi>v</mi><mn>0</mn></msub><mo>=</mo><mn>0</mn></math>.

<p class="formula">
  <math>
    <mrow>
      <mi>t</mi>
      <mo>=</mo>
      <msqrt>
        <mfrac>
          <mrow>
            <mn>2</mn>
            <mo></mo>
            <mi>x</mi>
          </mrow>
          <mi>a</mi>
        </mfrac>
      </msqrt>
    </mrow>
  </math>
</p>

<p class="formula">
  <math>
    <mrow>
      <mi>t</mi>
      <mo>=</mo>
      <msub>
        <mi>C</mi>
        <mi>t</mi>
      </msub>
      <mo></mo>
      <msqrt>
        <mi>x</mi>
      </msqrt>
    </mrow>
  </math>
</p>

<p class="formula">
  <math>
    <mrow>
      <msub>
        <mi>t</mi>
        <mrow>
          <mi>i</mi>
          <mo>+</mo>
          <mn>1</mn>
        </mrow>
      </msub>
      <mo>-</mo>
      <msub>
        <mi>t</mi>
        <mi>i</mi>
      </msub>
      <mo>=</mo>
      <msub>
        <mi>C</mi>
        <mi>t</mi>
      </msub>
      <mo></mo>
      <mrow>
        <mo>(</mo>
        <msqrt>
          <msub>
            <mi>x</mi>
            <mrow>
              <mi>i</mi>
              <mo>+</mo>
              <mn>1</mn>
            </mrow>
          </msub>
        </msqrt>
        <mo>-</mo>
        <msqrt>
          <msub>
            <mi>x</mi>
            <mi>i</mi>
          </msub>
        </msqrt>
        <mo>)</mo>
      </mrow>
    </mrow>
  </math>
</p>

Нехай <math><msub><mi>x</mi><mi>i</mi></msub><mo>=</mo><mrow><msub><mi>C</mi><mi>x</mi></msub><mo></mo><mi>i</mi></mrow></math>.

<p class="formula">
  <math>
    <mrow>
      <msub>
        <mi>&Delta;</mi>
        <mi>i</mi>
      </msub>
      <mo>=</mo>
      <msub>
        <mi>C</mi>
        <mi>t</mi>
      </msub>
      <mo></mo>
      <mrow>
        <mo>(</mo>
        <msqrt>
          <msub>
            <mi>C</mi>
            <mi>x</mi>
          </msub>
          <mo></mo>
          <mrow>
            <mo>(</mo>
            <mi>i</mi>
            <mo>+</mo>
            <mn>1</mn>
            <mo>)</mo>
          </mrow>
        </msqrt>
        <mo>-</mo>
        <msqrt>
          <msub>
            <mi>C</mi>
            <mi>x</mi>
          </msub>
          <mo></mo>
          <mi>i</mi>
        </msqrt>
        <mo>)</mo>
      </mrow>
    </mrow>
  </math>
</p>

</div>

<div class="demo">
  <p>
    <span class="z" id="z01"></span>
    <span class="z" id="z02"></span>
    <span class="z" id="z03"></span>
    <span class="z" id="z04"></span>
    <span class="z" id="z05"></span>
    <span class="z" id="z06"></span>
    <span class="z" id="z07"></span>
    <span class="z" id="z08"></span>
    <span class="z" id="z09"></span>
    <span class="z" id="z10"></span>
    <span class="z" id="z11"></span>
    <span class="z" id="z12"></span>
    <span class="z" id="z13"></span>
    <span class="z" id="z14"></span>
    <span class="z" id="z15"></span>
    <span class="z" id="z16"></span>
    <span class="z" id="z17"></span>
    <span class="z" id="z18"></span>
    <span class="z" id="z19"></span>
    <span class="z" id="z20"></span>
  </p>
</div>

<div class="controls">
  <form action="#" onsubmit="return false;">
    <p>
      <label>
        Значення <math><msub><mi>C</mi><mi>t</mi></msub><mo>=</mo></math>
        <input name="C_t" size="4" value="1250" onclick="update();" onkeypress="update();" onkeyup="update();">
        мс
      </label>
    </p>
    <p>
      <label>
        Значення <math><msub><mi>C</mi><mi>x</mi></msub><mo>=</mo></math>
        <input name="C_x" size="3" value=".75" onclick="update();" onkeypress="update();" onkeyup="update();">
      </label>
    </p>
    <p><button onclick="demo();">Запустити тест</button></p>
  </form>
</div>

</div>

На жаль, [Chrome не підтримує MathML][2] і показує замість красивих формул казна-що. Вибачте, я не хочу тягнути сюди MathJax чи щось таке. Використовуйте Firefox.

Також мені дуже шкода, що Jekyll не має вбудованих засобів для трансформації чогось типу LaTeX (те, що легко писати) у MathML (те, що має бути у вебі). Так, для цього є плагіни, але я не хочу використовувати плагіни. До того ж, GitHub Pages підтримує дуже обмежений набір плагінів.

Але ж як кльово виглядають формули у мене в Firefox!

<script>
  var current;
  var timeout;
  var C_t = 1250;
  var C_x = .75;

  function showCurrent() {
    for (var i = 1; i <= 20; i++) {
      var id = 'z' + (i < 10 ? '0' : '') + i;
      //console.log('id = ' + id);
      if (i == current) {
        document.getElementById(id).classList.add('zzz');
      } else {
        document.getElementById(id).classList.remove('zzz');
      }
    }
  }

  function stepNext() {
    current++;
    console.log('current step = ' + current);
    showCurrent();
    if (current <= 20) {
      var i = C_x * current;
      var iPlus1 = C_x * (current + 1);
      var delay = C_t * (Math.sqrt(iPlus1) - Math.sqrt(i));
      console.log('delay = ' + delay);
      timeout = setTimeout(stepNext, delay);
    }
  }

  function demo() {
    console.log('start');
    current = 0;
    stepNext();
  }

  function update() {
    C_t = parseInt(document.querySelector('input[name=C_t]').value);
    console.log('C_t = ' + C_t);
    C_x = parseFloat(document.querySelector('input[name=C_x]').value);
    console.log('C_x = ' + C_x);
  }

  document.querySelector('input[name=C_t]').value = C_t;
  document.querySelector('input[name=C_x]').value = C_x;
</script>

[1]: https://uk.wikipedia.org/wiki/%D0%A0%D1%96%D0%B2%D0%BD%D0%BE%D0%BF%D1%80%D0%B8%D1%81%D0%BA%D0%BE%D1%80%D0%B5%D0%BD%D0%B8%D0%B9_%D1%80%D1%83%D1%85
[2]: https://caniuse.com/mathml
