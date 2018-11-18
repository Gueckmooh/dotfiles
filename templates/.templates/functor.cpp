#include <algorithm>
#include <functional>
#include <iostream>
#include <list>
#include <string>
#include <tuple>

const std::string strs[10] =
  {
    "Haha", "Hihi", "Hehe", "Je", "Suis", "Une", "Patate", "Caca", "Pipi", "Popo"
  };

int
main (void)
{
  std::list<std::tuple<int, std::string>> l;
  for (int i = 0; i < 10; ++i)
    {
      std::tuple<int, std::string> t = std::make_tuple (i, strs[i]);
      l.push_back(t);
    }

  struct finder
  {
    finder (int x): _x{x} {}
    void operator()(std::tuple<int, std::string> t)
    {
      if (std::get<0>(t) == _x)
        _val = std::get<1>(t);
    }
    std::string _val;
    int _x;
  };

  finder fc = std::for_each(std::begin(l), std::end(l), finder(7));

  std::cout << fc._val << std::endl;

  return 0;
}
