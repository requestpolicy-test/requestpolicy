###
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
###

{assert} = require "chai"
{deepEqual} = assert

{RequestResult} = require "lib/classes/request-result"

describe "RequestResult", ->
  #=============================================================================
  # utilities
  #=============================================================================

  createRequestResult = () -> new RequestResult()

  policyToArrayName = (policy) ->
    switch policy
      when "allow" then "matchedAllowRules"
      when "deny" then "matchedDenyRules"
      else throw Error("Invalid policy")

  addOriginRule = (rr, policy) ->
    list = rr[policyToArrayName(policy)]
    list.push([{}, ["origin", {}, {}]])

  addDestRule = (rr, policy) ->
    list = rr[policyToArrayName(policy)]
    list.push([{}, ["origin", {}, {}]])

  addOriginToDestRule = (rr, policy) ->
    list = rr[policyToArrayName(policy)]
    list.push([{}, ["origin-to-dest", {}, {}, {}, {}]])

  #=============================================================================
  # tests
  #=============================================================================

  describe "resolveConflict()", ->
    it "allow origin, deny dest", ->
      # setup
      rr = createRequestResult()
      addOriginRule(rr, "allow")
      addDestRule(rr, "deny")

      # exercise
      rv  = rr.resolveConflict()

      # verify
      deepEqual(rv, {conflictCanBeResolved: false, shouldAllow: undefined})

    it "deny origin, allow o2d", ->
      # setup
      rr = createRequestResult()
      addDestRule(rr, "deny")
      addOriginToDestRule(rr, "allow")

      # exercise
      rv  = rr.resolveConflict()

      # verify
      deepEqual(rv, {conflictCanBeResolved: true, shouldAllow: true})

    it "allow dest, deny o2d", ->
      # setup
      rr = createRequestResult()
      addDestRule(rr, "allow")
      addOriginToDestRule(rr, "deny")

      # exercise
      rv  = rr.resolveConflict()

      # verify
      deepEqual(rv, {conflictCanBeResolved: true, shouldAllow: false})

    it "allow o2d, deny o2d", ->
      # setup
      rr = createRequestResult()
      addOriginToDestRule(rr, "allow")
      addOriginToDestRule(rr, "deny")

      # exercise
      rv  = rr.resolveConflict()

      # verify
      deepEqual(rv, {conflictCanBeResolved: false, shouldAllow: undefined})
