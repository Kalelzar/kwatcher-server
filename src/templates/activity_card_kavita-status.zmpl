<div
    :class="{
        'bg-green-800': props.status === 'active',
        'bg-gray-500':  props.status === 'inactive',
    }"
    class="activity-list-content mx-w-80 min-w-40 w-fit min-h-24 h-full max-h-36 rounded text-white flex flex-col">
    <h3
    :class="{
    'bg-green-600': props.status === 'active',
    'bg-gray-600': props.status === 'inactive',
    }"
    class="text-center h-fit"
      >
      Kavita
    </h3>
    <div
      class="px-3 py-1 text-center h-full"
      x-show="props.status === 'inactive'"
    >
      <p x-text="context.duration_string"></p>
    </div>
    <div
      class="px-3 py-1 mb-1 flex w-full grow items-center"
      x-show="props.status === 'active'"
      >
      <img class="w-14 outline-zinc-300 outline-solid rounded-md" x-bind:src="">
      <div class="grow ml-3">
        <p x-text="props.chapterTitle"></p>
        <p x-text="props.seriesName"></p>
        <p x-text="props.writers"></p>
      </div>
    </div>
</div>
