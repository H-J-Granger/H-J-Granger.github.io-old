---
layout: post
title: a post with table of contents
date: 2022-10-21 00:00
description: Gosper 算法是一个用来求一些超几何项的离散不定积分的封闭形式的算法。
tags: formatting toc
categories: sample-posts
giscus_comments: true
related_posts: false
toc:
  beginning: true
---

## 算法简介

Gosper 算法是一个用来求一些超几何项的离散不定积分的封闭形式的算法。特别地，所求的是一些形如

$$
t_n=P(n)\cdot\dfrac{\prod\limits_{i=1}^s(a_in+b_i)!}{\prod\limits_{i=1}^t(c_in+d_i)!}
$$

的函数的离散不定积分。

形式化地，我们想要求出以另一个超几何项 $z_n$ 满足

$$
z_{n+1}-z_n=t_n.\tag{1}
$$

<!-- readmore -->

本文大部分翻译自 Marko Petkovšek, Herbert S. Wilf 和 Doron Zeilberger 合著的 A=B 一书的 Chapter 5: Gosper's Algorithm。

## 记号

本文中 $\prod$ 和 $\sum$ 的优先级均大于 $\cdot$、$+$ 和 $\times$，小于隐式乘法。

在本文中，$\operatorname{deg} f$ 被定义为多项式 $f$ 的最高项次数，$\operatorname{\mathsf{lc}}f$ 被定义为多项式 $f$ 的最高项系数，$\operatorname{\mathsf{sc}}f$ 被定义为非常多项式 $f$ 的次高项系数。

本文用 $\perp $ 来描述“互素”，譬如 $f\perp g$ 等价于 $\deg\gcd(f,g)=0$。

## 基本思路

首先我们不难发现
$$
\dfrac{z_n}{t_n}=\dfrac{z_n}{z_{n+1}-z_n}=\dfrac{1}{\frac{z_{n+1}}{z_n}-1}
$$
是一个关于 $n$ 的有理函数。于是我们设其为有理函数 $y(n)$，将 $z_n=y(n)t_n$ 代入 $(1)$ 式得到
$$
y(n+1)t_{n+1}-y(n)t_n=t_n,
$$
设 $\dfrac{t_{n+1}}{t_n}=r(n)$ 则有
$$
y(n+1)r(n)-y(n)=1.\tag{2}
$$
假设我们能够把 $r(n)$ 写成
$$
r(n)=\dfrac{a(n)c(n+1)}{b(n)c(n)}
$$
的形式（在后文我们会给出一个算法来将任意有理函数 $r(n)$ 分解），满足 
$$
h\in \mathbb N\implies a(n)\perp b(n+h),\tag3
$$
在后续的证明中，我们会发现我们将解有理函数的问题转为了解多项式的问题。

考虑将 $y(n)$ 写成
$$
y(n)=\dfrac{b(n-1)x(n)}{c(n)}
$$
的形式，代入 $(2)$ 式得
$$
a(n)x(n+1)-b(n-1)x(n)=c(n).\tag4
$$
显然 $x(n)$ 是有理函数。事实上我们能够证明，$x(n)$ 实际上甚至是多项式：

假设结论是错的，那么我们就能将 $x(n)$ 写成两个互素的多项式 $f(n)$ 和 $g(n)$ 之比 $\dfrac{f(n)}{g(n)}$，其中 $\deg g\ne 0$。代入 $(3)$：
$$
a(n)f(n+1)g(n)-b(n-1)f(n)g(n+1)=c(n)g(n)g(n+1).\tag5
$$
设 $N$ 为使 $\gcd(g(n),g(n+N))$ 不为常多项式的最大整数 $N$，容易知道 $N\ge 0$。设 $u(n)$ 为 $g(n)$ 和 $g(n+N)$ 的一个非常多项式的不可约公因式。将 $u(n-N)\mid g(n)$ 代入 $(4)$ 知：
$$
u(n-N)\mid b(n-1)f(n)g(n+1).
$$
因为 $u(n-N)\mid g(n)$，故 $u(n-N)\nmid f(n)$。若 $u(n-N)\mid g(n+1)$，则 $u(n)\mid g(n+N+1)$，即 $\gcd(g(n+N+1),g(n))$ 不为常多项式，这与我们对 $N$ 的选取不符。因此 $u(n-N)\mid b(n-1)$，进而 $u(n+1)\mid b(n+N)$。

同样地，将 $u(n+1)\mid g(n+1)$ 代入 $(4)$ 式得：
$$
u(n+1)\mid a(n)f(n+1)g(n).
$$
由于 $u(n+1)\nmid f(n+1)$，以及 $u(n+1)\nmid g(n)$（因为 $u(n)$ 不能同时整除 $g(n-1)$ 和 $g(n+N)$），我们有 $u(n+1)\mid a(n)$。于是 $u(n+1)$ 是 $a(n)$ 和 $b(n+N)$ 的一个非常多项式公因子，这与假设 $(3)$ 矛盾，因而 $x(n)$ 是一个多项式。$\blacksquare$

现在我们确定了 Gosper 算法的基本流程：

1. 将 $r(n)=\dfrac{t_{n+1}}{t_{n}}$ 分解成 $\dfrac{a(n)c(n+1)}{b(n)c(n)}$ 的形式，同时满足 $(3)$ 式的限制；
2. 找到 $(5)$ 式的解 $x(n)$，或发现无解；
3. 若有解，返回 $z_n=\dfrac{b(n-1)x(n)}{c(n)}t_n$。

## 分解 $r(n)$

首先设 $r(n)=\dfrac{f(n)}{g(n)}$（为了方便，令 $f$ 和 $g$ 均为首一多项式，这样可能会在最后需要乘一个系数），其中 $f\perp g$。如果 $a=f,b=g$ 满足 $(3)$ 的限制，那我们可以直接将 $r(n)$ 分解成 $a(n)=f(n)$，$b(n)=g(n)$，$c(n)=1$ 的形式。

否则，如果存在 $h\in\mathbb N$ 使得 $f(n)$ 和 $g(n+h)$ 有公因式 $u(n)$，则我们可以从 $f(n)$ 中提取一个因式 $u(n)$，从 $g(n)$ 中提取一个因式 $u(n-h)$，从而递归下去。分解出来的因式直接让 $c(n)$ 乘上 $\prod_{j=1}^h u(n-j)$ 即可。

唯一问题是，如何判断 $f$ 和 $g$ 是否满足 $(3)$ 式？

一个做法是使用多项式结式（resultant）。

> 域 $F$ 上两个关于 $n$ 的多项式 $A(n)$ 和 $B(n)$ 的结式 $\operatorname{res}(A,B)$ 由下式定义：
> $$
> \operatorname{res}(A,B):=(\operatorname{\mathsf{lc}}B)^{\deg A}(\operatorname{\mathsf{lc}}A)^{\deg B}\prod\limits_{(\mu,\lambda)\in \overline F^2\land A(\lambda)=0\land B(\mu)=0}(\mu-\lambda).
> $$
> 其中域 $\overline F$ 是域 $F$ 的代数闭包，即，所有以 $F$ 中元素为系数的多项式的解都在 $\bar F$ 内。
>
> 事实上，$\operatorname{res}(A,B)$ 的一个等价定义是：
> $$
> \operatorname{res}(A,B)=(\operatorname{\mathsf{lc}}B)^{\deg A}\prod\limits_{\mu\in \overline F\land B(\mu)=0}A(\mu).
> $$
> 根据以上两种定义不难得到结式的以下性质：
>
> - $\operatorname{res}(A,B)=(-1)^{\deg A\cdot \deg B}\prod\operatorname{res}(B,A)$；
> - $\operatorname{res}(\mu A,\lambda B)=\mu^{\deg A}\lambda^{\deg B}\operatorname{res}(A,B)$；
> - $\operatorname{res}(A,B)=(\operatorname{\mathsf{lc}}B)^{\deg A}(\operatorname{\mathsf{lc}}A)^{\deg B}$，若 $\deg A\cdot \deg B=0$；
> - $\operatorname{res}(A-CB,B)=\operatorname{res}(A,B)$，若 $\operatorname{\mathsf{lc}} B=1$。
>
> 于是我们可以得到一个 $O(\deg A\cdot \deg B)$ 的求解结式的 Euclid 算法：
>
> - 若 $\deg B=0$，则 $\operatorname{res}(A,B)=(\operatorname{\mathsf{lc}}B)^{\deg A}(\operatorname{\mathsf{lc}}A)^{\deg B}$；
> - 否则，$\operatorname{res}(A,B)=(\operatorname{\mathsf{lc}}B)^{\deg A-\deg (A\bmod B)}(-1)^{\deg B\cdot\deg (A\bmod B)}\operatorname{res}(B,A\bmod B)$。
>
> 事实上，还有一种被称为 Half-GCD 的算法可以在 $O(n^{1+\varepsilon})$ 的时间复杂度内求出 $A$ 和 $B$ 的结式，其中 $n=\max\{A,B\}$。$^{[1]}$

不难发现，两个非常多项式 $f$ 和 $g$ 有公共根当且仅当 $\operatorname{res}(f,g)=0$。我们设 $R(h)=\operatorname{res}(f(n),g(n+h))$，则所有违反 $(3)$ 式的 $h$ 即为 $R(h)$ 的非负整数根。

如何在 $\mathbb N$ 上解 $R(h)=0$？首先我们仅保留和分母互素的分子 $S(h)$，于是只需要解 $S(h)=0$，其中 $S(h)$ 是多项式。如果 $S$ 的系数在 $\mathbb Q$ 内，则我们可以通过先将其化为首一多项式，并枚举其常数项的因数来得到其所有的有理根。事实上，还有一种更加高效的、利用 $p$ 进数的算法可以解决这个问题。$^{[2]}$

更加通用地，设 $K$ 为以 $\overline K$ 中元素为系数的关于 $\alpha$ 的有理函数所组成的元素。假设我们已经拥有一种处理 $S$ 的系数在 $A_\overline K$ 内的算法，那么我们可以以如下方式构建出 $A_K$ 所对应的算法：

首先做转换
$$
\begin{aligned}
R(h)&=\sum\limits_{i=0}^sa_ih^i\\
&=\dfrac1{r(\alpha)}\sum\limits_{i=0}^sp_i(\alpha)h^i\\
&=\dfrac1{r(\alpha)}\sum\limits_{i=0}^sh^i\sum\limits_{j=0}^{t_s}\mu_{i,j}\alpha^j\\
&=\dfrac1{r(\alpha)}\sum\limits_{j=0}^{t}\alpha^j\sum\limits_{i=0}^s\mu_{i,j}h^i\\
&=\dfrac1{r(\alpha)}\sum\limits_{j=0}^tq_j(h)\alpha^j,
\end{aligned}
$$
其中 $r,p_i,q_j\in \overline K[x]$。如果有 $u\in \overline K$ 满足 $R(u)=0$，那么就有
$$
\sum\limits_{j=0}^tq_j(u)\alpha^j=0.\tag 6
$$
分类讨论：

- 如果 $\alpha$ 在 $\overline K$ 中是超越的，那么显然 $q_j(u)=0$ 对全部 $[0,t]$ 内的整数 $j$ 成立；
- 如果存在一个系数在 $\overline K$ 内的多项式的根为 $\alpha$，且 $d$ 为多项式的最小次数。则 $\deg p_i< d$。于是，$t< d$。于是使 $(6)$ 式成立的唯一可能是 $q_j(u)=0$ 对全体 $[0,t]$ 内整数 $j$ 成立。

无论如何都有 $q_j(u)=0$。于是我们可以对 $q_j$ 分别应用 $A_{\overline K}$。

另一种做法是将 $f$ 和 $g$ 化成若干个不可约多项式乘积（注意不必在整个代数闭包上完全分解），那么我们需要找到一个 $f(n)$ 的不可约因式 $u(n)$ 和 $g(n)$ 的一个不可约因式 $v(n)$ 满足存在 $h\in \mathbb N$ 使得 $u(n)=v(n+h)$，这样 $f(n)$ 和 $g(n+h)$ 就有一个非常多项式公因式，即 $h$ 违反 $(3)$ 式。注意到一个因式对 $(u,v)$ 满足条件的一个必要条件是 $\deg u=\deg v=d$。设 $u(n)=n^d+An^{d-1}+O(n^{d-2})$，$v(n)=n^d+Bn^{d-1}+O(n^{d-2})$，那么通过比较次大项系数我们发现唯一可能满足条件的 $h=\dfrac{A-B}d$。

在实践中，通常 $f$ 和 $g$ 已经被分解成一次因式了，这可能是因为初始的超几何项即为二项式系数和阶乘的乘积。此时，两种做法是完全相同的。如果 $f$ 和 $g$ 未被分解，则通常而言就算要使用结式，事先分解 $f$ 和 $g$ 也通常能加速结式的计算。那为什么还需要使用结式做法呢？这是因为在任何域上我们都能计算多项式结式，但目前人们还尚未知道通用的因式分解方法。

不难验证，通过“基本思路”中过程得到的 $r(n)$ 的分解 $\dfrac{a(n)c(n+1)}{b(n)c(n)}$ 是一个互素、唯一、次数最小的形式。

## 解 $x(n)$

在这节我们希望能解出满足 $(4)$ 式的多项式 $x(n)$。假定我们能知道 $\deg x(n)$ 的一个范围，我们就可以使用待定系数法列出一个线性方程组以解出 $x(n)$。

设 $\deg x(n)=d$，我们希望知道 $d$ 的可能值。可以分类讨论一下：

- 如果 $\deg a\ne \deg b$ 或 $\operatorname{\mathsf{lc}}a\ne \operatorname{\mathsf{lc}}b$，即 $a$ 和 $b$ 的最高项不同，那么 $(4)$ 式左手边的系数为 $d+\max\{\deg a,\deg b\}$，右手边的系数为 $\deg c$。$d$ 的唯一可能值为 $\deg c-\max\{\deg a,\deg b\}$；

- 否则，即 $a$ 和 $b$ 的最高项相同。即 $(4)$ 式左手边的最高项被消去了。继续分类：

  - 如果 $(4)$ 式左手边的次高项未被消去，则 $(4)$ 式左手边的系数为 $d+\max\{\deg a,\deg b\}+1$，右手边的系数为 $\deg c$。$d$ 的唯一可能值为 $\deg c-\max\{\deg a,\deg b\}-1$；

  - 否则，设
    $$
    \begin{aligned}
    a(n)&=\lambda n^k+An^{k-1}+O(n^{k-2}),\\
    b(n-1)&=\lambda n^k+Bn^{k-1}+O(n^{k-2}),\\
    x(n)&=C_0n^d+C_1n^{d-1}+O(n^{d-2}).
    \end{aligned}
    $$
    代入 $(4)$ 式得到：
    $$
    a(n)x(n+1)-b(n-1)x(n)=C_0(\lambda d+A-B)n^{k+d-1}+O(n^{k+d-2}).
    $$
    于是 $d$ 的唯一可能值为 $\dfrac{B-A}\lambda$。

  于是，此情况中 $d$ 仅可能在 $\{\deg c-\max\{\deg a,\deg b\}-1,\frac{\operatorname{\mathsf{sc}}(b(n-1))-\operatorname{\mathsf{sc}}a}{\operatorname{\mathsf{lc}}a}\}$ 中取值。

先得到 $d$ 的可能取值范围，找到其中最大的自然数 $d_m$。如果 $d_m$ 不存在则无法找到封闭形式，否则直接待定系数法。如果待定系数法无解则亦无法找到封闭形式。

## 小练习

通过 Gosper 算法求下述和式的封闭形式。

$$
\begin{array}{ll}
\text{(a)}&\displaystyle\sum\limits_{n=0}^m\dfrac{\binom{2n}n^2}{4^{2n}(n+1)}\\
\text{(b)}&\displaystyle\sum\limits_{n=0}^m\dfrac{(4n-1)\binom{2n}n^2}{4^{2n}(2n-1)^2}\\
\text{(c)}&\displaystyle\sum\limits_{n=0}^m\dfrac{n(n-\frac12)!}{(n+1)!}\\
\text{(d)}&\displaystyle\sum\limits_{n=0}^m\dfrac{n(n+a+b)a^nb^n}{(n+a)!(n+b)!}\\
\text{(e)}&\displaystyle\sum\limits_{n=1}^m\dfrac{6n+3}{4n^4+8n^3+8n^2+4n+3}\\
\text{(f)}&\displaystyle\sum\limits_{n=4}^m\dfrac{4(1-n)(n^2-2n-1)}{n^2(n+1)^2(n-2)^2(n-3)^2}\\
\text{(g)}&\displaystyle\sum\limits_{n=1}^m\dfrac{2^n(n^4-14n^2-24n-9)}{n^2(n+1)^2(n+2)^2(n+3)^2}\\
\text{(h)}&\displaystyle\sum\limits_{n=0}^m\dfrac{n^44^n}{\binom{2n}n}
\end{array}
$$

其中 $\rm (a),(b),(c),(d),(h)$ 摘自 $^{[3]}$，$\rm (e)$ 摘自 $^{[4]}$，$\rm (f),(g)$ 摘自 $^{[5]}$。

<!--
1f 1g 1h 2d 3b 3f 3g 1d
-->

练习答案：
$$
\begin{array}{ll}
\text{(a)}&\dfrac{(2n+1)^2\binom{2n}{n}^2}{4^{2n}(n+1)}\\
\end{array}
$$


## 参考资料

- Marko Petkovšek, Herbert S. Wilf and Doron Zeilberger, A=B, 83-100.

## 致谢

感谢 @[Y_B_X](https://uoj.ac/user/profile/Y_B_X) 同学给予的许多指导和帮助。

## Reference

[^1]: E.I., [HALF-GCD 算法的阐述](https://entropyincreaser.blog.uoj.ac/blog/5438).
[^2]: Loos, R., Computing rational zeros of integral polynomials by $p$-adic expansion, *SIAM J. Comp*. **12** (1983), 286-293.
[^3]: Gosper, R. W., Jr., Indefinite hypergeometric sums in MACSYMA, in: *Proc. 1977 MACSYMA Users' Conference*, Berkeley, 1977, 237-251.
[^4]: Abramov, S. A., On the summation of rational functions, *USSR Comp. Maths. Math. Phys.* **11** (1971), 324-330.
[^5]: Man, Y. K., On computing closed forms for inde¯nite summations, *J. Symbolic Computation* **16** (1993), 355-376.
