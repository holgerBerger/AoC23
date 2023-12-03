import std.stdio;
import std.conv : to;
import std.algorithm;
import std.algorithm.comparison : max;

struct Game {
    int n,r,g,b;
};

const Game maxvals = {0, 12, 13, 14};       // the max numbers for each color

enum Tokens : char {
    GAME,
    COLON,
    RED,
    GREEN,
    BLUE,
    SEMICOLON,
    COMMA,
    EOL,
    NUMBER
}

struct Token {
    Tokens type;
    int number;
};


// return tokens frome line
class Tokenizer {
    this(string line) {
        pos=0; text=line;
    }

    Token nexttoken() {
        string token;
        char del;
        while(text[pos]==' ') pos++; // consume spaces at start of tokens
        while(text[pos]!=' ' && text[pos]!=';' && text[pos]!=':' && text[pos]!=',' && text[pos]!='\n') {
            token~=text[pos];
            pos++;
        }
        del=text[pos];
        //stderr.writefln("  nexttoken: token=<%s> del=<%c>\n", token, del);
        if(token!="") {
            if(del==' ') pos++;
            switch(token) {
                case "Game": return Token(Tokens.GAME);
                case "red": return Token(Tokens.RED);
                case "green": return Token(Tokens.GREEN);
                case "blue": return Token(Tokens.BLUE);
                default:
                    // we ignore ConvException here, if number is not a numbe rit will throw and programm will die
                    return Token(Tokens.NUMBER, to!int(token));
            }
        } else {
            pos++;
            switch(del) {
                case ':': return Token(Tokens.COLON);
                case ';': return Token(Tokens.SEMICOLON);
                case ',': return Token(Tokens.COMMA);
                case '\n': return Token(Tokens.EOL);
                default: assert(0);
            }   
        }
        assert(0);  
    }

private:
    long pos;
    string text;
}

// parse a single line
Game parseline(string line) {
    Game game;
    //stdout.writeln("parse ", line);
    auto tokens = new Tokenizer(line~'\n');
    
    if(auto token = tokens.nexttoken.type == Tokens.GAME) {
        auto nr = tokens.nexttoken;
        if (nr.type == Tokens.NUMBER) {
            game.n = nr.number;
            if (auto cl = tokens.nexttoken.type == Tokens.COLON) {
                Token et;
                do {
                    nr = tokens.nexttoken;
                    if (nr.type == Tokens.NUMBER) {
                        auto lastnumber = nr.number;
                        auto color = tokens.nexttoken;
                        switch (color.type) {
                            case Tokens.RED:   game.r = max(game.r, lastnumber); break;
                            case Tokens.GREEN: game.g = max(game.g, lastnumber); break;
                            case Tokens.BLUE:  game.b = max(game.b, lastnumber); break;
                            default: stderr.writeln("expected a color!\n");
                        } 
                    } else stderr.writeln("expected a number!\n");
                    et = tokens.nexttoken;
                } while(et.type==Tokens.COMMA || et.type==Tokens.SEMICOLON);
                //stdout.writeln(game);
                return game;
            } else stderr.writeln("expected ':'!\n");
        } else stderr.writeln("expected Number!\n");
    } else stderr.writeln("expected Game!\n");
    assert(0);
}

int validgame(Game g) {
    stderr.writeln(g.n);
    if (g.r <= maxvals.r && g.g <= maxvals.g && g.b <= maxvals.b) return g.n;
    else return 0;
}

void main() {
    stdout.writeln(stdin.byLine.map!(a=>cast(string)a).map!parseline().map!validgame.sum);
}
