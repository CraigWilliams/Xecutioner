﻿script RunMacVimTestInTerminal  property RUN_EM_ALL : "Run'em All!"  property ruby_file_path : missing value  property window_name : missing value  property file_path : missing value  property my_parent_path : missing value  property last_choice_file_path : missing value  property last_choice : missing value  property CUCUMBER_COMMAND : "clear; bundle exec cucumber -r features/"  property RSPEC_COMMAND : "clear; bundle exec rspec"  on initWithFilepath(filepath)    set file_path to filepath    continueProcess()  end initWithFilepath  on init()    set_window_name()    set_file_path()    continueProcess()  end init  on continueProcess()    set_ruby_path()    set_last_choice_file_path()    process_file()  end continueProcess  on set_ruby_path()    set my_path to (path to me as Unicode text)    tell application "Finder"      set my_parent_path to parent of alias my_path as string    end tell    set ruby_path to (my_parent_path & "parse_file.rb")    set ruby_file_path to quoted form of POSIX path of ruby_path  end set_ruby_path  on set_last_choice_file_path()    set last_choice_file_path to my_parent_path & "last_choice.txt" as string    try      set last_choice to read_last_choice_from_file()    on error      write_to_file(RUN_EM_ALL)    end try  end set_last_choice_file_path  on set_window_name()    activate application "MacVim"    tell application "MacVim"      set window_name to name of window 1    end tell  end set_window_name  on set_file_path()    set the_parts to tidStuff(space, window_name)    set root_path to item -1 of the_parts    set file_path to item 1 of the_parts    set file_path to root_path & "/" & file_path  end set_file_path  on process_file()    set last_path_component to item -1 of tidStuff(".", file_path)    set file_name to item -1 of tidStuff("/", file_path)    if last_path_component is "feature" or file_name contains "spec" then      set test_list to lines_to_choose_from_in_file(file_path)      set chosen_test_line_number to choose_test_from_test_list(test_list)      if chosen_test_line_number is false then return      set line_number to ""      if chosen_test_line_number is not RUN_EM_ALL then        set line_number to ":" & chosen_test_line_number      end if      if file_path contains "spec" then        set cmd to RSPEC_COMMAND & space & file_path & line_number & space & "--drb --color"        run_cmd_in_iterm(cmd)      else        set cmd to CUCUMBER_COMMAND & space & file_path & line_number & space & "--drb"        run_cmd_in_iterm(cmd)      end if      tell application "MacVim" to activate    else      tell me to activate      display dialog "The selected buffer is not a spec or feature file." buttons {"OK"} default button 1      tell application "MacVim" to activate    end if  end process_file  on choose_test_from_test_list(test_list)    set test_list to {RUN_EM_ALL} & test_list    tell me to activate    read_last_choice_from_file()    if test_list does not contain last_choice then      set last_choice to RUN_EM_ALL    end if    set test_to_execute to choose from list test_list default items {last_choice} without multiple selections allowed    if test_to_execute is false then      return false    else      set test_to_execute to item 1 of test_to_execute      write_to_file(test_to_execute)      set line_number to item 1 of (tidStuff(":", test_to_execute))      return line_number    end if  end choose_test_from_test_list  on lines_to_choose_from_in_file(path)    set return_value to do shell script "ruby" & space & ruby_file_path & space & quoted form of path    return paragraphs of return_value  end lines_to_choose_from_in_file  on run_cmd_in_iterm(cmd)    tell application "iTerm"      tell current session of terminal 1        write text cmd      end tell    end tell  end run_cmd_in_iterm  on write_to_file(content)    set fpath to POSIX path of last_choice_file_path    do shell script "echo " & quoted form of content & " > " & fpath  end write_to_file  on read_last_choice_from_file()    set file_contents to read file last_choice_file_path    set last_choice to snr(file_contents, ASCII character 10, "")    if length of last_choice is less than 2 then      set last_choice to RUN_EM_ALL    end if  end read_last_choice_from_file  on dialog(msg)    tell me to activate    tell application "System Events"      display dialog "*" & msg & "*"    end tell  end dialogend script#-----------------------------------------------------------------# Execution#-----------------------------------------------------------------on run(argv)  #if item 1 of argv is not "" then  #  set file_path to item 1 of argv  #  tell RunMacVimTestInTerminal to initWithFilepath(file_path)  #else    tell RunMacVimTestInTerminal to init()  #endend run#-----------------------------------------------------------------# helpers#-----------------------------------------------------------------on tidStuff(paramHere, textHere)  set OLDtid to AppleScript's text item delimiters  set AppleScript's text item delimiters to paramHere  set theItems to text items of textHere  set AppleScript's text item delimiters to OLDtid  return theItemsend tidStuffon snr(the_string, search_string, replace_string)  tell (a reference to AppleScript's text item delimiters)    set {old_tid, contents} to {contents, search_string}    set {the_string, contents} to {the_string's text items, replace_string}    set {the_string, contents} to {the_string as Unicode text, old_tid}  end tell  return the_stringend snr