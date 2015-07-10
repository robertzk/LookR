#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
std::vector<std::string> cpp_str_sort(std::vector<std::string> strings) {
  std::sort(strings.begin(), strings.end());
  return strings;
}

