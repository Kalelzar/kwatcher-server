<style>
.icon::after {
  content: url("https://cdn.jsdelivr.net/gh/selfhst/icons/webp/slash.webp");
  position: absolute;
  inset: 0;
  display: block;
  z-index: 1000;
}
</style>

<div
    :class="{
        'bg-green-800': props.wininfo != null,
        'bg-gray-500': props.wininfo == null,
    }"
    class="activity-list-content mx-w-80 min-w-40 w-fit min-h-24 h-full max-h-36 rounded-lg text-white flex flex-col">
    <h3
    :class="{
            'bg-green-600': props.wininfo != null,
            'bg-gray-600': props.wininfo == null,
    }"
    class="text-center h-fit rounded-t-lg"
      >
      Window
    </h3>
    <div
      class="px-3 py-1 text-center h-full"
      x-show="props.wininfo == null"
    >
      <p x-text="context.duration_string"></p>
    </div>
    <div
      class="px-3 py-1 mb-1 flex w-full grow items-center"
      x-show="props.wininfo != null"
      >
      <object class="w-14 rounded-md"
              type="image/webp">
        <img
          class="icon"
          x-data="{
                  get img() { return `https://cdn.jsdelivr.net/gh/selfhst/icons/webp/${props.wininfo.class.toLowerCase()}.webp` }
                  }"
          x-bind:src="img" />
      </object>
      <div class="grow ml-3">
        <p x-text="props.wininfo.name"></p>
        <p x-text="props.wininfo.class"></p>
      </div>
    </div>
    <div
      :class="{
              'bg-green-600': props.wininfo != null,
              'bg-gray-600': props.wininfo == null,
              }"
      class="mx-w-80 w-all h-fit text-white rounded-b-lg">
      <p class="flex flex-row justify-center text-xs"><span x-text="context.client.name"></span> - <span x-text="context.client.version"></span></p>
    </div>
</div>
