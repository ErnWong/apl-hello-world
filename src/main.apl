⍝'w_new'⎕NA'P cdns.so|w_new<C[]'
⍝w_new ⊂ 'hello world'

codfns_path←2⎕NQ# 'GetEnvironment' 'codfns-path'
⎕←'Co-dfns usercommand path: ',codfns_path
(⎕NS⍬).(_←enableSALT⊣⎕CY'salt')
⎕SE.SALT.Settings 'cmddir ,',codfns_path
ns←⎕NS⍬
ns.add←{1+⍵}
ns.art←{↑(0 0 0 1) (0 0 1 1) (0 1 0 0) (1 1 ⍵ 1)}
⎕←ns.add 2
⎕←ns.art 3.14
⎕←ns.add ↑ (1 2 3) (4 5 6) (7 8 9)
]CODFNS.Compile ns cdns
⎕←'hello world'
⎕←cdns.add 2
⎕←cdns.art 3.14
⎕←cdns.add ↑ (1 2 3) (4 5 6) (7 8 9)

]⎕←map

cdns.∆.Rtm∆Init 'cdns'

⍝ TODO: Image is unexpectedly 1-dimensional and not coloured. Why?
⍝ X←(? 100 100 ⍴ 2) - 1 ⍝ offset might not be needed if index from zero?
⍝ X←(? 100 100 3 ⍴ 255) - 1 ⍝ offset might not be needed if index from zero?
⍝X←(? 3 10 10 ⍴ 255)
⍝X←↑(0 0 0 1) (0 0 1 1) (0 1 0 0) (1 1 0 1)
⍝'Window title' {_←⍺ cdns.∆.Image ⍵ ⋄ ⍵} cdns.∆.Display {0} X
'Window title' {_←⍺ cdns.∆.Image cdns.art ⍵ ⋄ ~⍵} cdns.∆.Display {0} 1
⍝'Window title' {_←⍺ cdns.∆.Image ⍵ ⋄ ((? 10 10 ⍴ 2) - 1)} cdns.∆.Display {0} X
