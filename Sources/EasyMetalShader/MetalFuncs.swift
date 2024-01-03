//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/01/04.
//

import Foundation

enum MetalFuncs {
    static let svd =
//"""
//inline void givens(float a, float b, float c, thread float &s) {
//    c = 1;
//    s = 0;
//    if (b != 0) {
//        if (abs(b) > abs(a)) {
//            float t = -a / b;
//            s = 1 / sqrt(1+t*t);
//            c = t * s;
//        } else {
//            float t = -b / a;
//            c = 1 / sqrt(1+t*t);
//            s = t * c;
//        }
//    }
//}
//
//inline void swap(thread float &a, thread float &b) {
//    float temp = a;
//    a = b;
//    b = temp;
//}
//
//inline void svd_bidiagonal(float f, float g, float h, thread float2x2 &U, thread float2x2 &S, thread float2x2 &V) {
//    float epsilon = 1.0e-6;
//    float fa = abs(f);
//    float ga = abs(g);
//    float ha = abs(h);
//    float s0 = 0.0;
//    float s1 = 0.0;
//    float cu = 1.0;
//    float su = 0.0;
//    float cv = 1.0;
//    float sv = 0.0;
//
//    bool swap_diag = ha > fa;
//    if (swap_diag) {
//        swap(fa, ha);
//        swap(f, h);
//    }
//    if (ga < epsilon) {
//        s1 = ha;
//        s0 = fa;
//    } else if (ga > fa && fa / ga < epsilon) {
//        // case of very large ga
//        s0 = ga;
//        s1 = ha > 1.0 ? (fa / (ga / ha)) : ((fa / ga) * ha);
//        cu = 1.0;
//        su = h / g;
//        cv = f / g;
//        sv = 1.0;
//    } else {
//        // normal case
//        float d = fa - ha;
//        float l = d / fa;
//        float m = g / f;
//        float t = 2 - l;
//        float mm = m * m;
//        float tt = t * t;
//        float s = sqrt(tt + mm);
//        float r = ((l != 0.0) ? (sqrt(l * l + mm)) : (abs(m)));
//        float a = 0.5 * (s + r);
//
//        s1 = ha / a;
//        s0 = fa * a;
//        // Compute singular vectors
//        float tau = 0.0;
//        if (mm >= epsilon) {
//            tau = (m / (s + t) + m / (r + l)) * (1 + a);
//        } else {
//            // note that m is very tiny
//            tau = (l < epsilon) ? (copysign(2.0, f) * copysign(1.0, g)) : (g / copysign(d, f) + m / t);
//        }
//        float lv = sqrt(tau * tau + 4.0);
//        cv = 2.0 / lv;
//        sv = tau / lv;
//        cu = (cv + sv * m) / a;
//        su = (h / f) * sv / a;
//    }
//    //Fix signs of singular values in accordance to sign of singular vectors
//    s0 = copysign(s0, f);
//    s1 = copysign(s1, h);
//    if (swap_diag) {
//        swap(cu, sv);
//        swap(su, cv);
//    }
//    U = float2x2(cu, -su, su, cu);
//    S = float2x2(s0, 0.0, 0.0, s1);
//    V = float2x2(cv, -sv, sv, cv);
//}
//
//inline void svd_2x2(thread float2x2 &A, thread float2x2 &U, thread float2x2 &S, thread float2x2 &V){
//    float c = 0.0;
//    float s = 0.0;
//    givens(A.columns[0].x, A.columns[1].x, c, s); //???
//    float2x2 R = float2x2(c, -s, s, c);
//    float2x2 B = R * A;
//    float2x2 U_B = float2x2(0, 0, 0, 0);
//    float2x2 S_B = float2x2(0, 0, 0, 0);
//    float2x2 V_B = float2x2(0, 0, 0, 0);
//    svd_bidiagonal(B.columns[0].x, B.columns[0].y, B.columns[1].y, U_B, S_B, V_B); //???
//    float2x2 X = U_B;
//    S = S_B;
//    V = V_B;
//    U = transpose(R) * X;
//}
//
//inline void svd(thread float2x2 &base, thread float2x2 &W, thread float2 &E, thread float2x2 &V) {
//    W = float2x2(float2(0, 0), float2(0, 0));
//    float2x2 tempE = float2x2(float2(0, 0), float2(0, 0));
//    V = float2x2(float2(0, 0), float2(0, 0));
//    svd_2x2(base, W, tempE, V);
//    if (tempE.columns[0].x < 0 && tempE.columns[1].y < 0) {
//        V *= -1;
//    }
//    E = float2(tempE.columns[0].x, tempE.columns[1].y);
//}
//"""
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
  givens(A.columns[0].x, A.columns[1].x, c, s);
  float2x2 const R = float2x2(c, -s, s, c);
  float2x2 const B = R * A;
  // B is bidiagonal. Use specialized algorithm to compute its SVD
  float2x2 U_B, S_B, V_B;
  svd_bidiagonal(B.columns[0].x, B.columns[0].y, B.columns[1].y, U_B, S_B, V_B);
  float2x2 const X = U_B;
  S = S_B;
  V = V_B;
  // Complete general 2x2 SVD with givens rotation calculated above
  U = transpose(R) * X;
}
"""
}
