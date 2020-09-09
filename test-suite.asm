.import source "vendor/64spec/lib/64spec.asm"

sfspec: :init_spec()
  
  :assert_a_equal #42

  :finish_spec()