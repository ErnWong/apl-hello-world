(⎕NS⍬).(_←enableSALT⊣⎕CY'salt')
⍝⎕SE.SALT.Settings 'cmddir ,./Co-dfns-4.1.2'
]Settings cmddir ,./user-commands
⍝]⎕←?codfns
ns←⎕NS⍬
ns.add←{1+⍵}
⎕←ns.add 2
]CODFNS.Compile ns cdns
⎕←'hello world'
⎕←cdns.add 2
