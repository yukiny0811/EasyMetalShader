//
//  SVD.swift
//  
//
//  Created by Yuki Kuwashima on 2024/01/06.
//
//Copyright 2021 National Technology & Engineering Solutions of Sandia, LLC (NTESS). Under the terms of Contract DE-NA0003525 with NTESS, the U.S. Government retains certain rights in this software.
//
//Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

// modified by Yuki Kuwashima

extension MetalPreLibrary {
    static let svd =
"""
inline void swap(thread float &a, thread float &b) {
    float temp = a;
    a = b;
    b = temp;
}

void givens(
    thread const float& a,
    thread const float& b,
    thread float& c,
    thread float& s)
{
  c = 1.0;
  s = 0.0;
  if (b != 0.0) {
    if (abs(b) > abs(a)) {
      float const t = -a / b;
      s = 1.0 / sqrt(1.0 + t * t);
      c = t * s;
    } else {
      float const t = -b / a;
      c = 1.0 / sqrt(1.0 + t * t);
      s = t * c;
    }
  }
}

void svd_bidiagonal(
    float f,
    thread float const& g,
    float h,
    thread float2x2& U,
    thread float2x2& S,
    thread float2x2& V)
{
  float fa = abs(f);
  float ga = abs(g);
  float ha = abs(h);
  float s0 = 0.0;
  float s1 = 0.0;
  float cu = 1.0;
  float su = 0.0;
  float cv = 1.0;
  float sv = 0.0;
  bool const swap_diag = (ha > fa);
  if (swap_diag) {
    swap(fa, ha);
    swap(f, h);
  }
  float epsilon = 1e-6;
  if (ga == 0.0) {
    s1 = ha;
    s0 = fa;
  } else if (ga > fa && fa / ga < epsilon) {
    // case of very large ga
    s0 = ga;
    s1 = ha > 1.0 ? (fa / (ga / ha)) : ((fa / ga) * ha);
    cu = 1.0;
    su = h / g;
    cv = f / g;
    sv = 1.0;
  } else {
    // normal case
    float const d = fa - ha;
    float const l = d / fa;
    float const m = g / f;
    float const t = 2.0 - l;
    float const mm = m * m;
    float const tt = t * t;
    float const s = sqrt(tt + mm);
    float const r = ((l != 0.0) ? (sqrt(l * l + mm)) : (abs(m)));
    float const a = 0.5 * (s + r);
    s1 = ha / a;
    s0 = fa * a;
    // Compute singular vectors
    float tau;  // second assignment to T in DLASV2
    if (mm != 0.0) {
      tau = (m / (s + t) + m / (r + l)) * (1.0 + a);
    } else {
      // note that m is very tiny
      tau = (l == 0.0) ? (copysign(2.0, f) * copysign(1.0, g))
                       : (g / copysign(d, f) + m / t);
    }
    float const lv = sqrt(tau * tau + 4.0);  // second assignment to L in DLASV2
    cv = 2.0 / lv;
    sv = tau / lv;
    cu = (cv + sv * m) / a;
    su = (h / f) * sv / a;
  }
  // Fix signs of singular values in accordance to sign of singular vectors
  s0 = copysign(s0, f);
  s1 = copysign(s1, h);
  if (swap_diag) {
    swap(cu, sv);
    swap(su, cv);
  }
  U = float2x2(cu, -su, su, cu);
  S = float2x2(s0, 0.0, 0.0, s1);
  V = float2x2(cv, -sv, sv, cv);
}


void svd_2x2(
    thread float2x2 const& A,
    thread float2x2& U,
    thread float2x2& S,
    thread float2x2& V)
{
  // First compute a givens rotation to eliminate 1,0 entry in tensor
  float c, s;
  givens(A[0][0], A[1][0], c, s);
  float2x2 const R = float2x2(c, -s, s, c);
  float2x2 const B = A * R;
  // B is bidiagonal. Use specialized algorithm to compute its SVD
  float2x2 U_B, S_B, V_B;
  svd_bidiagonal(B[0][0], B.columns[0][1], B.columns[1][1], U_B, S_B, V_B);
  float2x2 const X = U_B;
  S = S_B;
  V = V_B;
  // Complete general 2x2 SVD with givens rotation calculated above
  U = transpose(R) * X;
}
"""
}
