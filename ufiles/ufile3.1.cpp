//---------------------------------------------------------------------------

#pragma hdrstop

//---------------------------------------------------------------------------

#pragma argsused
#include <iostream>
#include <string>
using namespace std;
int get_arab_num(string rom_str)
{
    int res = 0;
    for(size_t i = 0; i < rom_str.length(); ++i)
    {
        switch(rom_str[i])
        {
        case 'M':
            res += 1000;
            break;
        case 'D':
            res += 500;
            break;
        case 'C':
            i + 1 < rom_str.length()
                    &&  (rom_str[i + 1] == 'D'
                         || rom_str[i + 1] == 'M') ? res -= 100 : res += 100;
            break;
        case 'L':
            res += 50;
            break;
        case 'X':
            i + 1 < rom_str.length()
                    &&  (rom_str[i + 1] == 'L'
                         || rom_str[i + 1] == 'C') ? res -= 10 : res += 10;
            break;
        case 'V':
            res += 5;
            break;
        case 'I':
            i + 1 < rom_str.length()
                    &&  (rom_str[i + 1] == 'V'
                         || rom_str[i + 1] == 'X') ? res -= 1 : res += 1;
            break;

        }
    }
    return res;
}

int _tmain()
{
    string s;
    for(;;)
    {
        cout<<"input roman num: ";
        cin >> s;

         cout<<"arab num = " ;
          cout<<get_arab_num(s)<<"\n" ;

    }  ;
        return 0;
};