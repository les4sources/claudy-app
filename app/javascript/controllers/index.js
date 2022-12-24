function identifierForComponentsContextKey(filename) {
  return filename.replace("controller.js", "")
    .replace(/[\W_]/g, "-")
    .replace(/^-+/,"")
    .replace(/-+$/, "").replace('components-', '').replace('-component', '--component')
}

import { Application } from "@hotwired/stimulus"
import { identifierForContextKey } from "stimulus/webpack-helpers"
import { definitionsFromContext } from "@hotwired/stimulus-webpack-helpers"
import { controllerDefinitions as bulletTrainControllers } from "@bullet-train/bullet-train"
import { controllerDefinitions as bulletTrainFieldControllers } from "@bullet-train/fields"
import { controllerDefinitions as bulletTrainSortableControllers } from "@bullet-train/bullet-train-sortable"
import RevealController from 'stimulus-reveal'
import CableReady from 'cable_ready'
import consumer from '../channels/consumer'

const application = Application.start()

// Load all the controllers within this directory and all subdirectories.
// Controller files must be named *_controller.js.
import { context as controllersContext } from './**/*_controller.js';
import { context as componentsControllersContext } from '../../components/**/*_controller.js';
import { Alert, Autosave, Dropdown, Modal, Tabs, Popover, Toggle, Slideover } from 'tailwindcss-stimulus-components';

application.load(bulletTrainControllers)
application.load(bulletTrainFieldControllers)
application.load(bulletTrainSortableControllers)

application.register('reveal', RevealController)

const controllers = Object.keys(controllersContext).map((filename) => ({
  identifier: identifierForContextKey(filename),
  controllerConstructor: controllersContext[filename] }))

const componentsControllers = Object.keys(componentsControllersContext).map((filename) => ({
  identifier: identifierForComponentsContextKey(filename),
  controllerConstructor: componentsControllersContext[filename] }))
console.log(componentsControllers)

application.load(controllers)
application.load(componentsControllers)

// Import and register all TailwindCSS Components
application.register('alert', Alert)
application.register('autosave', Autosave)
application.register('dropdown', Dropdown)
application.register('modal', Modal)
application.register('tabs', Tabs)
application.register('popover', Popover)
application.register('toggle', Toggle)
application.register('slideover', Slideover)

CableReady.initialize({ consumer })
