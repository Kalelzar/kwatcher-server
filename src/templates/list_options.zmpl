<option> All </option>
@for (.options) |item| {
@html OUTER
<option>{{item}}</option>
OUTER
}