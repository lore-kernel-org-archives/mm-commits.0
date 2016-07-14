From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Thu, 14 Jul 2016 12:06:34 -0700
Message-ID: <20160714120634.107e9624972e2e1ad85847bf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__14_Jul_2016_12_06_34_-0700_RVnjASQjw80hpafV"
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40923 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbcGNTGl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jul 2016 15:06:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org

--Signature=_Thu__14_Jul_2016_12_06_34_-0700_RVnjASQjw80hpafV
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

20 fixes, based on f97d10454e4da2aceb44dfa7c59bb43ba9f50199:

Subject: mm, compaction: prevent VM_BUG_ON when terminating freeing scanner
Subject: kasan: add newline to messages
Subject: scripts/gdb: silence 'nothing to do' message
Subject: scripts/gdb: rebuild constants.py on dependancy change
Subject: scripts/gdb: add constants.py to .gitignore
Subject: scripts/gdb: Perform path expansion to lx-symbol's arguments
Subject: Revert "scripts/gdb: add a Radix Tree Parser"
Subject: Revert "scripts/gdb: add documentation example for radix tree"
Subject: madvise_free, thp: fix madvise_free_huge_pmd return value after sp=
litting
Subject: uapi: export lirc.h header
Subject: kasan/quarantine: fix bugs on qlist_move_cache()
Subject: mm, meminit: always return a valid node from early_pfn_to_nid
Subject: mm, meminit: ensure node is online before checking whether pages a=
re uninitialised
Subject: gcov: add support for gcc version >=3D 6
Subject: vmlinux.lds: account for destructor sections
Subject: mm: thp: move pmd check inside ptl for freeze_page()
Subject: mm: rmap: call page_check_address() with sync enabled to avoid rac=
y check
Subject: mm: thp: refix false positive BUG in page_move_anon_rmap()
Subject: mm: workingset: printk missing log level, use pr_info()
Subject: m32r: fix build warning about putc




--Signature=_Thu__14_Jul_2016_12_06_34_-0700_RVnjASQjw80hpafV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJXh+LAAAoJEJxZ78cCqAIH0BIP/0s+uB6iTwHVCMf55W8qpe8m
LU4YGN9y+yj4jhxMOM9VJ6CaFv4h/9183vbZWdE1RSI55pC9zkBDOUgwrd/yDJGL
4V1/bLZgI0cObO9pDBG3fqkT5h0vDGvVBS3Lm2ZUGW+JenIV366uMvkPUWXOuNEF
lQUub2DjTQ5WUe8RI4hulfwjIq6JGXU0eOzVpoIsk5z+SJpzdLmujHBVLQOpgKYG
6jVvfKXoDvaVL+dcPJ5YCgaTpt1r9wwmccVG6SNnZjI1ObC0U8dJUZ2mFYELXCDa
wZO7JXDtqngoYWSaznDkdpDfr2YQo9wV1L+3+uKbD+tj6qBVhuX2FSz2slpG8YLe
J7k8smGYLG7uhSS2lGSRP3+42dXQad1Fn75qrK38wZtHOTJ8dOWXAZyNgHTvZ1qv
jOiYWjhPySOR65uIrpRjHzxQBiHecl+iuNHeS+N5uGte3wJ/p5HdmQe2JogztVwp
rjd9WP9Fb3i2UZex0Xwg1jW455go9ajMjRO8No41ggeYxy/YSsxPStPzmuFtGCvS
jzvXEGeUdclddw/1XjzRXKHLSVeTem8BJ2bHuOrZ1Dq2cggrOzvUnnQm4s44f3EW
Sm4YGpJixUAb5L9TLnIYSWIbWYFi7p9ziVorS+KyHZQ1+xkShn7tFDtHFtd3r03O
wZKIzw56rgRnd/ZH6wuo
=J2c4
-----END PGP SIGNATURE-----

--Signature=_Thu__14_Jul_2016_12_06_34_-0700_RVnjASQjw80hpafV--
