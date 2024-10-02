// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
// Import required Rails libraries
//= require chartkick
//= require Chart.bundle  
import { Turbo } from "@hotwired/turbo-rails"
import Rails from "@rails/ujs";
import "chartkick/chart.js"  // If you're using Chart.js
import "chartkick"
import "Chart.bundle"
import moment from "moment";
import { Chart } from 'chart.js';
import 'chartjs-adapter-moment';
// Or if you're using date-fns
import 'chartjs-adapter-date-fns';

require("chartkick");
require("./chartkick");


Rails.start();

Turbo.start();

