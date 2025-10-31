@for (.events, 0..) |item, i| {
@html OUTER
<div id="activity-list-{{item.event_type}}-{{i}}"
     class="flex-basis-fit activity-list"
     x-data
     x-init="Alpine.store('event-{{item.event_type}}-{{i}}', {
             data: JSON.parse(`{{item.data}}`),
             event_type: '{{item.event_type}}',
             user_id: '{{item.user_id}}',
             start_time: {{item.from}},
             end_time: {{item.to}},
             duration: Temporal.Duration.from({microseconds: {{item.duration}}}),
             duration_string: new Intl.DurationFormat('en', { style: 'narrow' }).format(Temporal.Duration.from({microseconds: {{item.duration}}}).round({smallestUnit: 'seconds', largestUnit: 'year', relativeTo: Temporal.Instant.fromEpochMilliseconds(Math.floor({{item.from}}/1000)).toZonedDateTimeISO(Temporal.Now.timeZoneId())})),
             })">
  <div hx-preserve
       id="{{item.event_type}}-{{i}}--{{.__id}}"
       class="h-full card-wrapper"
       x-data="{
                 get props() { return Alpine.store('event-{{item.event_type}}-{{i}}').data; },
                 get context() { return Alpine.store('event-{{item.event_type}}-{{i}}'); }
               }"
       hx-get="/api/events/activity_card?event_type={{item.event_type}}"
       hx-swap="innerHTML"
       hx-target="this"
       hx-trigger="load once"
       @htmx:response-error="
         htmx.ajax('GET', '/api/events/activity_card?event_type=fallback', {
             target: $el,
             swap: 'innerHTML'
         })
      ">
    Loading...
  </div>
</div>
  OUTER
}




