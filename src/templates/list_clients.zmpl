<option> All </option>
@for (.clients) |item| {
@html OUTER
<option>{{item}}</option>
OUTER
}