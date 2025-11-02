@args label: []const u8, filter_name: []const u8, endpoint: []const u8
<div class="bg-yellow-200 text-black px-3 py-1 max-w-fit border-t border-white rounded-xl">
  <label  class="text-xl"
          for="{{filter_name}}">
    {{label}}
  </label>
  <select class="bg-yellow-200 rounded-xl text-xl"
          name="{{filter_name}}" id="{{filter_name}}"
          hx-get="{{endpoint}}"
          hx-include="#filters"
          hx-swap="innerHTML"
          hx-trigger="every 5s, load once, change from:#filters, reset from:#filters delay:50ms"
          hx-on::before-swap="this.dataset.selected = this.value"
          hx-on::after-swap="
                             const prev = this.dataset.selected;
                             if (prev && Array.from(this.options).some(opt => opt.value === prev)) {
                               this.value = prev;
                             } else {
                               this.value = this.options[0].value;
                             }">
    <option>All</option>
  </select>
</div>
