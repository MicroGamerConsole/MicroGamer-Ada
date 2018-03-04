import mido
import time
import sys
import os

selected_channel = 14

def Valid_Msg(msg):
    return (msg.type == 'note_on' or msg.type == 'note_off' or msg.type == 'set_tempo') and \
           (msg.is_meta or msg.channel == selected_channel)

filename=os.path.abspath(sys.argv[1])

playing = 0 # the current playing note
time_acc = 0 # time accumulator
output = ""

for msg in mido.midifiles.MidiFile(filename):
    # print str (msg)

    if Valid_Msg (msg):
        if msg.type == 'set_tempo':
            time_acc += msg.time * 1000
        elif msg.type == 'note_off':
            if playing == msg.note:
                time_acc += msg.time * 1000
                if time_acc != 0:
                    output += "    (Wait,    %d),\n" % time_acc
                output += "    (Note_On, Silence),\n"
                playing = 0
                time_acc = 0
            else:
                time_acc += msg.time * 1000
        elif msg.type == 'note_on':
           time_acc += msg.time * 1000
           if time_acc != 0:
               output += "    (Wait,    %d),\n" % time_acc
           output += "    (Note_On, %d),\n" % (msg.note)
           time_acc = 0
           playing = msg.note

print "pragma Style_Checks (Off);"
print "with Micro_Gamer.Sound; use Micro_Gamer.Sound;"
print "package Song is"
print "   Data : aliased constant Micro_Gamer.Sound.Melody :="
print "   ("
print output
print "    (Note_On, Silence));"
print
print "   The_Melody : constant Melody_Access := Data'Access;"
print "end Song;"
