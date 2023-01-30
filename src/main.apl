codfns_path←2⎕NQ# 'GetEnvironment' 'codfns-path'
⎕←'Co-dfns usercommand path: ',codfns_path
(⎕NS⍬).(_←enableSALT⊣⎕CY'salt')
⎕SE.SALT.Settings 'cmddir ,',codfns_path
ns←⎕NS⍬
ns.add←{1+⍵}
⎕←ns.add 2
]CODFNS.Compile ns cdns
⎕←'hello world'
⎕←cdns.add 2
