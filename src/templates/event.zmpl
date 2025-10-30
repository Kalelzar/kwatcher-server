<article class="bg-zinc-800 rounded-xl p-4 shadow-xl shadow-zinc-900 relative w-full">
  <h2 class="text-2xl mb-3">Recent</h2>
  <table class="w-full mb-3" id="recent-table">
    <thead>
      <tr class="sticky top-0 bg-zinc-800/95 backdrop-blur-sm z-2">
        <th scope="column" class="bg-zinc-700 p-1">User</th>
        <th scope="column" class="bg-zinc-700 p-1">From</th>
        <th scope="column" class="bg-zinc-700 p-1">To</th>
        <th scope="column" class="bg-zinc-700 p-1">Duration</th>
        <th scope="column" class="bg-zinc-700 p-1">Event</th>
        <th scope="column" class="bg-zinc-700 p-1">Data</th>
      </tr>
    </thead>
    <tbody hx-get="/api/events/recent" hx-swap="innerHTML" hx-target="this" hx-trigger="every 5s, load">
      <tr id="recent">
        <td colspan="3">
          Loading...
        </td>
      </tr>
    </tbody>
  </table>
  <h2 class="text-2xl mb-3">All Events</h2>
  <form class="filters flex gap-1" id="filters"
        hx-get="/api/events/table"
        hx-target="#events-table"
        hx-trigger="change"
        hx-swap="outerHTML"
        hx-disinherit="hx-target">
    <div class="bg-yellow-200 text-black px-3 py-1 max-w-fit border-t border-white rounded-xl">
      <label  class="text-xl"
              for="event_types">
        Event:
      </label>
      <select class="bg-yellow-200 rounded-xl text-xl"
              name="event_types" id="event_types"
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
    </div>
    <div class="bg-yellow-200 text-black px-3 py-1 max-w-fit border-t border-white rounded-xl">
      <label  class="text-xl"
              for="clients">
        Client:
      </label>
      <select class="bg-yellow-200 rounded-xl text-xl"
              name="clients" id="clients"
              hx-get="/api/events/clients"
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
    </div>
        <div class="bg-yellow-200 text-black px-3 py-1 max-w-fit border-t border-white rounded-xl">
      <label  class="text-xl"
              for="hosts">
        Host:
      </label>
      <select class="bg-yellow-200 rounded-xl text-xl"
              name="hosts" id="hosts"
              hx-get="/api/events/hosts"
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
    </div>
  </form>
  <div class="border-t border-white mt-4 pt-4">
    <div class="rounded-xl p-2 bg-zinc-700 inset-shadow-sm inset-shadow-zinc-600">
      <div hx-get="/api/events/table" hx-trigger="load" hx-swap="outerHTML"> Loading... </div>
    </div>
  </div>
</article>
