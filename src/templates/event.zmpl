<article class="bg-zinc-800 rounded-xl p-4 shadow-xl shadow-zinc-900 relative w-full">
  <h2 class="text-2xl">Events</h2>
  <form class="filters" id="filters"
        hx-get="/api/events/table"
        hx-target="#events-table"
        hx-trigger="change"
        hx-swap="outerHTML"
        hx-disinherit="hx-target">
    <label for="event_types">Event: </label>
    <select name="event_types" id="event_types"
            hx-get="/api/events/types"
            hx-swap="innerHTML"
            hx-trigger="every 5s, load once"
            hx-on::before-swap="this.dataset.selected = this.value"
            hx-on::after-swap="
              const prev = this.dataset.selected;
              if (prev && Array.from(this.options).some(opt => opt.value === prev)) {
                this.value = prev;
              } else {
                this.value = this.options[0].value
              }">
      <option>All</option>
    </select>
  </form>
  <div class="border-t border-white mt-4 pt-4">
    <div class="rounded-xl p-2 bg-zinc-700 inset-shadow-sm inset-shadow-zinc-600">
      <div hx-get="/api/events/table" hx-trigger="load" hx-swap="outerHTML"> Loading... </div>
    </div>
  </div>
</article>
