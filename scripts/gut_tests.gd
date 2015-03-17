extends "res://scripts/gut.gd".Test

#--------------------------------------
#Used to test calling the _process method
#on an object through gut
#--------------------------------------
class HasProcessMethod:
	extends Node
	var process_called_count = 0
	var delta_sum = 0.0
	
	func _process(delta):
		process_called_count += 1
		delta_sum += delta

#--------------------------------------
#Used to test calling the _fixed_process
#method on an object through gut
#--------------------------------------
class HasFixedProcessMethod:
	extends Node
	var fixed_process_called_count = 0
	var delta_sum = 0.0
	
	func _fixed_process(delta):
		fixed_process_called_count += 1
		delta_sum += delta

var counts = {
	setup_count = 0,
	teardown_count = 0,
	prerun_setup_count = 0,
	postrun_teardown_count = 0,
	should_fail = 0
}

#Used to count the number of tests that should fail so that they
#can be compared at the end.
func should_fail():
	counts.should_fail += 1

func setup():
	counts.setup_count += 1

func teardown():
	counts.teardown_count += 1

func prerun_setup():
	counts.prerun_setup_count += 1

func postrun_teardown():
	counts.postrun_teardown_count += 1
	#can't verify that this ran, so do an assert.
	#Asserts in any of the setup/teardown methods
	#is a bad idea in general.
	gut.assert_true(true, 'POSTTEARDOWN RAN')


#------------------------------
#Number tests
#------------------------------

func test_assert_eq_number_not_equal():
	should_fail()
	gut.assert_eq(1, 2, "Should fail.  1 != 2")
	
func test_assert_eq_number_equal():
	gut.assert_eq('asdf', 'asdf', "Should pass")

func test_assert_ne_number_not_equal():
	gut.assert_ne(1, 2, "Should pass, 1 != 2")

func test_assert_ne_number_equal():
	should_fail()
	gut.assert_ne(1, 1, "Should fail")

func test_assert_gt_number_with_gt():
	gut.assert_gt(2, 1, "Should Pass")

func test_assert_gt_number_with_lt():
	should_fail()
	gut.assert_gt(1, 2, "Should fail")

func test_assert_lt_number_with_lt():
	gut.assert_lt(1, 2, "Should Pass")

func test_assert_lt_number_with_gt():
	should_fail()
	gut.assert_lt(2, 1, "Should fail")

func test_between_with_number_between():
	gut.assert_between(2, 1, 3, "Should pass, 2 between 1 and 3")

func test_between_with_number_lt():
	should_fail()
	gut.assert_between(0, 1, 3, "Should fail")

func test_between_with_number_gt():
	should_fail()
	gut.assert_between(4, 1, 3, "Should fail")

func test_between_with_number_at_high_end():
	gut.assert_between(3, 1, 3, "Should pass")

func test_between_with_number_at_low_end():
	gut.assert_between(1, 1, 3, "Should pass")

func test_between_with_invalid_number_range():
	should_fail()
	gut.assert_between(4, 8, 0, "Should fail")
#------------------------------
#string tests
#------------------------------

func test_assert_eq_string_not_equal():
	should_fail()
	gut.assert_eq("one", "two", "Should Fail")

func test_assert_eq_string_equal():
	gut.assert_eq("one", "one", "Should Pass")

func test_assert_ne_string_not_equal():
	gut.assert_ne("one", "two", "Should Pass")

func test_assert_ne_string_equal():
	should_fail()
	gut.assert_ne("one", "one", "Should Fail")

func test_assert_gt_string_with_gt():
	gut.assert_gt("b", "a", "Should Pass")

func test_assert_gt_string_with_lt():
	should_fail()
	gut.assert_gt("a", "b", "Sould Fail")

func test_assert_lt_string_with_lt():
	gut.assert_lt("a", "b", "Should Pass")

func test_assert_lt_string_with_gt():
	should_fail()
	gut.assert_lt("b", "a", "Should Fail")

func test_between_with_string_between():
	gut.assert_between('b', 'a', 'c', "Should pass, 2 between 1 and 3")

func test_between_with_string_lt():
	should_fail()
	gut.assert_between('a', 'b', 'd', "Should fail")

func test_between_with_string_gt():
	should_fail()
	gut.assert_between('z', 'a', 'c', "Should fail")

func test_between_with_string_at_high_end():
	gut.assert_between('c', 'a', 'c', "Should pass")

func test_between_with_string_at_low_end():
	gut.assert_between('a', 'a', 'c', "Should pass")

func test_between_with_invalid_string_range():
	should_fail()
	gut.assert_between('q', 'z', 'a', "Should fail")
#------------------------------
#boolean tests
#------------------------------
func test_assert_true_with_true():
	gut.assert_true(true, "Should pass, true is true")

func test_assert_true_with_false():
	should_fail()
	gut.assert_true(false, "Should fail")

func test_assert_flase_with_true():
	should_fail()
	gut.assert_false(true, "Should fail")

func test_assert_false_with_false():
	gut.assert_false(false, "Should pass")

#------------------------------
#Misc tests
#------------------------------
func test_can_call_eq_without_text():
	gut.assert_eq(1, 1)

func test_can_call_ne_without_text():
	gut.assert_ne(1, 2)

func test_can_call_true_without_text():
	gut.assert_true(true)

func test_can_call_false_without_text():
	gut.assert_false(false)

func test_script_object_added_to_tree():
	gut.assert_ne(get_tree(), null, "The tree should not be null if we are added to it")

func test_pending_increments_pending_count():
	gut.pending()
	gut.assert_eq(gut.get_pending_count(), 1, 'One test should have been marked as pending')

func test_pending_accepts_text():
	gut.pending("This is a pending test")

func test_wait_for_continue_click():
	gut.assert_eq(1, 1, 'some simple assert')
	gut.pause_before_teardown()
	
func test_can_pause_twice():
	gut.assert_eq(2, 2, 'Another simple assert')
	gut.pause_before_teardown()

func test_simulate_calls_process():
	var obj = HasProcessMethod.new()
	gut.simulate(obj, 10, .1)
	gut.assert_eq(obj.process_called_count, 10, "_process should have been called 10 times")
	#using just the numbers didn't work, nor using float.  str worked for some reason and 
	#i'm not sure why.
	gut.assert_eq(str(obj.delta_sum), str(1), "The delta value should have been passed in and summed")

func test_simulate_calls_process_on_child_objects():
	var parent = HasProcessMethod.new()
	var child = HasProcessMethod.new()
	parent.add_child(child)
	gut.simulate(parent, 10, .1)
	gut.assert_eq(child.process_called_count, 10, "_process should have been called on the child object too")

func test_simulate_calls_process_on_child_objects_of_child_objects():
	var objs = []
	for i in range(5):
		objs.append(HasProcessMethod.new())
		if(i > 0):
			objs[i - 1].add_child(objs[i])
	gut.simulate(objs[0], 10, .1)
	
	for i in range(objs.size()):
		gut.assert_eq(objs[i].process_called_count, 10, "_process should have been called on object # " + str(i))

func test_simulate_calls_fixed_process():
	var obj = HasFixedProcessMethod.new()
	gut.simulate(obj, 10, .1)
	gut.assert_eq(obj.fixed_process_called_count, 10, "_process should have been called 10 times")
	#using just the numbers didn't work, nor using float.  str worked for some reason and 
	#i'm not sure why.
	gut.assert_eq(str(obj.delta_sum), str(1), "The delta value should have been passed in and summed")

func test_verify_results():
	gut.p("/*THESE SHOULD ALL PASS, IF NOT THEN SOMETHING IS BROKEN*/")
	gut.assert_eq(counts.should_fail, gut.get_fail_count(), "The expected number of tests should have failed.")
	gut.assert_eq(1, counts.prerun_setup_count, "Prerun setup should have been called once")
	gut.assert_eq(gut.get_test_count(), counts.setup_count, "Setup should have been called for the number of tests ran")
	gut.assert_eq(gut.get_test_count() -1, counts.teardown_count, "Teardown should have been called one less time")