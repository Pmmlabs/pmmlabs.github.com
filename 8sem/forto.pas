program PL0(input, output);

(* PL/0 compile with code generation *)
const
  norw = 13; (* no. of reserved words *)
  txmax = 100; (* length of identifier table *)
  nmax = 14; (* max. no of digits in numbers *)
  al = 10; (* length of identifiers *)
  chsetsize = 128; (* for ASCII character set *)
  maxerr = 30; (* max. no. of errors *)
  amax = 2048; (* maximaum address *)
  levmax = 3; (* maximium depth of block nesting *)
  cxmax = 200; (* size of code array *)

type
  symbol = (nul, ident, number, plus, minus, times, slash, oddsym, eql, neq,
    lss, leq, gtr, geq, lparen, rparen, comma, semicolon, period, becomes,
    beginsym, endsym, ifsym, thensym, whilesym, dosym, callsym, constsym,
    varsym, procsym, forsym, tosym);
  alfa = packed array [1 .. al] of char;
  objekt = (constant, variable, prozedure);
  symset = set of symbol;
  fct = (lit, opr, lod, sto, cal, int, jmp, jpc);

  instruction = packed record
    f: fct; (* function code *)
    l: 0 .. levmax; (* level *)
    a: 0 .. amax; (* displacement adress *)
  end;

  (* LIT 0,a         : load constant a
    OPR 0,a         : exec operation a
    LOD l,a         : load variable l,a
    STO l,a         : store         variable l,a
    CAL l,a         : call procedure a at level l
    INT 0,a         : increment t-register by a
    JMP 0,a         : jump to a
    JPC 0,a         : jump conditional to a *)
var
  ch: char; (* last character read *)
  sym: symbol; (* last symbol read *)
  id: alfa; (* last identifier read *)
  num: integer; (* last number read *)
  cc: integer; (* character count *)
  ll: integer; (* line length *)
  kk, err: integer;
  cx: integer; (* code allocation index *)
  line: array [1 .. 81] of char;
  a: alfa;
  code: array [0 .. cxmax] of instruction;
  word: array [1 .. norw] of alfa;
  wsym: array [1 .. norw] of symbol;
  ssym: array [char] of symbol;
  mnemonic: array [fct] of packed array [1 .. 5] of char;
  declbegsys, statbegsys, facbegsys: symset;
  table: array [0 .. txmax] of record name: alfa;
  case kind: objekt of constant: (val: integer);
  variable, prozedure: (level, adr, size: integer);
end;
inf, outf: text;

procedure error(n: integer);
begin
  writeln(' ':cc - 1, '^', n:2);
  writeln(outf, ' ':cc - 1, '^', n:2);
  err := err + 1;
  if err > maxerr then
    halt
end (* error *) ;

procedure listall;
var
  i: integer;
begin (* list all the code generated for the program *)
  writeln('All the PL/0 object code:');
  writeln(outf, 'All the PL/0 object code:');
  for i := 0 to cx - 1 do
    with code[i] do
    begin
      writeln(i, mnemonic[f]:5, l:3, a:5);
      writeln(outf, i, mnemonic[f]:5, l:3, a:5)
    end;
end (* listall *) ;

procedure getsym;
var
  i, j, k: integer;
  procedure getch;
  begin
    if cc = ll then
    begin
      if eof(inf) then
      begin
        write('program incomplete');
        halt
      end;
      ll := 0;
      cc := 0;
      while not eoln(inf) do
      begin
        ll := ll + 1;
        read(inf, ch);
        write(ch);
        write(outf, ch);
        line[ll] := ch;
      end;
      writeln;
      writeln(outf);
      ll := ll + 1;
      readln(inf);
      line[ll] := ' '
    end;
    cc := cc + 1;
    ch := line[cc]
  end (* getch *) ;

(* getsym *)
begin (* getsym *)
  while ch = ' ' do
    getch;
  if ch in ['a' .. 'z'] then
  begin
    (* identifier or reserved word *) k := 0;
    repeat
      if k < al then
      begin
        k := k + 1;
        a[k] := ch
      end;
      getch
    until not(ch in ['a' .. 'z', '0' .. '9']);
    if k >= kk then
      kk := k
    else
      repeat
        a[kk] := ' ';
        kk := kk - 1
      until kk = k;
      id := a;
    i := 1;
    j := norw;
    repeat
      k := (i + j) div 2;
      if id <= word[k] then
        j := k - 1;
      if id >= word[k] then
        i := k + 1;
    until i > j;
    if i - 1 > j then
      sym := wsym[k]
    else
      sym := ident
  end
  else if ch in ['0' .. '9'] then
  begin
    (* number *) k := 0;
    num := 0;
    sym := number;
    repeat
      num := 10 * num + (ord(ch) - ord('0'));
      k := k + 1;
      getch
    until not(ch in ['0' .. '9']);
    if k > nmax then
      error(30)
  end
  else if ch = ':' then
  begin
    getch;
    if ch = '=' then
    begin
      sym := becomes;
      getch
    end
    else
      sym := nul;
  end
  else if ch = '<' then
  begin
    getch;
    if ch = '=' then
    begin
      sym := leq;
      getch
    end
    else
      sym := lss
  end
  else if ch = '>' then
  begin
    getch;
    if ch = '=' then
    begin
      sym := geq;
      getch
    end
    else
      sym := gtr
  end
  else
  begin
    sym := ssym[ch];
    getch
  end
end (* getsym *) ;

procedure gen(x: fct; y, z: integer);
begin
  if cx > cxmax then
  begin
    write(' program too long');
    halt
  end;
  with code[cx] do
  begin
    f := x;
    l := y;
    a := z
  end;
  cx := cx + 1
end (* gen *) ;

procedure test(s1, s2: symset; n: integer);
begin
  if not(sym in s1) then
  begin
    error(n);
    s1 := s1 + s2;
    while not(sym in s1) do
      getsym
  end
end (* test *) ;

procedure block(lev, tx: integer; fsys: symset);
var
  dx: integer; (* data allocation index *)
  tx0: integer; (* initial table index *)
  cx0: integer; (* initial code index *)

  procedure enter(k: objekt);
  begin (* enter object into table *)
    tx := tx + 1;
    with table[tx] do
    begin
      name := id;
      kind := k;
      case k of
        constant:
          begin
            if num > amax then
            begin
              error(31);
              num := 0
            end;
            val := num
          end;
        variable:
          begin
            level := lev;
            adr := dx;
            dx := dx + 1;
          end;
        prozedure:
          level := lev
      end
    end
  end (* enter *) ;

  function position(id: alfa): integer;
  var
    i: integer;
  begin (* find identifier id in table *)
    table[0].name := id;
    i := tx;
    while table[i].name <> id do
      i := i - 1;
    position := i
  end (* position *) ;

  procedure constdeclaration;
  begin
    if sym = ident then
    begin
      getsym;
      if sym in [eql, becomes] then
      begin
        if sym = becomes then
          error(1);
        getsym;
        if sym = number then
        begin
          enter(constant);
          getsym
        end
        else
          error(2)
      end
      else
        error(3)
    end
    else
      error(4)
  end (* constdeclaration *) ;

  procedure vardeclaration;
  begin
    if sym = ident then
    begin
      enter(variable);
      getsym
    end
    else
      error(4)
  end (* vardeclaration *) ;

  procedure listcode;
  var
    i: integer;
  begin (* list code generated for this block *)
    for i := cx0 to cx - 1 do
      with code[i] do
      begin
        writeln(i, mnemonic[f]:5, l:3, a:5);
        writeln(outf, i, mnemonic[f]:5, l:3, a:5)
      end;
  end (* listcode *) ;

  procedure statement(fsys: symset);
  var
    i, cx1, cx2: integer;

    procedure expression(fsys: symset);
    var
      addop: symbol;

      procedure term(fsys: symset);
      var
        mulop: symbol;

        procedure factor(fsys: symset);
        var
          i: integer;
        begin
          test(facbegsys, fsys, 24);
          while sym in facbegsys do
          begin
            if sym = ident then
            begin
              i := position(id);
              if i = 0 then
                error(11)
              else
                with table[i] do
                  case kind of
                    constant:
                      gen(lit, 0, val);
                    variable:
                      gen(lod, lev - level, adr);
                    prozedure:
                      error(21)
                  end;
              getsym
            end
            else if sym = number then
            begin
              if num > amax then
              begin
                error(31);
                num := 0
              end;
              gen(lit, 0, num);
              getsym
            end
            else if sym = lparen then
            begin
              getsym;
              expression([rparen] + fsys);
              if sym = rparen then
                getsym
              else
                error(22)
            end;
            test(fsys, [lparen], 23)
          end
        end (* factor *) ;

      (* term *)
      begin
        (* term *) factor(fsys + [times, slash]);
        while sym in [times, slash] do
        begin
          mulop := sym;
          getsym;
          factor(fsys + [times, slash]);
          if mulop = times then
            gen(opr, 0, 4)
          else
            gen(opr, 0, 5)
        end
      end (* term *) ;

    (* expression *)
    begin (* expression *)
      if sym in [plus, minus] then
      begin
        addop := sym;
        getsym;
        term(fsys + [plus, minus]);
        if addop = minus then
          gen(opr, 0, 1)
      end
      else
        term(fsys + [plus, minus]);
      while sym in [plus, minus] do
      begin
        addop := sym;
        getsym;
        term(fsys + [plus, minus]);
        if addop = plus then
          gen(opr, 0, 2)
        else
          gen(opr, 0, 3)
      end
    end (* expression *) ;

    procedure condition(fsys: symset);
    var
      relop: symbol;
    begin
      if sym = oddsym then
      begin
        getsym;
        expression(fsys);
        gen(opr, 0, 6)
      end
      else
      begin
        expression([eql, neq, lss, gtr, leq, geq] + fsys);
        if not(sym in [eql, neq, lss, leq, gtr, geq]) then
          error(20)
        else
        begin
          relop := sym;
          getsym;
          expression(fsys);
          case relop of
            eql:
              gen(opr, 0, 8);
            neq:
              gen(opr, 0, 9);
            lss:
              gen(opr, 0, 10);
            geq:
              gen(opr, 0, 11);
            gtr:
              gen(opr, 0, 12);
            leq:
              gen(opr, 0, 13);
          end
        end
      end
    end (* condition *) ;

  (* statement *)
  begin (* statement *)
    if not(sym in fsys + [ident]) then
    begin
      error(10);
      repeat
        getsym
      until sym in fsys;
    end;
    if sym = ident then
    begin
      i := position(id);
      if i = 0 then
        error(11)
      else if table[i].kind <> variable then
      begin
        (* assignment to non-variable *) error(12);
        i := 0
      end;
      getsym;
      if sym = becomes then
        getsym
      else
        error(13);
      expression(fsys);
      if i <> 0 then
        with table[i] do
          gen(sto, lev - level, adr)
    end
    else if sym = callsym then
    begin
      getsym;
      if sym <> ident then
        error(14)
      else
      begin
        i := position(id);
        if i = 0 then
          error(11)
        else
          with table[i] do
            if kind = prozedure then
              gen(cal, lev - level, adr)
            else
              error(15);
        getsym
      end
    end
    else if sym = ifsym then
    begin
      getsym;
      condition([thensym, dosym] + fsys);
      if sym = thensym then
        getsym
      else
        error(16);
      cx1 := cx;
      gen(jpc, 0, 0);
      statement(fsys);
      code[cx1].a := cx
    end
    else if sym = beginsym then
    begin
      getsym;
      statement([semicolon, endsym] + fsys);
      while sym in [semicolon] + statbegsys do
      begin
        if sym = semicolon then
          getsym
        else
          error(10);
        statement([semicolon, endsym] + fsys)
      end;
      if sym = endsym then
        getsym
      else
        error(17)
    end
    else if sym = whilesym then
    begin
      cx1 := cx;
      getsym;
      condition([dosym] + fsys);
      cx2 := cx;
      gen(jpc, 0, 0);
      if sym = dosym then
        getsym
      else
        error(18);
      statement(fsys);
      gen(jmp, 0, cx1);
      code[cx2].a := cx
    end
    else if sym = forsym then
    begin
      getsym;
      if sym = ident then
      begin
        i := position(id);
        if i = 0 then
          error(11)
        else if table[i].kind <> variable then
        begin 
          error(12);
          i := 0
        end;
        getsym;
        if sym = becomes then
          getsym
        else
          error(13);
        expression(fsys + [tosym]);
        if i <> 0 then
          with table[i] do
            gen(sto, lev - level, adr);

        cx1 := cx; 
        if sym = tosym then
        begin
          gen(lod, lev - table[i].level, table[i].adr); 
          getsym;
          expression(fsys + [dosym]);
          gen(opr, 0, 13); 
          cx2 := cx; 
          gen(jpc, 0, 0); 
          if sym = dosym then
            getsym
          else
            error(18);
          statement(fsys);
          
         
          gen(lod, lev - table[i].level, table[i].adr); 
          gen(lod, lev - table[i].level, table[i].adr); 
          gen(lit, 0, 1);
          gen(opr, 0, 2); 
          gen(sto, lev - table[i].level, table[i].adr); 
         
          gen(jmp, 0, cx1); 
          code[cx2].a := cx 
        end
        else
          error(41);
      end
      else
        error(41);
    end;
    
    test(fsys, [], 19)
  end (* statement *) ;

(* block *)
begin
  (* block *) dx := 3;
  tx0 := tx;
  table[tx].adr := cx;
  gen(jmp, 0, 0);
  if lev > levmax then
    error(32);
  repeat
    if sym = constsym then
    begin
      getsym;
      repeat
        constdeclaration;
        while sym = comma do
        begin
          getsym;
          constdeclaration
        end;
        if sym = semicolon then
          getsym
        else
          error(5);
      until sym <> ident;
    end;
    if sym = varsym then
    begin
      getsym;
      repeat
        vardeclaration;
        while sym = comma do
        begin
          getsym;
          vardeclaration
        end;
        if sym = semicolon then
          getsym
        else
          error(5);
      until sym <> ident;
    end;
    while sym = procsym do
    begin
      getsym;
      if sym = ident then
      begin
        enter(prozedure);
        getsym
      end
      else
        error(4);
      if sym = semicolon then
        getsym
      else
        error(5);
      block(lev + 1, tx, [semicolon] + fsys);
      if sym = semicolon then
      begin
        getsym;
        test(statbegsys + [ident, procsym], fsys, 6)
      end
      else
        error(5)
    end;
    test(statbegsys + [ident], declbegsys, 7)
  until not(sym in declbegsys);
  code[table[tx0].adr].a := cx;
  with table[tx0] do
  begin
    adr := cx; (* start adr of code *)
    size := dx; (* size of data segment *)
  end;
  cx0 := cx;
  gen(int, 0, dx);
  statement([semicolon, endsym] + fsys);
  gen(opr, 0, 0); (* return *)
  test(fsys, [], 8);
  listcode;
end (* block *) ;

procedure interpret;
const
  stacksize = 500;
var
  p, b, t: integer; (* program-,base-,topstack-registers *)
  i: instruction; (* instruction register *)
  s: array [1 .. stacksize] of integer; (* datastore *)

  function base(l: integer): integer;
  var
    b1: integer;
  begin
    b1 := b; (* find base l levels down *)
    while l > 0 do
    begin
      b1 := s[b1];
      l := l - 1
    end;
    base := b1
  end (* base *) ;

(* interpret *)
begin
  writeln('Start PL/0');
  writeln(outf, 'Start PL/0');
  t := 0;
  b := 1;
  p := 0;
  s[1] := 0;
  s[2] := 0;
  s[3] := 0;
  repeat
    i := code[p];
    p := p + 1;
    with i do
      case f of
        lit:
          begin
            t := t + 1;
            s[t] := a
          end;
        opr:
          case a of (* operator *)
            0:
              begin (* return *)
                t := b - 1;
                p := s[t + 3];
                b := s[t + 2];
              end;
            1:
              s[t] := -s[t];
            2:
              begin
                t := t - 1;
                s[t] := s[t] + s[t + 1]
              end;
            3:
              begin
                t := t - 1;
                s[t] := s[t] - s[t + 1]
              end;
            4:
              begin
                t := t - 1;
                s[t] := s[t] * s[t + 1]
              end;
            5:
              begin
                t := t - 1;
                s[t] := s[t] div s[t + 1]
              end;
            6:
              s[t] := ord(odd(s[t]));
            8:
              begin
                t := t - 1;
                s[t] := ord(s[t] = s[t + 1])
              end;
            9:
              begin
                t := t - 1;
                s[t] := ord(s[t] <> s[t + 1])
              end;
            10:
              begin
                t := t - 1;
                s[t] := ord(s[t] < s[t + 1])
              end;
            11:
              begin
                t := t - 1;
                s[t] := ord(s[t] >= s[t + 1])
              end;
            12:
              begin
                t := t - 1;
                s[t] := ord(s[t] > s[t + 1])
              end;
            13:
              begin
                t := t - 1;
                s[t] := ord(s[t] <= s[t + 1])
              end;
          end;
        lod:
          begin
            t := t + 1;
            s[t] := s[base(l) + a]
          end;
        sto:
          begin
            s[base(l) + a] := s[t];
            writeln(s[t]);
            writeln(outf, s[t]);
            t := t - 1
          end;
        cal:
          begin (* generate new block mark *)
            s[t + 1] := base(l);
            s[t + 2] := b;
            s[t + 3] := p;
            b := t + 1;
            p := a;
          end;
        int:
          t := t + a;
        jmp:
          p := a;
        jpc:
          begin
            if s[t] = 0 then
              p := a;
            t := t - 1;
          end
      end (* with,case *) ;
  until p = 0;
  write('End PL/0');
  write(outf, 'End PL/0');
end (* interpret *) ;

(* main program *)
begin (* main program *)

  assign(inf, 'testin.pl0');
  assign(outf, 'testout.txt');
  reset(inf);
  rewrite(outf);
  for ch := chr(0) to chr(chsetsize - 1) do
    ssym[ch] := nul;
  word[1] := 'begin     ';
  word[2] := 'call      ';
  word[3] := 'const     ';
  word[4] := 'do        ';
  word[5] := 'end       ';
  word[6] := 'for       ';
  word[7] := 'if        ';
  word[8] := 'odd       ';
  word[9] := 'procedure ';
  word[10] := 'then      ';
  word[11] := 'to        ';
  word[12] := 'var       ';
  word[13] := 'while     ';
  wsym[1] := beginsym;
  wsym[2] := callsym;
  wsym[3] := constsym;
  wsym[4] := dosym;
  wsym[5] := endsym;
  wsym[6] := forsym;
  wsym[7] := ifsym;
  wsym[8] := oddsym;
  wsym[9] := procsym;
  wsym[10] := thensym;
  wsym[11] := tosym;
  wsym[12] := varsym;
  wsym[13] := whilesym;
  ssym['+'] := plus;
  ssym['-'] := minus;
  ssym['*'] := times;
  ssym['/'] := slash;
  ssym['('] := lparen;
  ssym[')'] := rparen;
  ssym['='] := eql;
  ssym[','] := comma;
  ssym['.'] := period;
  ssym['#'] := neq;
  ssym['<'] := lss;
  ssym['>'] := gtr;
  ssym[';'] := semicolon;
  mnemonic[lit] := ' LIT ';
  mnemonic[opr] := ' OPR ';
  mnemonic[lod] := ' LOD ';
  mnemonic[sto] := ' STO ';
  mnemonic[cal] := ' CAL ';
  mnemonic[int] := ' INT ';
  mnemonic[jmp] := ' JMP ';
  mnemonic[jpc] := ' JPC ';
  declbegsys := [constsym, varsym, procsym];
  statbegsys := [beginsym, callsym, ifsym, whilesym, forsym];
  facbegsys := [ident, number, lparen];
  err := 0;
  cc := 0;
  cx := 0;
  ll := 0;
  ch := ' ';
  kk := al;
  getsym;
  block(0, 0, [period] + declbegsys + statbegsys);
  if sym <> period then
    error(9);
  if err = 0 then
  begin
    listall;
    interpret;
  end
  else
    write('Errors in PL/0 program');
  writeln;
  writeln(outf);
  close(outf);
end.
