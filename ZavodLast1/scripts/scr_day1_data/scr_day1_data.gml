// Обычная реплика.
// _next — номер следующей реплики.
// _action — дополнительное действие: согласиться или отказаться.
function scr_d1_line(_speaker, _text, _next, _action)
{
    return {
        type: "line",
        speaker: _speaker,
        text: _text,
        next_index: _next,
        action: _action
    };
}


// Выбор из нескольких ответов.
// _targets хранит номера реплик для каждого ответа.
function scr_d1_choice(_options, _targets)
{
    return {
        type: "choice",
        options: _options,
        targets: _targets
    };
}


// Конец разговора.
// complete — обычное завершение.
// soup — концовка со старушкой.
function scr_d1_end(_outcome)
{
    return {
        type: "end",
        outcome: _outcome
    };
}


// _kind = 0 — дворник.
// _kind = 1 — старушка.
function scr_day1_data(_kind)
{
    if (_kind == 0)
    {
        return [
            // 0
            scr_d1_line(
                "Janitor",
                "You look tired. I look tired. Even the floor looks tired.",
                1, ""
            ),

            // 1
            scr_d1_line(
                "Janitor",
                "Cover my shift. You will smell like bleach for a week.",
                2, ""
            ),

            // 2
            scr_d1_choice(
                ["Fine...", "No..."],
                [3, 6]
            ),

            // 3 — согласие на работу
            scr_d1_line(
                "Worker",
                "Fine. I will mop your floor.",
                4, "accept"
            ),

            // 4
            scr_d1_line(
                "Janitor",
                "Good. Mop is in the closet.",
                5, ""
            ),

            // 5
            scr_d1_line(
                "Janitor",
                "Do not ask about the drain.",
                9, ""
            ),

            // 6 — отказ от работы
            scr_d1_line(
                "Worker",
                "No. Find someone else.",
                7, "decline"
            ),

            // 7
            scr_d1_line(
                "Janitor",
                "Suit yourself.",
                8, ""
            ),

            // 8
            scr_d1_line(
                "Janitor",
                "The floor stays dirty. So do you.",
                9, ""
            ),

            // 9 — продолжение после любой первой ветки
            scr_d1_line(
                "Janitor",
                "If anyone asks, you were never here.",
                10, ""
            ),

            // 10
            scr_d1_line(
                "Janitor",
                "I was never here either.",
                11, ""
            ),

            // 11
            scr_d1_choice(
                ["Understood...", "Suspicious..."],
                [12, 15]
            ),

            // 12
            scr_d1_line(
                "Worker",
                "Understood.",
                13, ""
            ),

            // 13
            scr_d1_line(
                "Janitor",
                "Good. The floor stays dirty.",
                14, ""
            ),

            // 14
            scr_d1_line(
                "Janitor",
                "So do we.",
                18, ""
            ),

            // 15
            scr_d1_line(
                "Worker",
                "This is suspicious.",
                16, ""
            ),

            // 16
            scr_d1_line(
                "Janitor",
                "Everything is suspicious.",
                17, ""
            ),

            // 17
            scr_d1_line(
                "Janitor",
                "The floor is suspicious too.",
                18, ""
            ),

            // 18
            scr_d1_end("complete")
        ];
    }


    // Старушка.
    return [
        // 0
        scr_d1_line(
            "Old Woman",
            "Young man. Young man.",
            1, ""
        ),

        // 1
        scr_d1_line(
            "Old Woman",
            "I have bags. I have many bags.",
            2, ""
        ),// 2
        scr_d1_line(
            "Old Woman",
            "Carry them home. Do not look inside them.",
            3, ""
        ),

        // 3
        scr_d1_choice(
            ["Okay...", "No..."],
            [4, 7]
        ),

        // 4 — согласие помочь
        scr_d1_line(
            "Worker",
            "Okay. Give me the bags.",
            5, "accept"
        ),

        // 5
        scr_d1_line(
            "Old Woman",
            "Good boy. Walk slow.",
            6, ""
        ),

        // 6
        scr_d1_line(
            "Old Woman",
            "My knees are older than your whole family.",
            10, ""
        ),

        // 7 — отказ
        scr_d1_line(
            "Worker",
            "No. Carry them yourself.",
            8, "decline"
        ),

        // 8
        scr_d1_line(
            "Old Woman",
            "Fine. I will carry them myself.",
            9, ""
        ),

        // 9
        scr_d1_line(
            "Old Woman",
            "I will die on the stairs. It is fine.",
            10, ""
        ),

        // 10 — продолжение после любой первой ветки
        scr_d1_line(
            "Old Woman",
            "And do not drop them. Or I will drop you.",
            11, ""
        ),

        // 11
        scr_d1_line(
            "Old Woman",
            "Figuratively. Probably.",
            12, ""
        ),

        // 12
        scr_d1_choice(
            ["Scary...", "Joking..."],
            [13, 16]
        ),

        // 13
        scr_d1_line(
            "Worker",
            "You are scary for an old woman.",
            14, ""
        ),

        // 14
        scr_d1_line(
            "Old Woman",
            "I have had practice.",
            15, ""
        ),

        // 15
        scr_d1_line(
            "Old Woman",
            "Come closer. Say it to my face.",
            19, ""
        ),

        // 16
        scr_d1_line(
            "Worker",
            "You are joking, right?",
            17, ""
        ),

        // 17
        scr_d1_line(
            "Old Woman",
            "Am I?",
            18, ""
        ),

        // 18
        scr_d1_line(
            "Old Woman",
            "Carry the bags and find out.",
            20, ""
        ),

        // 19 — плохая концовка
        scr_d1_end("soup"),

        // 20 — обычное завершение
        scr_d1_end("complete")
    ];
}