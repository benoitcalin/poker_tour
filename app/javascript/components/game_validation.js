import axios from 'axios'
import cheerio from 'cheerio';

export async function scrapeTournamentTitle(winamax_id) {
  const div = document.querySelector('.game-verification')
  try {
    const html = await axios.get(`https://www.winamax.fr/poker/tournament.php?ID=${winamax_id}/`);
    const $ = await cheerio.load(html.data);

    const title = $('.page-title')[0].children[0].data
    div.classList.remove('d-none')
    div.innerHTML = ""
    div.insertAdjacentHTML('beforeend', `<p>Tu as rentré le code pour le tournois : <strong class="brand-color">${title}</strong></p><h6>Est-ce bien celui que tu veux ajouter ?</h6>`)
    const button = document.querySelector('#submit-game');
    button.disabled = false
  } catch(err) {
    div.classList.remove('d-none')
    div.innerHTML = ""
    div.insertAdjacentHTML('beforeend', `<p style='color:red;'>Le code winamax ne correspond pas à un tournoi existant.</p>`)
  }

}

const gameValidation = () => {
  const input = document.querySelector('#game_winamax_id');
  const button = document.querySelector('#submit-game');

  if (input && button) {
    button.disabled = true
    input.addEventListener('keyup', e => {
      if (input.value.length === 9) {
        scrapeTournamentTitle(input.value);
      }
    })

    input.addEventListener('blur', e => {
      if (input.value.length === 9) {
        scrapeTournamentTitle(input.value);
      }
    })
  }
}

export { gameValidation };
