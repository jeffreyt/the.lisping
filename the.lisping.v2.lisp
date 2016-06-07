;;;;    File: JEFFREYT5.LISP
;;;;    Assignment06: My Game
;;;;    Jeffrey Tamashiro, ICS313, 04.11.2014

;;;---------------------Defined Parameters---------------------

;; Defines allowed commands for user
(defparameter *allowed-commands* '(quit exit help h ? look walk move pickup get drop inventory i enter leave play press pull shine))

;; symbol and description string for each area in the game
(defparameter *nodes* '(
	(entrance ("~%  You are at the entrance to the historic Overlook Hotel.  It is a rustic, lodge style inn with front-facing bay windows and a steeple tower up on top.  Although quaint, it is quite large and could probably accommodate over 200 guests. ~%There is a SIGN out in front.~%"))
	(hedges("~%  You are looking at a 13 foot tall wall of hedges extending a half mile in both directions.  ~%  Square in front of you is a GATE, leading into the topiary labyrinth.~%"))
	(lobby("~%  You are in the Native American themed 'Colorado Lounge.'  It's cream colored walls are complemented by large red columns that stretch up to a high ceiling adorned with many glass chandeliers.  Large bay windows let natural light shine through to its many surrounding rooms and a large fireplace sits at its rear wall.~%  There is a TYPEWRITER sitting on a desk with a single chair is the center of the lounge.~%"))
	(kitchen("~%  You are in a large service kitchen equipped for a staff of fifty to prepare meals for several hundred patrons.  Long counters of stainless steel stretch from end to end and it is surrounded by racks, ovens, and every cooking instrument imaginable.~%  There is a large walk-in PANTRY to your left.~%"))
	(gold-room("~%  You are in a large empty banquet hall.  All the chairs are stacked neatly and carpets are rolled and stood up in the corner. All lights are off except the BAR which seems to give off a white glow.~%"))
	(office("~%  You are in the manager's office.  Behind his desk is a window that somehow faces outside.  There is a RADIO on a table to your right.~%"))
	(staircase("~%  You are standing at the top of the staircase. It would be a real shame if you took a tumble from here. There are hallways stretching out to your right, left, and front. ~%"))
	(north-hall("~%  You are in the north hallway. There are standard guest rooms on either side of you and an ELEVATOR at the far end of the hall.~%"))
	(west-hall("~%  You are in the west hallway. Your are startled immediately by creepy TWINS standing in front of you. What are they doing here?~%"))
	(east-hall("~%  You are in the east hallway.  Further down are the staff's quarters.  As you walk down the hall, you see ROOM-237 on your right.~%"))
	(staff("~%  This is where you and your family stay. It is a small yet cozy space where you and your family can spend the peaceful winter nights.~%  It looks like your son has done something mischievous on the CLOSET door, that little ragamuffin.~%"))
;; SECIAL LOCATIONS	
	(room-237("~%  Looks like any other room except the bathroom light appears to be on. You cautiously crane your neck and in the large porcelain bathtub you see a shadowy figure behind the CURTAIN.~%  When you are ready, you may LEAVE.~%"))
	(pantry("~%  You carefully prop open the door using your multi-purpose rock and step into the PANTRY. You marvel at the quantity of the various food stuffs lining the shelves.~%  You may LEAVE after you are done.~%"))
	(maze("~%  Using your map, you successfully navigate to the center of the maze. Contented with your accomplishment, you take a short break to relax on a bench and gaze up at the beautiful moon and stars  shining down on you.~%  When you are ready, you may LEAVE.~%"))
	(inventory())
))

;; Describes how each node is connected: current-node (connected-node, direction) 
(defparameter *edges* '(
;; OUTSIDE
	(entrance (lobby north) (hedges west))
	(hedges (entrance east))
;; FIRST FLOOR
	(lobby (entrance south) (kitchen west) (gold-room north) (office east) (staircase upstairs))
	(kitchen (lobby east))
	(gold-room (lobby south))			
	(office (lobby west))
;; SECOND FLOOR
	(staircase (lobby downstairs) (west-hall west) (north-hall north) (east-hall east))
	(west-hall (staircase east))
	(north-hall (staircase south))
	(east-hall (staircase west) (staff east))
	(staff (east-hall west))
))
;; Objects can be picked up, dropped and looked at
(defparameter *objects* '(
	(axe("~%  An essential item for surviving the harsh winter, the AXE has a solid wooden handle and recently sharpened blade.  It feels good in your hands.~%"))
	(bat("~%  Maybe when Spring rolls around you and your son can play a little ball together, assuming he survives.~%"))
	(knife("~%  This is a 10 inch long chef's knife with forged steel, the perfect 'all' purpose blade.~%"))
	(shotgun("~%  A 12 gauge, double barrelled, semi-automatic shotgun made of cobalt blue steel with a walnut stock."))
	(rock("~%  Just your garden variety rock. It could be used for any number of things like cracking open a walnut, holding a door open, or bludgeoning your family to death."))
	(oregano("~%  Upon closer inspection, this bottle has a hand-written label that simply says 'Dick Hallorann's Special Blend'. Don't forget you're in Colorado."))
	(snack("~%  A large potato sack filled with chips, cookies, soda, crackers, hot pockets, candy, chocolate, pizza bagels, and chocolate ice cream.~%"))
	(key("~%  It is clearly one of the hotel's room keys attached to a red plastic tag with 'Room 237' embossed in white.~%"))
	(map("~%  An overhead perspective of the hotel's hedge maze with an image of the hotel to maintain orientation.~%"))
	(boots("~%  A workman's pair of tall rubber boots, perfect for keeping your socks dry."))
	(blu-ray("~%  Stanley Kubrick's classic 1968 film '2001: A Space Oddessy' with commentary,  featurette, and concept art. A true collectors item.~%"))
	(toy("~%  A red fire-truck, one of many toys belonging to your Son. It drives you insane when he leaves them out.~%"))
	(writers-block("~%  A block of wood representing your six year struggle to produce anything of the written word. It is unclear whether this is an actual block of wood you picked up and tote symbolically, or your psychosis has evolved to the point where hallucinations feel solid in your hands.  Either way it takes up a slot in your inventory.~%"))
))

;; These are similar to objects but cannot be picked up
;; although they can be interacted with in other ways
(defparameter *set-pieces* '(
	(sign ("~%  The SIGN reads:~% 'NORTH: Overlook Hotel~%  WEST: Hedge Maze~%  If you need HELP with anything, just ask.'"))
	(gate("~%  It is a wooden GATE, held shut by a thin piece of rope.  There is a carved sign that simply says 'Prize Inside'.~%Why not try ENTERing it?"))
	(typewriter("~%  The German crafted mechanical TYPEWRITER is sitting alongside a pack of cigarettes and a stack of clean white paper.  The keys seem calling to your fingers, inviting you to caress them with your literary prowess.~%  Why not try TYPEing something?"))
	(bar("~%  The wooden BAR is backed with an inset light track behind milky white glass giving it an eerie glow.  Sitting plainly on the well-polished grain is a wide-mouthed rock tumbler with two fingers of bourbon and a single large ice cube.~%  How did you know what it was? I guess you could DRINK it and find out."))
	(pantry("~%  The large steel door has a single square window, looking through it, you get an idea how deep the walk-in goes. The door is sealed shut with air-tight rubber moulding edge that keeps all the food items in a perfectly regulated environment.~%  Why not try ENTERing it?"))
	(radio("~%  It's a citizens band radio with matching desk microphone. It appears someone has removed the lid and removed the flux capacitor.  You assume it's broken.~%"))
	(elevator("~%  You walk up to the large red double-door elevators. They have floor indicator arrows above them and a single white button between them.~%  Why not try PRESSing it?"))
	(twins("~%  Standing before you are twin girls wearing matching blue dresses, white knee-high socks and black strapped shoes. They appear to be your Son's age, which you think is about six or seven. They speak creepily in unison: 'Come PLAY with us.'"))
	(closet("~%  It appears your son has taken your wife's lipstick and written 'REDRUM' on the closet door. What could he possibly mean by that? If only you had a way to decipher this enigmatic message. Also there is a MIRROR adjacent to the door.~%"))
	(room-237("~%  Like the other rooms it has dark brown door with polished brass numbering. Looking at it, you feel drawn to the room. You even unintentionally raise your hand towards the knob.~%    Why not try ENTERing it?"))
	(curtain("~%  As you creep across the tiled floor to get a better look, your hear some faint splashing sounds. The CURTAIN is fully covering the interior of the bathtub.~%   Do you dare try PULLing it?"))
))
;; Locations of objects
(defparameter *object-locations* '(
	(entrance(axe))
	(hedges(rock))
	(maze(key))
	(lobby())
	(kitchen(knife oregano))
	(pantry(snack))
	(gold-room(shotgun))
	(office(boots))
	(staircase(bat))
	(north-hall())
	(west-hall())
	(east-hall())
	(staff(toy))
	(room-237())
	(nowhere (blu-ray map))
	(inventory (writers-block))
))
;; Locations of set-pieces
(defparameter *set-piece-locations* '(
	(entrance (sign))
	(hedges (gate))
	(lobby(typewriter guide))
	(kitchen(pantry))
	(pantry())
	(gold-room(bar))
	(office(radio))
	(staircase())
	(north-hall(elevator))
	(west-hall(twins))
	(east-hall(room-237))
	(room-237 (curtain))
	(staff(closet mirror))
))

(defparameter *played* nil)
(defparameter *pressed* nil)
(defparameter *lost* nil)

(defparameter *location* 'entrance)

;; The intro phrase greeting the player when first starting the game
(defparameter *intro* "  After a six hour car ride deep into the Colorado rocky mountains, you and your wife and son pile out of the family station wagon. You are standing in front of The Overlook hotel where you have agreed to a 5 month duty as the winter caretaker.~%  Although some would be daunted by the desolate isolation, the hotel's auspicious origin as an Indian burial ground, and the gruesome circumstances with which previous caretakers ended their tenure, you are unconcerned and simply looking forward to the peace and quiet to finish writing your novel.  A light snow begins to fall.~%    Why not have a LOOK around?")

;;;---------------------Look Functions---------------------

;;; function LOOK
;;; LOOK gives the location description, available objects, and traversable pathways
;;; LOOK AT <THING> gives player a detailed description of something, often with crucial hints 
(defun look (&optional at thing &rest rest)
	(cond 
		((null (and at thing))										;look
			(append
				(list (format nil (caadr (assoc *location* *nodes*))))
				(describe-paths *location* *edges*)
				(list-objects *location*)
			)
		)
		((and (eq thing 'mirror) (eq *location* 'staff))	;don't look in the mirror
			(mirror-death)
		)
		((member thing (union (cadr (assoc 'inventory *object-locations*))(cadr (assoc *location* *object-locations*))))
			(format nil (caadr (assoc thing *objects*)))			;look at <object>
		)
		((member thing (cadr (assoc *location* *set-piece-locations*)))		
			(format nil (caadr (assoc thing *set-pieces*)))			;look at <set-piece>
		)
		(t '(you cant look at that))
	)
)
;;; function LIST-OBJECT
;;; lists out objects close by in readable form
(defun list-object (obj)
		(format nil "There is a ~A on the floor.~%" (symbol-name obj))
)
;;; function OBJECTS-AT
;;; returns list of objects at a given location
(defun objects-at(loc)
	(cadr (assoc loc *object-locations*))
)
;;; function IS-AT
;;; boolean indicating if an object is at a location
(defun is-at(obj loc)
	(member obj (objects-at loc))
)
;;; function LIST-OBJECTS
;;;     Takes three parameters, loc, objs, obj-loc
;;;     Returns description of objects that are at a specific location
(defun list-objects (loc)
    (append (mapcar 'list-object (objects-at loc))))
	  
;;; function DESCRIBE-PATH
;;;     Takes parameters edge
;;;     Returns description of desired path
(defun describe-path (edge)
  (format nil "You can go ~A from here.~%" (cadr edge)))
  
;;; function DESCRIBE-PATHS
;;;     Takes two parameters, location nodes
;;;     Returns description of all possible paths, based on location
(defun describe-paths (location edges)
  (append (mapcar 'describe-path (cdr (assoc location edges)))))
	
;;;---------------------Action Functions---------------------

;;; function WALK, MOVE
;;;     Takes parameter direction
;;;     Moves player to a different location (or doesn't)
(defun walk (direction)
  (labels ((correct-way (edge)
             (eq (cadr edge) direction)))
    (let ((next (find-if #'correct-way (cdr (assoc *location* *edges*)))))
      (if next 
          (progn (setf *location* (car next)) 
                 (look))
          '(you cannot go that way.)))))
(defun move (dir) (walk dir))

;;; function ENTER
;;; certain locations need to be ENTERED, 
;;; these are like traps if you don't have the necessary
;;; item you may lose the game
(defun enter (&rest rest)
	(cond 
		((null rest)
			'("Enter where?"))
		((and (eq *location* 'hedges) (have 'map))
				(setf *location* 'maze) (look))
		((and (eq *location* 'hedges) (not (have 'map)))
				(setf *lost* t)
				(concatenate 'string
					(format nil "~%  You wander aimlessly around the corners of the maze for hours. As the night gets darker, you get colder and more desperate. You curse your wretched family for not coming to save you. You start to fantasize about running them over with the snowcat.~%")
					(format nil "  All of a sudden they are standing if front of you, you reach up and ")
					(kill-family)
					(format nil "  Horrified by your actions, you bury your head in the blood soaked snow, sobbing.  You freeze to death before the sun comes up.~%")
				))
		((and (eq *location* 'kitchen) (have 'rock))
				(setf *location* 'pantry) (look))
		((and (eq *location* 'kitchen) (not (have 'rock)))
				(setf *lost* t)
				(concatenate 'string
					(format nil "~%  You excitedly enter the pantry to look at all the treats inside. The door slams shut behind you locking you in. You quickly do some calculations and realize that if no one finds you, you will be dead from starvation in 5 years. After an hour of screaming your head off, you are overtaken by rage and eat a whole jar of maraschino cherries, drinking all the syrup.~%  Your family finally comes in hungry from playing in the maze all day. High on sugar, you lunge at them and ")
					(kill-family)
					(format nil "  As you awaken from your sugar induced coma you are sick to your stomach by what you've done. You drown your sorrow by eating tube after tube of raw cookie dough. They find your bloated body months later. Doctors will mistakenly go on to label your psychosis 'cookie fever' If only you had something to prop open the door.~%")
				))
		((and (eq *location* 'east-hall) (have 'key))
				(setf *location* 'room-237) (look))
		((and (eq *location* 'east-hall) (is-at 'key 'room-237))
				(setf *lost* t)
				(format nil "~%  You locked the room key in the room. This means you cannot win. You have found the stupidest way to lose the game, Congratulations."))
		((and (eq *location* 'east-hall) (not (have 'key)))
				(format nil "~%  It's locked. This is a hotel after all."))	
		(t
			(format nil "~%  You cannot enter like that now."))
	)
)
;;; function LEAVE
;;; leaves a special location, corresponds to enter action
(defun leave (&rest rest)
	(cond 
		((eq *location* 'maze)
				(setf *location* 'hedges) (look))
		((eq *location* 'pantry)
				(setf *location* 'kitchen) (look))
		((eq *location* 'room-237)
				(setf *location* 'east-hall) (look))		
		(t
			'(you cannot leave like that))
	)
)
;;; function PEN, WRITE, TYPE
;;; type something
;;; need to drop writer's block
(defun pen (&rest rest)
	(cond 
		((null rest)
			'("Type what?"))
		((and (eq *location* 'lobby) (have 'writers-block))
				(format nil "You sit down to type and nothing comes out, if only you could get rid of that darn writer's block."))
		((and (eq *location* 'lobby) (not (have 'writers-block)))
				(happy-end))
		(t
			(format nil "You have can't type anything here"))
	)
)
;;; function PLAY
;;; play with twins
;;; need:toy, get:map, else:lose
(defun play (&rest rest)
	(cond 
		((null rest)
			'("Play what?"))
		((and (eq *location* 'west-hall) *played*)
				(format nil "You already played with them enough."))
		((and (eq *location* 'west-hall) (not (have 'toy)))
				(setf *lost* t)
				(concatenate 'string
					(format nil "~%  The Twins are happy you agree but their delight quickly turns to anger when they realize you have nothing fun to play with. They proceed to torture you with grizzly images of their murder by axe at the hand of their disturbed father.~%")
					(format nil "  This makes you pretty crazy so you run into the lounge where they are watching American Idol and ")
					(kill-family)
					(format nil "  Horrified by your actions, you get a rope and hang yourself from one of the chandeliers.~%")
				))
		((and (eq *location* 'west-hall) (have 'toy))
				(transfer 'map 'nowhere 'west-hall)
				(setf *pressed* t)	
				(format nil "The twins gleefully snatch the toy truck you are carrying and roll it over the red carpeting. In their excitement they drop a what looks like a map on the ground in front of you."))
		(t
			(format nil "You have no one to play with."))
	)
)

;;; function PRESS
;;; press button
;;; need:boots, get:blu-ray, else:lose
(defun press (&rest rest)
	(cond 
		((null rest)
			'("Press what?"))
		((and (eq *location* 'north-hall) *pressed*)
				(format nil "The Elevator doors are already open and the floor is covered in blood, you press the button to no affect."))
		((and (eq *location* 'north-hall) (not (have 'boots)))
				(setf *lost* t)
				(concatenate 'string (format nil "A wave of blood flows from the elevators washing over you up to your ankles.  You grimace feeling the wetness soaking though your socks and onto your feet.  Given your combined Hemophobia and Podophobia conditions you snap and are driven to")(kill-family)))
		((and (eq *location* 'north-hall) (have 'boots))
				(transfer 'blu-ray 'nowhere 'north-hall)
				(setf *pressed* t)
				(format nil "A wave of blood flows from the elevators washing over you up to your ankles. Thank god you have those rubber boots, which keep your feet dry as a bone. As the blood wave thins out across the floor and pours down the staircase, you see a rectangular blu-ray case near your feet."))
		(t
			'(you cannot press anything now))
	)
)

;;; function DRINK
;;; lose no matter what, so don't drink
(defun drink (&rest rest)
	(cond 
		((null rest)
			'("Drink what?"))
		((eq *location* 'gold-room)
			(setf *lost* t)
			'(you die))
		(t
			'(you cannot drink like that))
	)
)

;;; function PULL
;;; action leading to last boss, need key to enter room 237
(defun pull (&optional something &rest rest)
	(cond 
		((null something)
			'("Pull what?"))
		((and (eq *location* 'room-237) (eq something 'curtain))
				(last-boss))
		(t
			(format nil "You can't do that here."))
	)
)
;;; function LAST-BOSS
;;; need three items to proceed
(defun last-boss()
	(princ "	As you pull back the curtain the steam clears and a young woman stands up out of the bathtub. You are mesmerized by her beauty and momentarily forget you are happily married. Your stupor is shattered when, in an instant, the beautiful woman changes into a wrinkled old crone with festering sores all over her skin. She cackles a horrible cackle that disorients you, constricting all your muscles, literally petrifying you in place.") (terpri)
	(princ "The crone pierces you with her marble black eyes and speaks in a shrill tone, cutting you to the core,")(terpri)(terpri)
	(princ "	\"Did you procure the items three I requested?\"")(terpri)(terpri)
	(if (y-or-n-p "Your answer--> ") 
		(cond 
			((and (have 'snack) (have 'blu-ray) (have 'oregano))
				(victory))
			(t
				(setf *lost* t)
				(format nil "As punishment for lying, the Crone drowns you in the bathtub and enslaves your family to wash the part of her back she can't reach for all of eternity."))
		)
		(progn
			(setf *location* 'east-hall)
			(terpri)(terpri)(terpri)
			(princ "THEN GET OUT!!!")(terpri)(terpri)(terpri)(terpri)
			(princ "...............")(terpri)(terpri)(terpri)(terpri)
			'("Your wake up in a cold sweat outside room 237")		
		)
	)	
)
;;; upon getting three items, writers block removed
(defun victory ()
	(transfer 'snack 'inventory 'nowhere)
	(transfer 'blu-ray 'inventory 'nowhere)
	(transfer 'oregano 'inventory 'nowhere)
	(transfer 'writers-block 'inventory 'nowhere)
	(format nil "~%  The crone collects the three items, looks them over and beams a wide smile transforming her back into a beautiful woman. You follow her into the living room where you both relax on the couch, pop in the 2001 blu-ray, indulge in the 'oregano', and start devouring the bounty of snacks. ~%As that scene with the trippy, technicolor lights plays and you are at a [9], you feel the weight of the WRITERS-BLOCK disappear from your inventory. You look over to the crone and see she is gone, a beam of light from outside shining right where she was sitting. It is the morning.")
)
;;; upon finishing novel
(defun happy-end()
	(setf *lost* t)
	(format nil "~%  You settle down in front of your typewriter. Your fingers rest on the keyboard. It feels both familiar and mysterious, like reconnecting with a old friend. You close your eyes and draw in a deep breath -- in the distance you hear sounds of your dutiful wife and weird son laughing and playing. Upon exhalation your fingers begin to move, and they don't stop. Sheet after sheet goes in white and comes out filled with pressed inky letters forming words, forming sentences, forming paragraphs, forming pages, forming chapters, forming magic, forming you.~%~%Three years later...~%~%  Your book has spent 120 consecutive weeks on the New York Times Best Seller List. It is seen as a Post-Modern masterpiece, speaking to the truth of the human condition. It is hailed by critics and garnered widespread appeal after Oprah selected it for her book of the month. It is said to contain allusions to Post-Colonial Westward Expansion, The Holocaust, and even Cold War Space-Race Anxieties. Many consider it a compendium of all human history encapsulated within its titular phrase: 'All work and no play makes Jack a dull boy.' this eponymous phrase is repeated 28,231 times, filling the book's 427 pages. It is widely seen as a seminal work and there is a national movement for it to be taught in Freshman English classes. Noam Chomsky is quoted as saying 'I read it from cover to cover. I didn't know what would come next.' Hollywood is in talks with Spielberg to direct the film adaptation.~%  As for you, wealth and fame hasn't changed you much. You're still the winter caretaker at that old Overlook Hotel, checking on the pipes and whatnot. You don't write much any more, you just pass the time with your family. Your son is getting bigger and the two of you go mountain biking when the weather is nice. You and your wife are famous for throwing the most best new year's party in town. You might just say you are living happily ever after.~%~% Of course, you still keep an AXE under you bed, just in case.")
)

(defun kill-family()
	(let ((weapon (random-choose (weapons-list))))
		(cond 
			((eq weapon 'axe)
				(format nil "chop your family into small chunks and use them for kindling.~%"))
			((eq weapon 'knife)
				(format nil "carve your family up like a Christmas goose then bake them at 350 degrees for 4 hours, turning them twice and basting every half hour.~%"))
			((eq weapon 'shotgun)
				(format nil "force your family to play Russian Roulette which is a really short game when playing with a shotgun. Plus you cheated.~%"))
			((eq weapon 'bat)
				(format nil "imitate your idol Ted Williams using your family's heads for batting practice.~%"))
			(t 
				(format nil "strangle your family to death with your bare hands because you have no other weapons.~%"))
		)
	)
)

(defun mirror-death ()
	(setf *lost* t)
	(concatenate 'string
		(format nil "Looking in the mirror you see the reflected words scrawled on the closet door by your only son actually spell out the word 'MURDER'.  You realize he is picking up on your subconscious desires to become unencumbered by him and his Mother and are tortured by the knowledge that you brought him into this world only to tell him he in unwanted.~%  You take a deep breath and call your family into the room.  You then proceed to ")
		(kill-family)
		(format nil "  You catch a glimpse of yourself in the mirror, standing over their now lifeless bodies. This sobering image immediately fills with shame and regret and you throw yourself from the second story window onto a pile of fluffy snow. Then you get a gun a shoot yourself."))
)

;;;---------------------Inventory Functions------------------

;;; function TRANSFER
(defun transfer (item from_loc to_loc)
	(let ((temp (remove item (cadr (assoc from_loc *object-locations*)))))
		(setf (cadr (assoc from_loc *object-locations*)) temp)	;remove from old location
		(push item (cadr (assoc to_loc *object-locations*)))	;add to new location
	)
)
;;; function PICKUP
;;;     Takes parameter object
;;;     Moves object to player's inventory
(defun pickup (&optional item &rest rest)
	(cond
		((null item) 
			'(pickup what?))
		((<= 4 (length (objects-at 'inventory)))
			(format nil "You cannot carry more than 4 items at a time.  Try DROPping something."))
		((member item (objects-at *location*))
			(transfer item *location* 'inventory)
			`(you are now carrying the ,item))
		(t '(you cannot pick that up.))
	)
) ;Alias GET

;;; function DROP
;;;     Takes parameter object
;;;     Moves object to player's inventory
(defun drop (&optional item &rest rest)
	(cond
		((null item) 
			'(drop what?))
		((eq item 'writers-block)
			'(sorry this is the one thing you cannot drop.))
		((member item (objects-at 'inventory))
			(transfer item 'inventory *location*)
			`(you dropped the ,item))
		(t '(you cannot drop that.))
	)
)
;;; function INVENTORY
(defun inventory ()
	(append (list (format nil "You are carrying: "))
	(cadr (assoc 'inventory *object-locations*)))
) (defun i () (inventory)) ;Alias i

;;; function HAVE
(defun have(item)
	(is-at item 'inventory)
)
;;;---------------------Misc Functions-----------------------

;;; function HELP, H, ?
;;; prints out some useful advice
(defun help ()
	(terpri)
	(princ "-------------------------------------------------------------------")(terpri)
	(princ "HELP")(terpri)
	(princ "-------------------------------------------------------------------")(terpri)(terpri)	
	(princ "Oh Hi there, It's me Dick Hallorran, head chef of the Overlook Hotel. I also have psychic powers, but I won't bore you with that.")
	(terpri)(terpri)
	(princ "I have three pieces of advice:")
	(terpri)(terpri)
	(princ "USE YOUR EYES:")(terpri)
	(princ "-------------------------------------------------------------------")(terpri)
	(princ "LOOK - Gives you the lay of the land, where you are and where you can go.")(terpri)
	(princ "LOOK AT <THING> - Tells you more about the things around you, give it a try.")(terpri)	
	(terpri)(terpri)
	(princ "MOVE YOURSELF:")(terpri)
	(princ "-------------------------------------------------------------------")(terpri)
	(princ "MOVE, WALK, GO <DIRECTION> - It's all good, just make sure you know where you're going.")
	(terpri)(terpri)
	(princ "CHOOSE ITEMS WISELY:")(terpri)
	(princ "-------------------------------------------------------------------")(terpri)
	(princ "PICKUP <ITEM> - Put it in your pocket.")(terpri)
	(princ "DROP <ITEM> - Drops it right on the spot.")(terpri)
	(princ "INVENTORY, I - Tells you what you got, and you can only get so much.")(terpri)
	(terpri)
	(princ "There's even more too just make sure to pay attention to the HINTS.")	
	(terpri)(terpri)
	(format nil "Typing QUIT or EXIT takes you away from this crazy place & typing HELP, H, or ? shows this info again. SHINE on you crazy diamond.")
)(defun h () (help)) (defun ? () (help)) ;; Aliases h, ?

;;; function SHINE
(defun shine () 
	(format nil "Not yet, but soon...~%")
)
;;; function WEAPONS-LIST
;;; gives a list of weapons you are currently carrying, including your hands
(defun weapons-list ()
	(append '(hands) (intersection '(axe shotgun bat knife hands)(cadr (assoc 'inventory *object-locations*))))
)
;;; function RANDOM-CHOOSE
;;; randomly chooses from a list
(defun random-choose (choices)
  (elt choices (random (length choices))))
;;;---------------------UI Functions---------------------

;;; function GAME-REPL
;;;     Takes no parameter object
;;;     custom REPL that keeps user in game until quit command
(defun game-repl ()
	(if *lost* (loser)
		(let ((cmd (game-read)))
			(unless (or (eq (car cmd) 'quit)(eq (car cmd) 'exit))
				(game-print (game-eval cmd))
				(game-repl)))))
			
;;; function GAME-READ
;;;     Takes no parameter object
;;;     Read function for custom REPL
(defun game-read ()
	(terpri)(princ "What would you like to do?---> ")
    (let ((cmd (read-from-string (concatenate 'string "(" (read-line) ")"))))
         (flet ((quote-it (x)
                    (list 'quote x)))
             (cons (car cmd) (mapcar #'quote-it (cdr cmd))))))
			 
;;; function GAME-EVAL
;;;     Takes command from user's input
;;;     Eval function for custom REPL
(defun game-eval (sexp)
	(cond 
		((eq 'go (car sexp))
			(progn (rplaca sexp 'walk)(eval sexp)))
		((eq 'get (car sexp))
			(progn (rplaca sexp 'pickup)(eval sexp)))		
		((or (eq 'write (car sexp))(eq 'type (car sexp)))
			(progn (rplaca sexp 'pen)(eval sexp)))		
		((member (car sexp) *allowed-commands*)
			(eval sexp))
		(t '(i do not know that command.))
	)
)

;;; function TWEAK-TEXT
;;;		takes 1st caps lit parameters
;;;     Formats text for output text
(defun tweak-text (lst caps lit)
  (when lst
    (let ((item (car lst))
          (rest (cdr lst)))
      (cond ((eql item #\space) (cons item (tweak-text rest caps lit)))
            ((member item '(#\! #\? #\.)) (cons item (tweak-text rest t lit)))
            ((eql item #\") (tweak-text rest caps (not lit)))
            (lit (cons item (tweak-text rest nil lit)))
            (caps (cons (char-upcase item) (tweak-text rest nil lit)))
            (t (cons (char-downcase item) (tweak-text rest nil nil)))))))
			
;;; function GAME-PRINT
;;;		takes 1st parameter
;;;     Eval function for custom REPL
(defun game-print (lst)
    (princ (coerce (tweak-text (coerce (string-trim "() " (prin1-to-string lst)) 'list) t nil) 'string))
    (fresh-line))
	
(defun loser ()
	(if (y-or-n-p "Play again--> ") (reset)(quit))
)

(defun reset()
	(setf *object-locations* '(
		(entrance(axe))
		(hedges(rock))
		(maze(key))
		(lobby())
		(kitchen(knife oregano))
		(pantry(snack))
		(gold-room(shotgun))
		(office(boots))
		(staircase(bat))
		(north-hall())
		(west-hall())
		(east-hall())
		(staff(toy))
		(room-237())
		(nowhere (blu-ray map))
		(inventory (writers-block))
	))
	(setf *set-piece-locations* '(
		(entrance (sign))
		(hedges (gate))
		(lobby(typewriter guide))
		(kitchen(pantry))
		(pantry())
		(gold-room(bar))
		(office(radio))
		(staircase())
		(north-hall(elevator))
		(west-hall(twins))
		(east-hall(room237))
		(staff(closet mirror))
	))

	(setf *played* nil)
	(setf *pressed* nil)
	(setf *lost* nil)

	(setf *location* 'entrance)
		
	(format t *intro*)(terpri)
	(game-repl)
)

;;;---------------------Game Execution---------------------

(format t *intro*)(terpri)
(game-repl)
