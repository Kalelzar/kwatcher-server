<div
    :class="{
        'bg-green-800': props.status == 'Active',
        'bg-gray-500': props.status === 'Inactive',
    }"
    class="activity-list-content mx-w-80 min-w-40 w-fit min-h-24 h-full rounded-lg text-white">
    <h3
    :class="{
    'bg-green-600': props.status == 'Active',
    'bg-gray-600': props.status === 'Inactive',
    }"
    class="text-center rounded-t-lg"
      >
      AFK
    </h3>
    <div
    class="px-3 py-1 text-center"
    >
      <p x-text="context.duration_string"></p>
      <p x-text="context.client.host"></p>
    </div>
    <div
      :class="{
              'bg-green-600': props.status == 'Active',
              'bg-gray-600': props.status === 'Inactive',
              }"
      class="mx-w-80 w-all h-fit text-white rounded-b-lg">
      <p class="flex flex-row justify-center text-xs"><span x-text="context.client.name"></span> - <span x-text="context.client.version"></span></p>
    </div>
</div>
