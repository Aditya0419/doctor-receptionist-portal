// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
// Import required Rails libraries
//= require chartkick
//= require Chart.bundle  
import { Turbo } from "@hotwired/turbo-rails"
import Rails from "@rails/ujs";
import "chartkick/chart.js"  // If you're using Chart.js


Rails.start();

Turbo.start();

