;; Edit the rules, then apply with Ctrl+Enter. Distances are in tiles.
(lemma low-health () (< (stat :hp) (* 0.25 (stat :max-hp))))

(theorem retreat
  :class fighter :priority 100
  :premises ((low-health) (enemy-nearby))
  :conclusion (flee (nearest-threat)))

(theorem combat
  :class fighter :priority 30
  :premises ((enemy-in-range :melee))
  :conclusion (attack :basic))

(theorem gather
  :class fighter :priority 20
  :premises ((exists (r resource) (and (resource-type r :wood) (within-range r 1.8))))
  :conclusion (interact :chop))

(theorem explore
  :class fighter :priority 10
  :premises ((reachable (quest-target)))
  :conclusion (move-to (quest-target)))
