return {
    
    item = 'fibres', -- item name for what you collect
    
    picking = {
        amountPicked = 1, -- amount you get every time
        animation = 'e mechanic4',

        useSkillcheck = true,
        skillCheck = {'easy', 'easy', 'easy'},
        skillCheckKeys = { 'e', 'e', 'e' },

        progressDuration = 3000, -- only used if useSkillcheck is false 
    },

    target = {
        label = 'Pick Fibres',
        icon = 'fa-solid fa-hand',
        iconColor = '#76A9D2',
        distance = 2.5,
    },

    blip = {
        enabled = true,
        label = 'Fibre Field',
        coords = vector3(2637.9, 4591.71, 36.7),
        sprite = 846,
        spriteColor = 16,
        scale = 0.8,
    },

}