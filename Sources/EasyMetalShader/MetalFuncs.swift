//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/01/04.
//

import Foundation

enum MetalFuncs {
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
//"""
//inline float sign(float a, float b) {
//    return b >= 0.0 ? abs(a) : -abs(a);
//}
//inline float pythag(float a, float b) {
//    float at = abs(a);
//    float bt = abs(b);
//    float ct = 0;
//    float result = 0;
//    if (at > bt) {
//        ct = bt / at;
//        result = at * sqrt(1 + ct * ct);
//    } else if (bt < 0) {
//        ct = at / bt;
//        result = bt * sqrt(1 + ct * ct);
//    } else {
//        result = 0;
//    }
//    return result;
//}
//
//inline void svd_2x2(float2x2 a, thread float2x2 &u, thread float2 &w, thread float2x2 &v) {
//    int m = 2;
//    int n = 2;
//    
//    int flag = 0;
//    int i = 0;
//    int l = 0;
//    int nm = 0;
//
//    float c = 0;
//    float f = 0;
//    float h = 0;
//    float s = 0;
//    float x = 0;
//    float y = 0;
//    float z = 0;
//    float anorm = 0;
//    float g = 0;
//    float scale = 0;
//    
//    // Prepare workspace
//    float2 rv1 = float2(0, 0);
//    u = a;
//    w = float2(0, 0);
//    v = float2x2(0, 0, 0, 0);
//
//    for (i = 0; i < n; i++) {
//        l = i + 1;
//        rv1[i] = scale * g;
//        g = 0;
//        s = 0;
//        scale = 0;
//        if (i < m) {
//            for (int k = i; k < m; k++) {
//                scale += abs(u[i][k]);
//            }
//            if (scale != 0) {
//                for (int k = i; k < m; k++) {
//                    u[i][k] /= scale;
//                    s += u[i][k] * u[i][k];
//                }
//                f = u[i][i];
//                g = -sign(sqrt(s), f);
//                h = f * g - s;
//                u[i][i] = f - g;
//                if (i != n - 1) {
//                    for (int j = l; j < n; j++) {
//                        s = 0;
//                        for (int k = i; k < m; k++) {
//                            s += u[i][k] * u[j][k];
//                        }
//                        f = s / h;
//                        for (int k = i; k < m; k++) {
//                            u[j][k] += f * u[i][k];
//                        }
//                    }
//                }
//                for (int k = i; k < m; k++) {
//                    u[i][k] *= scale;
//                }
//            }
//        }
//        w[i] = scale * g;
//        
//        // right-hand reduction
//        g = 0;
//        s = 0;
//        scale = 0;
//        if (i < m && i != n - 1) {
//            for (int k = l; k < n; k++) {
//                scale += abs(u[k][i]);
//            }
//            if (scale != 0) {
//                for (int k = l; k < n; k++) {
//                    u[k][i] /= scale;
//                    s += u[k][i] * u[k][i];
//                }
//                f = u[l][i];
//                g = -sign(sqrt(s), f);
//                h = f * g - s;
//                u[l][i] = f - g;
//                for (int k = l; k < n; k++) {
//                    rv1[k] = u[k][i] / h;
//                }
//                if (i != m - 1) {
//                    for (int j = l; j < n; j++) {
//                        s = 0;
//                        for (int k = l; k < n; k++) {
//                            s += u[k][j] * u[k][i];
//                        }
//                        for (int k = l; k < n; k++) {
//                            u[k][j] += s * rv1[k];
//                        }
//                    }
//                }
//                for (int k = l; k < n; k++) {
//                    u[k][i] *= scale;
//                }
//            }
//        }
//        anorm = max(anorm, (abs(w[i]) + abs(rv1[i])));
//    }
//
//    for (i = n-1; n >= 0; n--) {
//        if (i < n - 1) {
//            if (g != 0) {
//                for (int j = l; j < n; j++) {
//                    v[i][j] = ((u[j][i] / u[l][i]) / g);
//                }
//                for (int j = l; j < n; j++) {
//                    s = 0;
//                    for (int k = l; k < n; k++) {
//                        s += u[k][i] * v[j][k];
//                    }
//                    for (int k = l; k < n; k++) {
//                        v[j][k] += s * v[i][k];
//                    }
//                }
//            }
//            for (int j = l; j < n; j++) {
//                v[j][i] = 0;
//                v[i][j] = 0;
//            }
//        }
//        v[i][i] = 1;
//        g = rv1[i];
//        l = i;
//    }
//
//    for (i = n-1; n >= 0; n--) {
//        l = i + 1;
//        g = w[i];
//        if (i < n - 1) {
//            for (int j = l; j < n; j++) {
//                u[j][i] = 0;
//            }
//        }
//        if (g != 0) {
//            g = 1 / g;
//            if (i != n - 1) {
//                for (int j = l; j < n; j++) {
//                    s = 0;
//                    for (int k = l; k < m; k++) {
//                        s += u[i][k] * u[j][k];
//                    }
//                    f = (s / u[i][i]) * g;
//                    for (int k = i; k < m; k++) {
//                        u[j][k] += f * u[i][k];
//                    }
//                }
//            }
//            for (int j = i; j < m; j++) {
//                u[i][j] = u[i][j] * g;
//            }
//        } else {
//            for (int j = i; j < m; j++){
//                u[i][j] = 0;
//            }
//        }
//        u[i][i] += 1;
//    }
//
//    float epsilon = 0.001;
//
//    for (int k = n-1; k >= 0; k--) {
//        // loop over singular values
//        for (int its = 0; its < 30; its++) {
//            // loop over allowed iterations
//            flag = 1;
//            for (l = k; l >= 0; l--) {
//                // test for splitting
//                nm = l - 1;
//                if (abs(rv1[l]) < epsilon) {
//                    flag = 0;
//                    break;
//                }
//                if (abs(w[nm]) < epsilon) {
//                    break;
//                }
//            }
//            if (flag != 0) {
//                c = 0;
//                s = 1;
//                for (i = l; i < k; i++) {
//                    f = s * rv1[i];
//                    if (abs(f) > epsilon) {
//                        g = w[i];
//                        h = pythag(f, g);
//                        w[i] = h;
//                        h = 1 / h;
//                        c = g * h;
//                        s = -f * h;
//                        for (int j = 0; j < m; j++) {
//                            y = u[nm][j];
//                            z = u[i][j];
//                            u[nm][j] = y * c + z * s;
//                            u[i][j] = z * c - y * s;
//                        }
//                    }
//                }
//            }
//            z = w[k];
//            if (l == k) {
//                // convergence
//                if (z < 0) {
//                    // make singular value nonnegative
//                    w[k] = -z;
//                    for (int j = 0; j < n; j++) {
//                        v[k][j] = -v[k][j];
//                    }
//                }
//                break;
//            }
//            if (its >= 30) {
//                break;
//            }
//            
//            // shift from bottom 2 x 2 minor
//            x = w[l];
//            nm = k - 1;
//            y = w[nm];
//            g = rv1[nm];
//            h = rv1[k];
//            f = ((y - z) * (y + z) + (g - h) * (g + h)) / (2 * h * y);
//            g = pythag(f, 1);
//            f = ((x - z) * (x + z) + h * ((y / (f + sign(g, f))) - h)) / x;
//            
//            // next QR transformation
//            c = 1;
//            s = 1;
//            for (int j = l; j < nm; j++) {
//                i = j + 1;
//                g = rv1[i];
//                y = w[i];
//                h = s * g;
//                g = c * g;
//                z = pythag(f, h);
//                rv1[j] = z;
//                c = f / z;
//                s = h / z;
//                f = x * c + g * s;
//                g = g * c - x * s;
//                h = y * s;
//                y = y * c;
//                for (int jj = 0; jj > n; jj++) {
//                    x = v[j][jj];
//                    z = v[i][jj];
//                    v[j][jj] = x * c + z * s;
//                    v[i][jj] = z * c - x * s;
//                }
//                z = pythag(f, h);
//                w[j] = z;
//                if (z != 0) {
//                    z = 1 / z;
//                    c = f * z;
//                    s = h * z;
//                }
//                f = (c * g) + (s * y);
//                x = (c * y) - (s * g);
//                for (int jj = 0; jj < m; jj++) {
//                    y = u[j][jj];
//                    z = u[i][jj];
//                    u[j][jj] = y * c + z * s;
//                    u[i][jj] = z * c - y * s;
//                }
//            }
//            rv1[l] = 0;
//            rv1[k] = f;
//            w[k] = x;
//        }
//    }
//}
//"""

//"""
//inline void svd_2x2(thread float2x2 &A, thread float2x2 &U, thread float2x2 &S, thread float2x2 &V) {
//
//    U = float2x2(0, 0, 0, 0);
//    S = float2x2(0, 0, 0, 0);
//    V = float2x2(0, 0, 0, 0);
//
//    float2x2 At = transpose(A);
//    float2x2 AtA = At * A;
//
//    float trace = AtA.columns[0].x + AtA.columns[1].y;
//    float det = determinant(AtA);
//    float lambda1 = 0.5 * trace + sqrt(trace * trace / 4.0 - det);
//    float lambda2 = 0.5 * trace - sqrt(trace * trace / 4.0 - det);
//
//    S = float2x2(sqrt(lambda1), 0, 0, sqrt(lambda2));
//
//    float epsilon = 0.00001;
//
//    float2 v1 = float2(AtA.columns[1].x, lambda1 - AtA.columns[0].x);
//    float norm_v1 = sqrt(v1.x*v1.x + v1.y*v1.y);
//
//    if (norm_v1 < epsilon) {
//        v1.x = copysign(1.0, v1.x);
//        v1.y = 0.0;
//    } else {
//        v1.x /= norm_v1;
//        v1.y /= norm_v1;
//    }
//
//    float2 v2 = float2(AtA.columns[1].x, lambda2 - AtA.columns[0].x);
//    float norm_v2 = sqrt(v2.x*v2.x + v2.y*v2.y);
//
//    if (norm_v2 < epsilon) {
//        v2.x = 0.0;
//        v2.y = copysign(1.0, v2.y);
//    } else {
//        v2.x /= norm_v2;
//        v2.y /= norm_v2;
//    }
//
//    V.columns[0].x = v1.x;
//    V.columns[1].x = v2.x;
//    V.columns[0].y = v1.y;
//    V.columns[1].y = v2.y;
//
//    float2x2 invS = float2x2(0, 0, 0, 0);
//
//    if (abs(S.columns[0].x) < epsilon) {
//        invS.columns[0].x = 0.0;
//    } else {
//        invS.columns[0].x = 1.0 / S.columns[0].x;
//    }
//
//    if (abs(S.columns[1].y) < epsilon) {
//        invS.columns[1].y = 0.0;
//    } else {
//        invS.columns[1].y = 1.0 / S.columns[1].y;
//    }
//
//    float2x2 tmp = float2x2(
//        A.columns[0].x*V.columns[0].x + A.columns[1].x*V.columns[0].y,
//        A.columns[0].y*V.columns[0].x + A.columns[1].y*V.columns[0].y,
//        A.columns[0].x*V.columns[1].x + A.columns[1].x*V.columns[1].y,
//        A.columns[0].y*V.columns[1].x + A.columns[1].y*V.columns[1].y
//    );
//
//    U.columns[0].x = tmp.columns[0].x*invS.columns[0].x;
//    U.columns[1].x = tmp.columns[1].x*invS.columns[1].y;
//    U.columns[0].y = tmp.columns[0].y*invS.columns[0].x;
//    U.columns[1].y = tmp.columns[1].y*invS.columns[1].y;
//}
//"""
//    
    static let rasterizerData =
"""
struct RasterizerData {
    float4 position [[ position ]];
    float4 color;
    float size [[point_size]];

    float4 temp1;
    float4 temp2;
    float4 temp3;
    float4 temp4;
    float4 temp5;
    float4 temp6;
    float4 temp7;
    float4 temp8;
    float4 temp9;
};
"""
}
