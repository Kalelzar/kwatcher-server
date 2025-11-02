<form class="filters justify-center w-full flex gap-1" id="filters"
      x-data="{ hasChanged: false }" 
      @change="hasChanged = true"
      @reset="hasChanged = false"
      hx-get="/api/events/table"
      hx-target="#events-table"
      hx-trigger="change, reset"
      hx-swap="outerHTML"
      hx-disinherit="hx-target">
    @partial dynamic_filter("Event:", "event_types", "/api/events/types")
    @partial dynamic_filter("Client:", "clients", "/api/events/clients")
    @partial dynamic_filter("Host:", "hosts", "/api/events/hosts")
    <button :disabled="!hasChanged" class="disabled:bg-gray-400 bg-red-200 rounded-xl border-t border-white p-2 text-black" type="reset" aria-label="Clear filters">
      <img class="max-w-6" src="/static/svg/clear.svg" alt="Clear filters"/>
    </button>
    <button class="bg-green-200 rounded-xl border-t border-white p-2 text-black"
            aria-label="Refresh table"
            hx-get="/api/events/table"
            hx-target="#events-table"
            hx-trigger="click"
            hx-swap="outerHTML">
      <img class="max-w-6" src="/static/svg/refresh.svg" alt="Refresh table"/>
    </button>
  </form>
