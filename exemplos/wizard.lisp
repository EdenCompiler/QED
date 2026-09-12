;; Every Wizard action requires a proof.
(theorem retreat
  :class wizard :priority 100
  :goal (prove (can-flee enemy)
    :given ((< (stat :hp) 25) (enemy-nearby))
    :using-axioms (flee-law))
  :on-success (flee enemy)
  :on-failure (fizzle :reason))

(theorem defensive-spark
  :class wizard :priority 30
  :goal (prove (strikes spark enemy)
    :given ((enemy-nearby))
    :using-axioms (elemental-affinity spark-law))
  :on-success (manifest :spark :target enemy)
  :on-failure (fizzle :reason))

(theorem gather
  :class wizard :priority 20
  :goal (prove (can-gather (nearest resource :wood))
    :using-axioms (gather-law))
  :on-success (interact :chop)
  :on-failure (fizzle :reason))

(theorem explore
  :class wizard :priority 10
  :goal (prove (can-move (quest-target))
    :using-axioms (travel-law))
  :on-success (move-to (quest-target))
  :on-failure (fizzle :reason))
