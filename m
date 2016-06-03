From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Fri, 3 Jun 2016 14:51:36 -0700
Message-ID: <20160603145136.72171851e2dd45ee9f89b689@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__3_Jun_2016_14_51_36_-0700_vtwic89Hlz1A4m_u"
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52399 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448AbcFCVvp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jun 2016 17:51:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org

--Signature=_Fri__3_Jun_2016_14_51_36_-0700_vtwic89Hlz1A4m_u
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

11 fixes, based on 4340fa55298d17049e71c7a34e04647379c269f3:

Subject: mm: fix overflow in vm_map_ram()
Subject: kdump: fix dmesg gdbmacro to work with record based printk
Subject: mm: check the return value of lookup_page_ext for all call sites
Subject: reiserfs: avoid uninitialized variable use
Subject: memcg: add RCU locking around css_for_each_descendant_pre() in mem=
cg_offline_kmem()
Subject: mm/z3fold.c: avoid modifying HEADLESS page and minor cleanup
Subject: checkpatch: reduce git commit description style false positives
Subject: mm, page_alloc: prevent infinite loop in buffered_rmqueue()
Subject: mm, oom_reaper: do not use siglock in try_oom_reaper()
Subject: mm, page_alloc: reset zonelist iterator after resetting fair zone =
allocation policy
Subject: mm, page_alloc: recalculate the preferred zoneref if the context c=
an ignore memory policies




--Signature=_Fri__3_Jun_2016_14_51_36_-0700_vtwic89Hlz1A4m_u
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJXUfvvAAoJEJxZ78cCqAIHJlEP/jqzbavypXOKjMLCKBkWdbVw
nb773IxjrHg5+NT5B22jkPUtX5ZiVP9MVzOEY+08eh7xrT4U+asdrUEmUAuUDy6E
ecyQnIkArRc4NA17XPITCLoYVjnbZIpcLpgEDhs3dLra30LlTzEssOIaXkqSjsnX
kWm1YWBNRn5LJucBu7ry2V7ihX7rYikXT978gG8fJ67gxDXod6H353eNZETBiewq
YXgfhTjbG0p/av1ciglndOSuKxjuLh+eAeS6LpalGMLZnRPrbqQNmjq0Qf8Pd6eF
1FlaSSX+p2qPc6ihU4RpcSfCMJwE8Gb2xMzwiO81gwX9o7phQzPwhBNoK9nf0u+l
ii8+KnwBiUSXXBDCfKEYYtREQwUT3fb2M9GwR1G4b4X3UBsmlvp1mviK0yufZWiZ
3HhR9sbUoA1jPtoyXKiyWM18gsfERJhBj6H1mDD4JpNkrZCoNJYggzhtWpB/59wJ
s/rAwUuT6tfabrjjBwzHPCFyR7K1JYypZ0Q7ZAYfE8gCbAeA0zU0QccsRWLcmq92
cJrYPZO2qWYtFwpziX14/k4v8jZjBr7gd0XeftVhLmo0vyRa+bgIleYO9tuGNpyg
VDX5J3CQU6X4IIQIiNMzRf8VAl7HXSgBTCFDa+1/j0fc+sn7gZVqV1JktKrGjSoA
2tBYKxAWXOD8wqEu9MBt
=r40n
-----END PGP SIGNATURE-----

--Signature=_Fri__3_Jun_2016_14_51_36_-0700_vtwic89Hlz1A4m_u--
