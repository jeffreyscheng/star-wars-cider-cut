"""Canonical clip data for the Optimal Cut v7.

Each clip: (clip_id, chapter, label, source_key, start_cue, end_cue, runtime_est, flags)
source_key maps to SRT/MP4 filenames via source_to_files().
"""
import re

# ─── Source-to-filename mapping ───────────────────────────────────────────

_SOURCE_MAP = {
    "TPM": ["episode_1_the_phantom_menace"],
    "AOTC": ["episode_2_attack_of_the_clones"],
    "ROTS": ["episode_3_revenge_of_the_sith"],
}

_CW_RE = re.compile(r"CW S(\d+)E(\d+)(?:-(\d+))?")
_TOTJ_RE = re.compile(r"TotJ S(\d+)E(\d+)")


def source_to_files(source_key: str) -> list[str]:
    """Map a clip source string to canonical file stems (no extension)."""
    if source_key in ("Editorial", ""):
        return []
    # Check static map first
    for key, files in _SOURCE_MAP.items():
        if source_key == key:
            return files

    files = []
    # Handle compound sources like "TotJ S1E04 + ROTS" or "CW S6E06-07"
    parts = re.split(r"\s*\+\s*", source_key)
    for part in parts:
        part = part.strip()
        # Strip parentheticals like "(audio)"
        part_clean = re.sub(r"\s*\(.*?\)", "", part).strip()
        if part_clean in _SOURCE_MAP:
            files.extend(_SOURCE_MAP[part_clean])
            continue
        if "AOTC" in part_clean:
            files.append("episode_2_attack_of_the_clones")
            continue
        if "ROTS" in part_clean:
            files.append("episode_3_revenge_of_the_sith")
            continue
        m = _CW_RE.search(part_clean)
        if m:
            s, e1 = int(m.group(1)), int(m.group(2))
            files.append(f"the_clone_wars_s{s:02d}e{e1:02d}")
            if m.group(3):
                e2 = int(m.group(3))
                for e in range(e1 + 1, e2 + 1):
                    files.append(f"the_clone_wars_s{s:02d}e{e:02d}")
            continue
        m = _TOTJ_RE.search(part_clean)
        if m:
            s, e = int(m.group(1)), int(m.group(2))
            files.append(f"tales_of_the_jedi_s{s:02d}e{e:02d}")
            continue
        # Full film names
        if "A New Hope" in part_clean:
            files.append("episode_4_a_new_hope")
        elif "Empire" in part_clean:
            files.append("episode_5_the_empire_strikes_back")
        elif "Return" in part_clean:
            files.append("episode_6_return_of_the_jedi")
    return files


# ─── Clip data ────────────────────────────────────────────────────────────
# Format: (clip_id, chapter, label, source, start_cue, end_cue, runtime_est, flags)
# flags: "" = normal, "DNC" = do not cut, "EDITORIAL" = no source video,
#        "FILM" = full untouched film, "ROTS_INSERT" = ROTS insertion point

CLIPS = [
    # ── CH1: DJEM SO ──────────────────────────────────────────
    ("1.0", "CH1", "Title Card + VO", "Editorial", "", "", "0:30", "EDITORIAL"),
    ("1.1", "CH1", "Briefing + Kill Count Banter", "CW S2E05",
     "I cannot believe we're back here again.", "May the Force be with you.", "2:30", ""),
    ("1.2", "CH1", "The Assault Begins", "CW S2E05",
     "Good thing those bugs can't aim.", "We're going down. Brace yourselves!", "3:00", ""),
    ("1.3", "CH1", "Scaling the Wall", "CW S2E05",
     "Just keep us covered, Rex.", "Come on, Rex. Up and away.", "2:00", ""),
    ("1.4", "CH1", "Briefing Bickering", "CW S2E06",
     "Master, my briefings might go better if you didn't interrupt me", "Here we go.", "2:30", ""),
    ("1.5", "CH1", "Into the Catacombs", "CW S2E06",
     "I should go in first. I know the way.", "It's not left, it's up.", "1:30", ""),
    ("1.6", "CH1", "Trapped + The Contrast", "CW S2E06",
     "Those bombs are going to go off any second now.", "I still plan on celebrating this victory with my Padawan in person.", "3:00", ""),
    ("1.7", "CH1", "The Rescue", "CW S2E06",
     "Wait. I'm picking up a pulse on Ahsoka's comm channel.", "Your Master never lost faith in you.", "1:30", ""),
    ("1.8", "CH1", "The Council Says No", "CW S1E02",
     "We've had no further contact with General Plo Koon.", "We will deploy, as you've instructed, Master.", "1:30", ""),
    ("1.9", "CH1", "Lives Are in Danger", "CW S1E02",
     "Ahsoka! If anyone could survive, Master Plo could.", "That's what I'm trying to teach you my young padawan.", "1:00", ""),
    ("1.10", "CH1", "Not to Me", "CW S1E02",
     "Sergeant, why are you so certain no one is coming?", "Your men are safe now.", "1:30", ""),
    ("1.11", "CH1", "Escape + Coda", "CW S1E02",
     "There's a massive vessel approaching.", "Right beside you, Master.", "1:30", ""),
    ("1.12", "CH1", "Ahsoka Taken", "CW S3E21",
     "I can't believe my luck. A Jedi youngling.", "The youngling will provide great sport.", "0:30", ""),
    ("1.13", "CH1", "My Master Will Never Forgive Me", "CW S3E21",
     "My master will never forgive me for running and hiding", "We are Jedi.", "1:30", ""),
    ("1.14", "CH1", "Kalifa's Death", "CW S3E21",
     "That's their fortress.", "I'll take care of the others. I know you will.", "1:30", ""),
    ("1.15", "CH1", "Anakin's Desperation", "CW S3E21",
     "Not good enough, Rex. Try again.", "she is able to take care of herself.", "1:00", ""),
    ("1.16", "CH1", "We Go Down With a Fight", "CW S3E22",
     "If it's only a matter of time that we die, I say we go down with a fight.", "Get ready, we'll have to be swift.", "1:00", ""),
    ("1.17", "CH1", "The Final Battle", "CW S3E22",
     "[Stolen speeder approaches Trandoshan fortress]", "Your son died because of your own actions. Not mine.", "2:00", ""),
    ("1.18", "CH1", "The Reunion", "CW S3E22",
     "It is good to see you safe, little Ahsoka.", "You're welcome, my Padawan.", "2:00", "DNC"),
    ("1.19", "CH1", "You Either Do or Die", "CW S3E18",
     "Ahsoka, I'm sorry I didn't tell you earlier, but you won't be coming along", "That should be my choice.", "1:30", ""),
    ("1.20", "CH1", "Following Direct Orders", "CW S3E18",
     "Hey, snips.", "Welcome aboard.", "1:00", ""),
    ("1.21", "CH1", "Ahsoka Proves Her Point", "CW S3E18",
     "Too small for you maybe, but I think I can squeeze through.", "See, I can handle myself after all.", "0:30", ""),
    ("1.22", "CH1", "Tarkin's Poison", "CW S3E19",
     "I am beginning to admire the design of this fortress.", "Well, I see we agree on something.", "2:00", ""),
    ("1.23", "CH1", "Trust and Gratitude", "CW S3E18",
     "It's when things don't go as planned that we Jedi are at our best.", "I reserve my trust for those who understand gratitude, Captain Tarkin.", "1:00", ""),
    ("1.24", "CH1", "Jedi Who Disappoint Us", "CW S5E17",
     "Master, I'm relieved we solved this case, but", "as long as we know there are good Jedi who fight for what's right", "0:30", ""),
    ("1.25", "CH1", "Warmth: Dinner and Home", "CW S7E02",
     "You're late again.", "I hope you at least told Padme I said hello.", "1:30", ""),
    ("1.26", "CH1", "Friction: The Argument", "CW S2E04",
     "Senator Amidala.", "Duty comes first, especially in wartime.", "2:30", ""),
    ("1.27", "CH1", "Devotion: Lightsaber Gift", "CW S1E22",
     "We should go away together.", "Believe me now?", "1:30", ""),
    ("1.28", "CH1", "Possession: I Demand", "CW S6E06",
     "Why didn't you just say no?", "Yes, of course. General Skywalker.", "1:00", ""),
    ("1.29", "CH1", "Palpatine's Validation", "CW S4E16",
     "You look troubled, Anakin.", "No. I won't.", "0:30", ""),
    ("1.30", "CH1", "Closing Card", "Editorial", "", "", "0:10", "EDITORIAL"),

    # ── CH2: EXPENDABLE ───────────────────────────────────────
    ("2.0", "CH2", "Not to Me Cold Open", "CW S1E02",
     "We're just clones, sir. We're meant to be expendable.", "Not to me.", "0:30", ""),
    ("2.1", "CH2", "The Shinies", "CW S1E05",
     "[Rookie clones on watch]", "This is the most boring post in the outer rim.", "1:30", ""),
    ("2.2", "CH2", "The Post Falls", "CW S1E05",
     "[Explosion / breach]", "[Rookies escape through ventilation shaft]", "2:00", ""),
    ("2.3", "CH2", "Rex Arrives", "CW S1E05",
     "[Rex and Cody's shuttle approaching]", "Nice shot. The name's Rex. But you'll call me Captain, or Sir.", "2:30", ""),
    ("2.4", "CH2", "Hevy's Sacrifice", "CW S1E05",
     "We need to destroy this station before the fleet arrives.", "[Explosion seen from orbit]", "3:00", ""),
    ("2.5", "CH2", "The Handprint", "CW S1E05",
     "[Rex, Cody, Echo, Fives in formation]", "[Rex presses Hevy's handprint onto his helmet]", "0:30", ""),
    ("2.6", "CH2", "Krell Arrives", "CW S4E07",
     "Master Krell, my thanks for the air support.", "That is all.", "1:30", ""),
    ("2.7", "CH2", "Refuses Rest", "CW S4E07",
     "Sir, we've been keeping this pace for 12 hours now.", "Do I make myself clear, CT-7567?", "1:45", ""),
    ("2.8", "CH2", "Not Clones! Men!", "CW S4E07",
     "CT-7567. Do you have a malfunction in your design?", "Dismissed.", "2:00", ""),
    ("2.9", "CH2", "Engineered to Think", "CW S4E08",
     "A few of General Skywalker's plans seemed reckless, too", "I honor my code. That's what I believe.", "1:15", ""),
    ("2.10", "CH2", "Hardcase's Sacrifice", "CW S4E09",
     "Ray shields.", "Live to fight another day.", "1:30", ""),
    ("2.11", "CH2", "The Firing Squad", "CW S4E10",
     "Will the prisoners request to be blindfolded?", "Good luck finding anyone to do it.", "1:30", ""),
    ("2.12", "CH2", "The Fratricide", "CW S4E10",
     "Stay alert. The enemy has our weapons and our armor", "What have we done?", "2:00", ""),
    ("2.13", "CH2", "Dogma Shoots Krell", "CW S4E10",
     "Something has to be done.", "I had to. He betrayed us.", "1:30", ""),
    ("2.14", "CH2", "What Happens to Us Then?", "CW S4E10",
     "We did it. We took Umbara.", "What happens to us then?", "0:45", ""),
    ("2.15", "CH2", "Closing Card", "Editorial", "", "", "0:10", "EDITORIAL"),

    # ── CH3: ATTACHMENT ────────────────────────────────────────
    ("3.1", "CH3", "Blue Squadron Launch", "CW S1E19",
     "This is my first time commanding a squadron R7", "Here we go.", "0:30", ""),
    ("3.2", "CH3", "Ahsoka Refuses to Retreat", "CW S1E19",
     "We've got their fighters occupied.", "She's not turning around.", "0:45", ""),
    ("3.3", "CH3", "The Squadron Dies", "CW S1E19",
     "Ax, are you still there?", "Jump to lightspeed.", "1:00", ""),
    ("3.4", "CH3", "Anakin's Disappointment", "CW S1E19",
     "Get your squad together. I need a head count.", "Take heart, little one. That's the reality of command.", "1:15", "DNC"),
    ("3.5", "CH3", "They're All Gone", "CW S1E19",
     "He is stable for now.", "No, R2, the other one.", "0:30", ""),
    ("3.6", "CH3", "Ahsoka Pushed to Lead", "CW S1E19",
     "You wanted to see me, Master.", "Good luck.", "1:30", ""),
    ("3.7", "CH3", "Ahsoka Improvises + Victory", "CW S1E19",
     "If we took the Resolute and angled her hull", "I'm just sitting here watching the show.", "1:30", ""),
    ("3.8", "CH3", "Brief Domestic Beat", "Editorial",
     "", "", "0:45", "EDITORIAL"),
    ("3.9", "CH3", "Temple Bombing", "CW S5E17",
     "Master Yoda.", "Then I guess we'll have to go to even greater lengths to catch him.", "1:00", ""),
    ("3.10", "CH3", "Letta Strangled / Ahsoka Framed", "CW S5E18",
     "I'm Commander Tano. Letta Turmond requested to see me.", "I did not kill that woman.", "3:00", ""),
    ("3.11", "CH3", "Escape: Wish Me Luck", "CW S5E18",
     "Ahsoka! It's me, Anakin. Stop running.", "I do trust you. Wish me luck.", "2:00", "DNC"),
    ("3.12", "CH3", "Ahsoka Contacts Barriss", "CW S5E19",
     "Barriss, it's Ahsoka.", "Thank you, Barriss. Be safe.", "0:45", ""),
    ("3.13", "CH3", "Ventress Alliance", "CW S5E19",
     "Well, well, I didn't believe it when I first heard it", "These are strange times.", "2:30", ""),
    ("3.14", "CH3", "Attacked and Recaptured", "CW S5E19",
     "That's where you're supposed to find this clue.", "We're bringing her back to the temple.", "1:30", ""),
    ("3.15", "CH3", "Council Expels Ahsoka", "CW S5E20",
     "The Senate requests that Ahsoka Tano be indicted", "Henceforth, you are barred from the Jedi Order.", "3:00", "DNC"),
    ("3.16", "CH3", "Ventress Testimony", "CW S5E20",
     "Anakin Skywalker. I know you're behind all of this.", "It was this Barriss that told us to go there.", "2:30", "DNC"),
    ("3.17", "CH3", "Barriss Confrontation / Duel", "CW S5E20",
     "Enter. Barriss, I need to talk to you.", "Cease hostility!", "3:00", "DNC"),
    ("3.18", "CH3", "Barriss's Confession", "CW S5E20",
     "The members of the court have reached a decision.", "Take her away.", "2:30", "DNC"),
    ("3.19", "CH3", "The Great Trial Offer", "CW S5E20",
     "Ahsoka, I am so sorry about everything.", "Back into the Order you may come.", "1:30", ""),
    ("3.20", "CH3", "THE DEPARTURE", "CW S5E20",
     "They're asking you back, Ahsoka. I'm asking you back.", "I know.", "3:00", "DNC"),
    ("3.21", "CH3", "Closing Card", "Editorial", "", "", "0:10", "EDITORIAL"),

    # ── ANH + ESB (untouched) ─────────────────────────────────
    ("ANH", "ANH", "A New Hope", "A New Hope (1977)", "", "", "125 min", "FILM"),
    ("ESB", "ESB", "The Empire Strikes Back", "Empire Strikes Back (1980)", "", "", "124 min", "FILM"),

    # ── CH4: CONSCIENCE ────────────────────────────────────────
    ("4.0", "CH4", "Duel Footage + Title", "Editorial", "", "", "0:15", "EDITORIAL"),
    ("4.1", "CH4", "Dooku + Qui-Gon: Corruption", "TotJ S1E02",
     "We'll be arriving shortly, Master.", "You're a much wiser man than I, Qui-Gon Jinn.", "4:30", ""),
    ("4.2", "CH4", "Dooku + Mace: Murdered Jedi", "TotJ S1E03",
     "You've been studying that tablet for a long time.", "How kind of you, Master Jedi.", "4:30", ""),
    ("4.3", "CH4", "Senate Speech", "CW S3E11",
     "Teckla Minnau.", "defeating this bill.", "1:30", ""),
    ("4.4", "CH4", "Palpatine Coda", "CW S3E11",
     "Isn't it remarkable, that one can have all the power in the galaxy", "We must let the wheels of the senate turn.", "0:30", ""),
    ("4.5", "CH4", "Yoda: Fear Is the Path", "TPM",
     "How feel you?", "I sense much fear in you.", "0:45", ""),
    ("4.6", "CH4", "The Boy Is Dangerous", "TPM",
     "The Force is strong with him.", "The boy is dangerous. They all sense it.", "2:00", ""),
    ("4.7", "CH4", "Good Apprentice", "TPM",
     "I'm sorry for my behaviour, Master.", "I foresee you will become a great Jedi knight.", "0:30", ""),
    ("4.8", "CH4", "Shmi's Goodbye", "TPM",
     "And he has been freed.", "Don't look back.", "3:00", ""),
    ("4.9", "CH4", "The Duel of the Fates", "TPM",
     "We'll handle this.", "[Qui-Gon separated by energy barriers]", "4:00", ""),
    ("4.10", "CH4", "Qui-Gon Dies", "TPM",
     "No.", "Train him.", "1:30", ""),
    ("4.11", "CH4", "Funeral + Always Two There Are", "TPM",
     "Confer on you the level of Jedi knight the council does.", "But which was destroyed? The master or the apprentice?", "2:30", ""),
    ("4.12", "CH4", "Dooku Exploitation", "CW S4E04",
     "What is to be done, my lord?", "It's all right, Ani.", "1:30", ""),
    ("4.13", "CH4", "VO: Republic Under Sith Control", "AOTC",
     "What if I told you the Republic was under the control of a Sith Lord?", "", "0:15", ""),
    ("4.14", "CH4", "Sidious Approaches Dooku", "TotJ S1E04",
     "Archive memory access.", "Then let me give you peace, Master Yaddle.", "4:30", ""),
    ("4.15", "CH4", "Kamino Erasure", "TotJ S1E04",
     "[Dooku at archive terminal]", "[Hold on empty screen]", "0:30", ""),
    ("4.16", "CH4", "Closing Card", "Editorial", "", "", "0:10", "EDITORIAL"),

    # ── CH5: SORESU ────────────────────────────────────────────
    ("5.1", "CH5", "Confession + Merrik Standoff", "CW S2E13",
     "Obi-wan, it looks like I may never see you again.", "He was going to blow up the ship.", "2:00", ""),
    ("5.2", "CH5", "Still Not Sure About the Beard", "CW S2E13",
     "How ironic to meet again", "She is indeed.", "0:30", ""),
    ("5.3", "CH5", "She Is or You?", "CW S6E06",
     "I have been looking for you.", "Then we should have no problems, should we?", "1:30", ""),
    ("5.4", "CH5", "Spider Legs", "CW S4E21",
     "I'm here at last, brother.", "I must have revenge.", "3:00", ""),
    ("5.5", "CH5", "Talzin Restores Maul", "CW S4E22",
     "Patience, brother.", "Yes, we shall start with revenge.", "3:00", ""),
    ("5.6", "CH5", "Ventress Team-Up", "CW S4E22",
     "I like your new legs. They make you look taller.", "I learned from watching you.", "3:00", ""),
    ("5.7", "CH5", "Alliance Proposed", "CW S5E14",
     "We are Sith.", "Another weakness.", "2:30", ""),
    ("5.8", "CH5", "Shadow Collective + False Flag", "CW S5E14-15",
     "Our brothers are in favor of an alliance", "Vizsla! Vizsla! Vizsla!", "3:30", ""),
    ("5.9", "CH5", "Maul Kills Vizsla", "CW S5E15",
     "I challenge you, one warrior to another.", "Rule my people.", "2:30", ""),
    ("5.10", "CH5", "Satine's Message", "CW S5E16",
     "This is a message for Obi-Wan Kenobi.", "If Kenobi comes to rescue his friend, he will have to come alone.", "1:30", ""),
    ("5.11", "CH5", "It Takes Strength", "CW S5E16",
     "It takes strength to resist the dark side.", "Only the weak embrace it.", "0:30", ""),
    ("5.12", "CH5", "Satine's Murder", "CW S5E16",
     "We meet again, Kenobi.", "Take him to his cell to rot.", "2:00", ""),
    ("5.13", "CH5", "Sidious Arrives", "CW S5E16",
     "I sense a presence", "I have other uses for you.", "3:00", ""),
    ("5.14", "CH5", "Bo-Katan Rescue", "CW S5E16",
     "It's the rebels!", "Mandalore will survive. We always survive. Now go.", "1:00", ""),
    ("5.15", "CH5", "Closing Card", "Editorial", "", "", "0:10", "EDITORIAL"),

    # ── CH6: FIVES ─────────────────────────────────────────────
    ("6.1", "CH6", "Tup Misfires", "CW S6E01",
     "It's time for phase two.", "Good soldiers follow orders.", "2:00", ""),
    ("6.2", "CH6", "Sidious Learns", "CW S6E01",
     "My lord, I have received a report", "Yes, my master.", "0:45", ""),
    ("6.3", "CH6", "Fives Discovers the Chip", "CW S6E02",
     "The scan is almost complete.", "I want him brought in alive.", "3:00", ""),
    ("6.4", "CH6", "Fives Removes His Own Chip", "CW S6E03",
     "I need to find out if what was in Tup's head is in mine.", "I'll see you on the other side.", "3:00", ""),
    ("6.5", "CH6", "Palpatine Frames Fives", "CW S6E04",
     "So this is the clone who has caused so much alarm?", "You drugged me.", "1:30", ""),
    ("6.6", "CH6", "Fox Shoots Fives", "CW S6E04",
     "Fives? Fives, we're here.", "When the time comes, no one will be able to stop our plan to execute Order 66.", "4:00", ""),
    ("6.7", "CH6", "Sifo-Dyas / Tyranus Revealed", "CW S6E10",
     "Then it is the lost ship of Master Sifo-Dyas?", "Designed by the Dark Lord of the Sith, this web is. For now, play his game we must.", "5:00", ""),
    ("6.8", "CH6", "Title Card + Closing Card", "Editorial", "", "", "0:15", "EDITORIAL"),

    # ── INTERLUDE ──────────────────────────────────────────────
    ("I.1", "INT", "Yerbana: Anakin Being Playful", "CW S7E09",
     "Well, I can see things are going splendidly on this front.", "Always glad to help, my friend.", "2:00", ""),
    ("I.2", "INT", "Hello, Master! Reunion", "CW S7E09",
     "What's so important you brought us all the way back here?", "We'll have to catch up another time.", "1:00", ""),
    ("I.3", "INT", "Bo-Katan's Plea", "CW S7E09",
     "He murdered their ruler, my sister!", "I told you this was a waste of time.", "0:45", ""),
    ("I.4", "INT", "Separation + Reconciliation", "CW S6E06-07",
     "I don't know who's in there sometimes.", "It's all over now.", "0:50", ""),
    ("I.5", "INT", "Hologram Call", "CW S7E02",
     "You're late again.", "I hope you at least told Padme I said hello.", "2:30", ""),
    ("I.6", "INT", "Lightsaber Handoff + Good Luck", "CW S7E09",
     "So, that went well, all things considered.", "Good luck.", "2:30", "DNC"),

    # ── ROTS ENHANCED ──────────────────────────────────────────
    ("R.1", "ROTS", "DEW IT Flashcut", "TotJ S1E04 + ROTS",
     "I shouldn't.", "Do it.", "0.5s", "ROTS_INSERT"),
    ("R.2", "ROTS", "Nightmare Sequence", "AOTC + CW",
     "Anakin, help me!", "", "25-30s", "ROTS_INSERT"),
    ("R.3", "ROTS", "Tusken Confession to Palpatine", "AOTC",
     "The Jedi are selfless. They only care about others.", "Did you ever hear the tragedy of Darth Plagueis the Wise?", "45s", "ROTS_INSERT"),
    ("R.4", "ROTS", "You Were My Brother Flashcuts", "CW + ROTS",
     "I hate you!", "You were my brother, Anakin.", "2s", "ROTS_INSERT"),
    ("R.5", "ROTS", "Vader Mask VO", "AOTC",
     "Lord Vader.", "Can you hear me?", "3s", "ROTS_INSERT"),
    ("R.6", "ROTS", "Order 66 Rex Whisper", "CW S7E11",
     "Execute order 66.", "It will be done, my lord.", "2s", "ROTS_INSERT"),

    # ── CH7: VICTORY AND DEATH ─────────────────────────────────
    # CH7 clips are loaded from clips_p3_v2.md via parse_ch7_clips()
    # Placeholder entry:
    ("7.0", "CH7", "See clips_p3_v2.md", "TotJ S1E05 + CW S7E09-12", "", "", "120 min", "CH7_REF"),
]


def parse_ch7_clips(p3_path: str) -> list[tuple]:
    """Parse CH7 clips from clips_p3_v2.md."""
    with open(p3_path) as f:
        content = f.read()
    clip_re = re.compile(
        r"### CLIP (\S+) -- (.+)\n"
        r"\*\*Source:\*\* (.+)\n"
        r"\*\*START:\*\* (.+)\n"
        r"\*\*END:\*\* (.+)",
    )
    clips = []
    for m in clip_re.finditer(content):
        cid = m.group(1)
        label = m.group(2).strip()
        source = m.group(3).strip()
        start = m.group(4).strip().strip('"').strip("'")
        end = m.group(5).strip().strip('"').strip("'")
        # Estimate runtime from the markdown (look for "runtime:" nearby)
        runtime_m = re.search(
            rf"### CLIP {re.escape(cid)}.*?runtime:\*\*\s*([^\n]+)",
            content, re.DOTALL,
        )
        rt = runtime_m.group(1).strip() if runtime_m else ""
        clips.append((f"7.{cid}", "CH7", label, source, start, end, rt, ""))
    return clips


def get_all_clips(p3_path: str | None = None) -> list[tuple]:
    """Return all clips. If p3_path given, expand CH7."""
    result = []
    for c in CLIPS:
        if c[0] == "7.0" and p3_path:
            result.extend(parse_ch7_clips(p3_path))
        else:
            result.append(c)
    return result
