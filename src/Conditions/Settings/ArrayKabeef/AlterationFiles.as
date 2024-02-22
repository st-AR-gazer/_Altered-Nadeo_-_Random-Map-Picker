array<string> GetAlterationFiles() {
    array<string> filesToInclude;
    
    // Environments
        if (IsUsing_Snow_) {
            filesToInclude.InsertLast(alterationFilePath + "_Snow_.json");
        }
        if (IsUsing_Snow_Carswitch) {
            filesToInclude.InsertLast(alterationFilePath + "_Snow__Carswitch.json");
        }
        if (IsUsing_Snow_Checkpointless) {
            filesToInclude.InsertLast(alterationFilePath + "_Snow__Checkpointless.json");
        }
        if (IsUsing_Snow_Icy) {
            filesToInclude.InsertLast(alterationFilePath + "_Snow__Icy.json");
        }
        if (IsUsing_Snow_Underwater) {
            filesToInclude.InsertLast(alterationFilePath + "_Snow__Underwater.json");
        }
        if (IsUsing_Snow_Wood) {
            filesToInclude.InsertLast(alterationFilePath + "_Snow__Wood.json");
        }
        if (IsUsing_Stadium_) {
            filesToInclude.InsertLast(alterationFilePath + "_Stadium_.json");
        }

    // Other

        if (IsUsing_1Back) {
            filesToInclude.InsertLast(alterationFilePath + "1_Back.json");
        }
        if (IsUsing_1Down) {
            filesToInclude.InsertLast(alterationFilePath + "1_Down.json");
        }
        if (IsUsing_1Left) {
            filesToInclude.InsertLast(alterationFilePath + "1_Left.json");
        }
        if (IsUsing_1Right) {
            filesToInclude.InsertLast(alterationFilePath + "1_Right.json");
        }
        if (IsUsing_1Up) {
            filesToInclude.InsertLast(alterationFilePath + "1_Up.json");
        }
        if (IsUsing_2D) {
            filesToInclude.InsertLast(alterationFilePath + "2D.json");
        }
        if (IsUsing_2Up) {
            filesToInclude.InsertLast(alterationFilePath + "2_Up.json");
        }
        if (IsUsing_A08) {
            filesToInclude.InsertLast(alterationFilePath + "A08.json");
        }
        if (IsUsing_Antibooster) {
            filesToInclude.InsertLast(alterationFilePath + "Antibooster.json");
        }
        if (IsUsing_BOSS) {
            filesToInclude.InsertLast(alterationFilePath + "BOSS.json");
        }
        if (IsUsing_Backwards) {
            filesToInclude.InsertLast(alterationFilePath + "Backwards.json");
        }

        if (IsUsing_Better_Mixed) {
            filesToInclude.InsertLast(alterationFilePath + "Better_Mixed.json");
        }
        if (IsUsing_Better_Reverse) {
            filesToInclude.InsertLast(alterationFilePath + "Better_Reverse.json");
        }
        if (IsUsing_Blind) {
            filesToInclude.InsertLast(alterationFilePath + "Blind.json");
        }
        if (IsUsing_Bobsleigh) {
            filesToInclude.InsertLast(alterationFilePath + "Bobsleigh.json");
        }
        if (IsUsing_Boomerang_There_and_Back) {
            filesToInclude.InsertLast(alterationFilePath + "Boomerang_There_and_Back.json");
        }
        if (IsUsing_Boosterless) {
            filesToInclude.InsertLast(alterationFilePath + "Boosterless.json");
        }
        if (IsUsing_Broken) {
            filesToInclude.InsertLast(alterationFilePath + "Broken.json");
        }
        if (IsUsing_Bumper) {
            filesToInclude.InsertLast(alterationFilePath + "Bumper.json");
        }
        if (IsUsing_CP1_Kept) {
            filesToInclude.InsertLast(alterationFilePath + "CP1_Kept.json");
        }
        if (IsUsing_CP1_is_End) {
            filesToInclude.InsertLast(alterationFilePath + "CP1_is_End.json");
        }
        if (IsUsing_CPLink) {
            filesToInclude.InsertLast(alterationFilePath + "CPLink.json");
        }
        if (IsUsing_CP_Boost) {
            filesToInclude.InsertLast(alterationFilePath + "CP_Boost.json");
        }
        if (IsUsing_CPfull) {
            filesToInclude.InsertLast(alterationFilePath + "CPfull.json");
        }
        if (IsUsing_Checkpoin_t) {
            filesToInclude.InsertLast(alterationFilePath + "Checkpoin_t.json");
        }
        if (IsUsing_Checkpointless) {
            filesToInclude.InsertLast(alterationFilePath + "Checkpointless.json");
        }
        if (IsUsing_Checkpointless_Reverse) {
            filesToInclude.InsertLast(alterationFilePath + "Checkpointless_Reverse.json");
        }
        if (IsUsing_Cleaned) {
            filesToInclude.InsertLast(alterationFilePath + "Cleaned.json");
        }
        if (IsUsing_Colors_Combined) {
            filesToInclude.InsertLast(alterationFilePath + "Colors_Combined.json");
        }
        if (IsUsing_Cruise) {
            filesToInclude.InsertLast(alterationFilePath + "Cruise.json");
        }
        if (IsUsing_Dirt) {
            filesToInclude.InsertLast(alterationFilePath + "Dirt.json");
        }
        if (IsUsing_Earthquake) {
            filesToInclude.InsertLast(alterationFilePath + "Earthquake.json");
        }
        if (IsUsing_Effectless) {
            filesToInclude.InsertLast(alterationFilePath + "Effectless.json");
        }
        if (IsUsing_Egocentrism) {
            filesToInclude.InsertLast(alterationFilePath + "Egocentrism.json");
        }
        if (IsUsing_Fast) {
            filesToInclude.InsertLast(alterationFilePath + "Fast.json");
        }
        if (IsUsing_Fast_Magnet) {
            filesToInclude.InsertLast(alterationFilePath + "Fast_Magnet.json");
        }
        if (IsUsing_Flipped) {
            filesToInclude.InsertLast(alterationFilePath + "Flipped.json");
        }
        if (IsUsing_Flooded) {
            filesToInclude.InsertLast(alterationFilePath + "Flooded.json");
        }
        if (IsUsing_Floor_Fin) {
            filesToInclude.InsertLast(alterationFilePath + "Floor_Fin.json");
        }
        if (IsUsing_Fragile) {
            filesToInclude.InsertLast(alterationFilePath + "Fragile.json");
        }
        if (IsUsing_Freewheel) {
            filesToInclude.InsertLast(alterationFilePath + "Freewheel.json");
        }
        if (IsUsing_Glider) {
            filesToInclude.InsertLast(alterationFilePath + "Glider.json");
        }
        if (IsUsing_Got_Rotated_CPs_Rotated_90__) {
            filesToInclude.InsertLast(alterationFilePath + "Got_Rotated_CPs_Rotated_90__.json");
        }
        if (IsUsing_Grass) {
            filesToInclude.InsertLast(alterationFilePath + "Grass.json");
        }
        if (IsUsing_Hard) {
            filesToInclude.InsertLast(alterationFilePath + "Hard.json");
        }
        if (IsUsing_Holes) {
            filesToInclude.InsertLast(alterationFilePath + "Holes.json");
        }
        if (IsUsing_Ice) {
            filesToInclude.InsertLast(alterationFilePath + "Ice.json");
        }
        if (IsUsing_Ice_Reverse) {
            filesToInclude.InsertLast(alterationFilePath + "Ice_Reverse.json");
        }
        if (IsUsing_Ice_Reverse_Reactor) {
            filesToInclude.InsertLast(alterationFilePath + "Ice_Reverse_Reactor.json");
        }
        if (IsUsing_Ice_Short) {
            filesToInclude.InsertLast(alterationFilePath + "Ice_Short.json");
        }
        if (IsUsing_Icy_Reactor) {
            filesToInclude.InsertLast(alterationFilePath + "Icy_Reactor.json");
        }
        if (IsUsing_Inclined) {
            filesToInclude.InsertLast(alterationFilePath + "Inclined.json");
        }
        if (IsUsing_Lunatic) {
            filesToInclude.InsertLast(alterationFilePath + "Lunatic.json");
        }
        if (IsUsing_Magnet) {
            filesToInclude.InsertLast(alterationFilePath + "Magnet.json");
        }
        if (IsUsing_Magnet_Reverse) {
            filesToInclude.InsertLast(alterationFilePath + "Magnet_Reverse.json");
        }
        if (IsUsing_Manslaughter) {
            filesToInclude.InsertLast(alterationFilePath + "Manslaughter.json");
        }
        if (IsUsing_Mini_RPG) {
            filesToInclude.InsertLast(alterationFilePath + "Mini_RPG.json");
        }
        if (IsUsing_Mirrored) {
            filesToInclude.InsertLast(alterationFilePath + "Mirrored.json");
        }
        if (IsUsing_Mixed) {
            filesToInclude.InsertLast(alterationFilePath + "Mixed.json");
        }
        if (IsUsing_Ngolo_Cacti) {
            filesToInclude.InsertLast(alterationFilePath + "Ngolo_Cacti.json");
        }
        if (IsUsing_No_Steer) {
            filesToInclude.InsertLast(alterationFilePath + "No-Steer.json");
        }
        if (IsUsing_No_brakes) {
            filesToInclude.InsertLast(alterationFilePath + "No-brakes.json");
        }
        if (IsUsing_No_cut) {
            filesToInclude.InsertLast(alterationFilePath + "No-cut.json");
        }
        if (IsUsing_No_grip) {
            filesToInclude.InsertLast(alterationFilePath + "No-grip.json");
        }
        if (IsUsing_No_gear_5) {
            filesToInclude.InsertLast(alterationFilePath + "No_gear_5.json");
        }
        if (IsUsing_Penalty) {
            filesToInclude.InsertLast(alterationFilePath + "Penalty.json");
        }
        if (IsUsing_Pipe) {
            filesToInclude.InsertLast(alterationFilePath + "Pipe.json");
        }
        if (IsUsing_Plastic) {
            filesToInclude.InsertLast(alterationFilePath + "Plastic.json");
        }
        if (IsUsing_Plastic_Reverse) {
            filesToInclude.InsertLast(alterationFilePath + "Plastic_Reverse.json");
        }
        if (IsUsing_Platform) {
            filesToInclude.InsertLast(alterationFilePath + "Platform.json");
        }
        if (IsUsing_Podium) {
            filesToInclude.InsertLast(alterationFilePath + "Podium.json");
        }
        if (IsUsing_Pool_Hunters) {
            filesToInclude.InsertLast(alterationFilePath + "Pool_Hunters.json");
        }
        if (IsUsing_Puzzle) {
            filesToInclude.InsertLast(alterationFilePath + "Puzzle.json");
        }
        if (IsUsing_Random) {
            filesToInclude.InsertLast(alterationFilePath + "Random.json");
        }
        if (IsUsing_Random_Dankness) {
            filesToInclude.InsertLast(alterationFilePath + "Random_Dankness.json");
        }
        if (IsUsing_Random_Effects) {
            filesToInclude.InsertLast(alterationFilePath + "Random_Effects.json");
        }
        if (IsUsing_Reactor) {
            filesToInclude.InsertLast(alterationFilePath + "Reactor.json");
        }
        if (IsUsing_Reactor_Down) {
            filesToInclude.InsertLast(alterationFilePath + "Reactor_Down.json");
        }
        if (IsUsing_Reverse) {
            filesToInclude.InsertLast(alterationFilePath + "Reverse.json");
        }
        if (IsUsing_Ring_CP) {
            filesToInclude.InsertLast(alterationFilePath + "Ring_CP.json");
        }
        if (IsUsing_Road) {
            filesToInclude.InsertLast(alterationFilePath + "Road.json");
        }
        if (IsUsing_Road_Dirt) {
            filesToInclude.InsertLast(alterationFilePath + "Road_Dirt.json");
        }
        if (IsUsing_Roofing) {
            filesToInclude.InsertLast(alterationFilePath + "Roofing.json");
        }
        if (IsUsing_Sausage) {
            filesToInclude.InsertLast(alterationFilePath + "Sausage.json");
        }
        if (IsUsing_Scuba_Diving) {
            filesToInclude.InsertLast(alterationFilePath + "Scuba_Diving.json");
        }
        if (IsUsing_Sections_joined) {
            filesToInclude.InsertLast(alterationFilePath + "Sections-joined.json");
        }
        if (IsUsing_Select_DEL) {
            filesToInclude.InsertLast(alterationFilePath + "Select_DEL.json");
        }
        if (IsUsing_Short) {
            filesToInclude.InsertLast(alterationFilePath + "Short.json");
        }
        if (IsUsing_Sky_is_the_Finish) {
            filesToInclude.InsertLast(alterationFilePath + "Sky_is_the_Finish.json");
        }
        if (IsUsing_Sky_is_the_Finish_Reverse) {
            filesToInclude.InsertLast(alterationFilePath + "Sky_is_the_Finish_Reverse.json");
        }
        if (IsUsing_Slowmo) {
            filesToInclude.InsertLast(alterationFilePath + "Slowmo.json");
        }
        if (IsUsing_Speedlimit) {
            filesToInclude.InsertLast(alterationFilePath + "Speedlimit.json");
        }
        if (IsUsing_Staircase) {
            filesToInclude.InsertLast(alterationFilePath + "Staircase.json");
        }
        if (IsUsing_Start_1_Down) {
            filesToInclude.InsertLast(alterationFilePath + "Start_1-Down.json");
        }
        if (IsUsing_Straight_to_the_Finish) {
            filesToInclude.InsertLast(alterationFilePath + "Straight_to_the_Finish.json");
        }
        if (IsUsing_Supersized) {
            filesToInclude.InsertLast(alterationFilePath + "Supersized.json");
        }
        if (IsUsing_Surfaceless) {
            filesToInclude.InsertLast(alterationFilePath + "Surfaceless.json");
        }
        if (IsUsing_Symmetrical) {
            filesToInclude.InsertLast(alterationFilePath + "Symmetrical.json");
        }
        if (IsUsing_TMGL_Easy) {
            filesToInclude.InsertLast(alterationFilePath + "TMGL_Easy.json");
        }
        if (IsUsing_Tilted) {
            filesToInclude.InsertLast(alterationFilePath + "Tilted.json");
        }
        if (IsUsing_Underwater) {
            filesToInclude.InsertLast(alterationFilePath + "Underwater.json");
        }
        if (IsUsing_Underwater_Reverse) {
            filesToInclude.InsertLast(alterationFilePath + "Underwater_Revers.json");
        }
        if (IsUsing_Walmart_Mini) {
            filesToInclude.InsertLast(alterationFilePath + "Walmart_Mini.json");
        }
        if (IsUsing_Wet_Icy_Wood) {
            filesToInclude.InsertLast(alterationFilePath + "Wet_Icy_Wood.json");
        }
        if (IsUsing_Wet_Wheels) {
            filesToInclude.InsertLast(alterationFilePath + "Wet_Wheels.json");
        }
        if (IsUsing_Wet_Wood) {
            filesToInclude.InsertLast(alterationFilePath + "Wet_Wood.json");
        }
        if (IsUsing_Wood) {
            filesToInclude.InsertLast(alterationFilePath + "Wood.json");
        }
        if (IsUsing_Worn_Tires) {
            filesToInclude.InsertLast(alterationFilePath + "Worn_Tires.json");
        }
        if (IsUsing_XX_But) {
            filesToInclude.InsertLast(alterationFilePath + "XX-But.json");
        }
        if (IsUsing_YEET) {
            filesToInclude.InsertLast(alterationFilePath + "YEET.json");
        }
        if (IsUsing_YEET_Down) {
            filesToInclude.InsertLast(alterationFilePath + "YEET_Down.json");
        }
        if (IsUsing_YEET_Puzzle) {
            filesToInclude.InsertLast(alterationFilePath + "YEET_Puzzle.json");
        }
        if (IsUsing_YEET_Random_Puzzle) {
            filesToInclude.InsertLast(alterationFilePath + "YEET_Random_Puzzle.json");
        }
        if (IsUsing_YEET_Reverse) {
            filesToInclude.InsertLast(alterationFilePath + "YEET_Reverse.json");
        }
        if (IsUsing_YEP_Tree_Puzzle) {
            filesToInclude.InsertLast(alterationFilePath + "YEP_Tree_Puzzle.json");
        }
        if (IsUsing_Yeet_Max_Up) {
            filesToInclude.InsertLast(alterationFilePath + "Yeet_Max-Up.json");
        }

    return filesToInclude;
}
