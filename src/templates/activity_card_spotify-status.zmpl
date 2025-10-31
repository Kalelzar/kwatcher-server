<div
    :class="{
        'bg-green-800': props.playing,
        'bg-gray-500': !props.playing,
    }"
    class="activity-list-content mx-w-80 min-w-40 w-fit min-h-24 h-full max-h-36 rounded text-white flex flex-col">
    <h3
    :class="{
    'bg-green-600': props.playing,
    'bg-gray-600': !props.playing,
    }"
    class="text-center h-fit"
      >
      Spotify
    </h3>
    <div
      class="px-3 py-1 text-center h-full"
      x-show="!props.playing"
    >
      <p x-text="context.duration_string"></p>
    </div>
    <div
      class="px-3 py-1 mb-1 flex w-full grow items-center"
      x-show="props.playing"
      >
      <img class="w-14 outline-zinc-300 outline-solid rounded-md" x-bind:src="props.cover_uri">
      <div class="grow ml-3">
        <p x-text="props.title"></p>
        <p x-text="props.album"></p>
        <p x-text="props.artist"></p>
      </div>
    </div>
</div>
