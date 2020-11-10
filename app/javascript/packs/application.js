require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")

// External imports
import "bootstrap";

// Internal imports, e.g:
import { gameValidation } from '../components/game_validation';

document.addEventListener('turbolinks:load', () => {
  // Call your functions here, e.g:
  gameValidation();
});
