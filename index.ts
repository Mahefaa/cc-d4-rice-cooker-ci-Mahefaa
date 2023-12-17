import {RiceCooker} from './core/RiceCooker';
import Runner from "./core/Runner";

const riceCooker = new RiceCooker();
const runner = new Runner(riceCooker);
runner.run();