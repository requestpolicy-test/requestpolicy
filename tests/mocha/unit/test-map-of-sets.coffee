###
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
###

{assert} = require "chai"
{strictEqual} = assert

{MapOfSets} = require "lib/classes/map-of-sets"

describe "MapOfSets", ->
  it "addToSet(), deleteFromSet(), has(), get()", ->
    map = new MapOfSets()
    strictEqual map.has("a"), false

    first = {}
    second = {}

    # Adding a first element to the "a" set.
    map.addToSet "a", first
    strictEqual map.has("a"), true
    strictEqual map.get("a").size, 1

    # Adding a second element to the same set.
    map.addToSet "a", second
    strictEqual map.has("a"), true
    strictEqual map.get("a").size, 2

    # Removing a nonexistant element.
    map.deleteFromSet "a", {}
    strictEqual map.get("a").size, 2

    # Removing a nonexistant element from nonexistant map "b".
    map.deleteFromSet "b", {}
    strictEqual map.has("b"), false

    # Removing the first element again.
    map.deleteFromSet "a", first
    strictEqual map.has("a"), true
    strictEqual map.get("a").size, 1

    # Add "second" to "b"
    map.addToSet "b", second
    strictEqual map.has("b"), true
    strictEqual map.get("b").size, 1

    # Remove all remaining elements
    map.deleteFromSet "a", second
    map.deleteFromSet "b", second
    strictEqual map.has("a"), false
    strictEqual map.has("b"), false
