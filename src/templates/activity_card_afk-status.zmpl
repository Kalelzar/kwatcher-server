<div
    :class="{
        'bg-green-800': props.status == 'Active',
        'bg-gray-500': props.status === 'Inactive',
    }"
    class="activity-list-content mx-w-80 min-w-40 w-fit min-h-24 h-full rounded text-white">
    <h3
    :class="{
    'bg-green-600': props.status == 'Active',
    'bg-gray-600': props.status === 'Inactive',
    }"
    class="text-center"
      >
      AFK
    </h3>
    <div
    class="px-3 py-1 text-center"
    >
      <p x-text="context.duration_string"></p>
      <p x-text="context.user_id"></p>
    </div>
</div>
