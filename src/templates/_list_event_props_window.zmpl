@args props: []const u8
@html INNER
<td scope="row"
    class="flex gap-4 align-center justify-end bg-zinc-700 text-lg p-1"
    x-data="{
              props: JSON.parse(`{{props}}`),
              get isFocused() { return this.props.wininfo != null; },
              get wininfo() { return this.props.wininfo; },
              get title() { return !!this.wininfo ? this.wininfo.name : ''; },
              get winclass() { return !!this.wininfo ? this.wininfo.class : ''; },
              get icon() { return `https://cdn.jsdelivr.net/gh/selfhst/icons/webp/${this.winclass.toLowerCase()}.webp`; },
            }">
    <div class="grid outline-yellow-100 outline-solid outline-1 drop-shadow-xl w-full text-center px-4 py-2 grid-cols-[auto_1fr] bg-zinc-500 rounded-se-4xl rounded-ee-4xl rounded-ss-md rounded-es-md" x-show="isFocused">
      <object class="max-w-24 row-start-1 row-end-3 outline-zinc-300 outline-solid rounded-md"
              x-bind:data="icon"
              type="image/webp">
        <img src="https://cdn.jsdelivr.net/gh/selfhst/icons/webp/slash.webp" />
      </object>
      <p class="text-yellow-100 text-2xl w-full col-2" x-text="winclass"></p>
      <p x-text="title" class="col-2 text-yellow-100"></p>
    </div>
    <div x-show="!isFocused" class="outline-yellow-100 outline-solid outline-1 drop-shadow-xl w-full px-4 py-2 bg-zinc-500 rounded-se-4xl rounded-ee-4xl rounded-ss-md rounded-es-md">
         <p class="text-yellow-100 text-xl w-full float-left">Inactive</p>
    </div>
</td>
INNER
