<table class="w-full" id="events-table">
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
  <tbody hx-include="#filters">
    <tr id="nextPage">
      <td colspan="3">
        <div hx-get="/api/events/get?drop=0&take=20" hx-swap="outerHTML" hx-target="#nextPage" hx-trigger="load"/>
      </td>
    </tr>
  </tbody>
</table>
