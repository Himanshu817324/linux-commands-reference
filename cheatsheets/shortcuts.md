# Linux Keyboard Shortcuts and Tips

## Bash Shortcuts

Ctrl + A            # Move to beginning of line
Ctrl + E            # Move to end of line
Ctrl + U            # Clear line before cursor
Ctrl + K            # Clear line after cursor
Ctrl + W            # Delete word before cursor
Ctrl + L            # Clear screen
Ctrl + R            # Search command history
Ctrl + C            # Cancel current command
Ctrl + Z            # Suspend current process
Ctrl + D            # Exit shell/EOF


## Navigation Shortcuts
bash!!                  # Repeat last command
!n                  # Execute command n from history
!string             # Execute last command starting with string
cd -                # Go to previous directory
cd ~                # Go to home directory
cd ..               # Go up one directory
pushd /path         # Save current dir and change
popd                # Return to saved directory



## File Operations Shortcuts
bashls -ltr             # List by time (newest last)
ls -lSr             # List by size (largest last)
mkdir -p path/to/dir # Create nested directories
cp file{,.bak}      # Quick backup: file -> file.bak
mv file{.old,.new}  # Rename: file.old -> file.new
rm !(pattern)       # Delete all except pattern

## Text Editing Shortcuts (Vi/Vim)
bashi                   # Insert mode
Esc                 # Command mode
:w                  # Save file
:q                  # Quit
:wq or ZZ           # Save and quit
:q!                 # Quit without saving
dd                  # Delete line
yy                  # Copy line
p                   # Paste
u                   # Undo
/pattern            # Search forward
?pattern            # Search backward
:%s/old/new/g       # Replace all occurrences



## Command Line Editing
bashTab                 # Auto-complete
Tab Tab             # Show all possibilities
Alt + .             # Last argument of previous command
Ctrl + X, Ctrl + E  # Edit command in editor
history | grep cmd  # Search command history


## Parameter Expansion
bash${var:-default}     # Use default if var is unset
${var:=default}     # Set var to default if unset
${#var}             # Length of var
${var%pattern}      # Remove shortest match from end
${var%%pattern}     # Remove longest match from end
${var#pattern}      # Remove shortest match from beginning
${var##pattern}     # Remove longest match from beginning
${var/pattern/replacement} # Replace first match
${var//pattern/replacement} # Replace all matches



## Brace Expansion
bashecho {1..10}        # 1 2 3 4 5 6 7 8 9 10
echo {a..z}         # a b c d e f g h i j k l m n o p q r s t u v w x y z
mkdir dir{1,2,3}    # Create dir1, dir2, dir3
cp file.txt{,.bak}  # Copy file.txt to file.txt.bak