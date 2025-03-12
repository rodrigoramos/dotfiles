"use strict";
import GLib from "gi://GLib";
import App from "resource:///com/github/Aylur/ags/app.js";
import { Bar, PopupWindows } from "./modules/bar/main.js";
import Gdk from "gi://Gdk";

const COMPILED_STYLE_DIR = `${GLib.get_user_config_dir()}/ags/user/`;

function range(length, start = 1) {
  return Array.from({ length }, (_, i) => i + start);
}

function forAllMonitors(widget) {
  const n = Gdk.Display.get_default()?.get_n_monitors() || 1;
  return range(n, 0).flatMap(widget);
}

async function applyStyle() {
  App.resetCss();
  App.applyCss(`${COMPILED_STYLE_DIR}/style.css`);
  console.log("[LOG] Styles loaded");
}
applyStyle().catch(print);

const Windows = () => forAllMonitors(Bar).concat(PopupWindows);

const CLOSE_ANIM_TIME = 210;
App.config({
  css: `${COMPILED_STYLE_DIR}/style.css`,
  stackTraceOnError: true,
  closeWindowDelay: {
    sideright: CLOSE_ANIM_TIME,
    sideleft: CLOSE_ANIM_TIME,
    osk: CLOSE_ANIM_TIME,
  },
  windows: Windows().flat(1),
});
