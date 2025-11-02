<article class="bg-zinc-800 rounded-xl p-4 shadow-xl shadow-zinc-900 relative w-full">
  <h2 class="text-center text-2xl mb-3">Recent</h2>
  <div class="w-full mb-3" id="recent-table">
    <div id="recent-container"
         class="flex gap-1 align-center justify-center w-full min-h-24 h-max max-h-36"
         hx-get="/api/events/recent"
         hx-swap="morph:innerHTML"
         hx-target="this"
         hx-trigger="every 5s, load">
      Loading...
    </div>
  </div>
  <h2 class="text-center text-2xl mb-3">All Events</h2>
  @partial event_filters()
  <div class="border-t border-white mt-4 pt-4">
    <div class="rounded-xl p-2 bg-zinc-700 inset-shadow-sm inset-shadow-zinc-600">
      <div hx-get="/api/events/table" hx-trigger="load" hx-swap="outerHTML"> Loading... </div>
    </div>
  </div>
</article>
