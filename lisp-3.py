import sys
import math
import operator as op
import re


class Env(dict):
    def __init__(self, params=(), args=(), outer=None):
        self.update(dict(zip(params, args)))
        self.outer = outer

        # TODO: If outer is not None, then print the outer environment and then this one.
        #       It outer is None, then print GLOBAL
        #       Look at factorial.expected

        if self.outer != None:
          Env.printme(self)
          print("------------------")


    def printme(self):
        if self.outer == None: print("GLOBAL")
        else:
            Env.printme(self.outer)
        print("------------------")
        for key in self:
            if (type(self[key]) is Procedure):
              print(key, "\t:", type(self[key]).__name__)

            elif (type(self[key]) is int):
              print(key, "\t\t:", self[key])



    def find(self, var):
        return self if (var in self) else self.outer.find(var)

global_env = Env()
global_env.update({k:v for k, v in vars(math).items() if not k.startswith('_')})
global_env['+'] = op.add
global_env['-'] = op.sub
global_env['/'] = op.truediv
global_env['*'] = op.mul
global_env['<'] = op.lt
global_env['>'] = op.gt
global_env['>='] = op.ge
global_env['<='] = op.le
global_env['='] = op.eq
global_env['display'] = print


def tokenize(source):
    # Will not work for comments in strings, but that is ok
    source = re.sub(r';.*$', ' ', source, flags=re.MULTILINE)
    return source.replace('(', ' ( ').replace(')', ' ) ').split()

def parse_expr(tokens):
    if len(tokens) == 0:
        raise SyntaxError("EOF")

    token = tokens.pop(0)
    if token == '(':
        thelist = []
        while tokens[0] != ')':
            subexpr = parse_expr(tokens)
            thelist.append(subexpr)
        tokens.pop(0)
        return thelist
    else:
        try:
            return int(token)
        except ValueError:
            try:
                return float(token)
            except ValueError:
                return token

class Procedure(object):
    def __init__(self, parms, body, env):
        self.parms= parms
        self.body= body
        self.env = env

    def __call__(self, *args):
        local_env = Env(self.parms, args, self.env)
        return eval_expr(self.body, local_env)

    def name(self):
        return object.__name__

def eval_expr(exp, env=global_env):
    if isinstance(exp, str):
        env = env.find(exp)
        return env[exp]
    elif not isinstance(exp, list):
        return exp

    op, *args = exp

    # Special symbols  (quote, if, define, lambda)
    if op == 'quote':  # (quote (1 2 3)) ==>  (1 2 3)
        return args[0]
    elif op == 'if':  # conditional  (if test conseq alt) => only eval the correct branch
        test, conseq, alt = args
        exp = conseq if eval_expr(test, env) else alt
        return eval_expr(exp, env)
    elif op == 'define':  # definition
        symbol, exp = args
        env[symbol] = eval_expr(exp, env)
        return
    elif op == 'lambda':  # procedure
        parms, body = args
        return Procedure(parms, body, env)
    else:
        proc = eval_expr(op, env)
        eargs = [eval_expr(arg, env) for arg in args]
        return proc(*eargs)

if __name__ == '__main__':
    filename = sys.argv[1]
    source = open(filename).read()
    tokens = tokenize(source)
    while len(tokens) > 0:
        expr= parse_expr(tokens)
        # print(">>>", expr)
        result = eval_expr(expr, global_env)
        if result == None:
           result = result
        else:
          print(result)