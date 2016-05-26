From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Thu, 26 May 2016 15:15:37 -0700
Message-ID: <20160526151537.f0785f200fa74c72c5206ef7@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__26_May_2016_15_15_37_-0700_fBbNlIPPGblddV3z"
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49369 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733AbcEZWPp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 May 2016 18:15:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org

--Signature=_Thu__26_May_2016_15_15_37_-0700_fBbNlIPPGblddV3z
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

10 fixes, based on ea8ea737c46cffa5d0ee74309f81e55a7e5e9c2a:

Subject: seqlock: fix raw_read_seqcount_latch()
Subject: mm: make CONFIG_DEFERRED_STRUCT_PAGE_INIT depends on !FLATMEM expl=
icitly
Subject: mm: kasan: remove unused 'reserved' field from struct kasan_alloc_=
meta
Subject: mm: slub: remove unused virt_to_obj()
Subject: ocfs2: fix improper handling of return errno
Subject: memcg: fix mem_cgroup_out_of_memory() return value.
Subject: mm: oom_reaper: remove some bloat
Subject: dma-debug: avoid spinlock recursion when disabling dma-debug
Subject: update "mm/zsmalloc: don't fail if can't create debugfs info"
Subject: drivers/pinctrl/intel/pinctrl-baytrail.c: fix build with gcc-4.4


--Signature=_Thu__26_May_2016_15_15_37_-0700_fBbNlIPPGblddV3z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJXR3WQAAoJEJxZ78cCqAIH9tQP/2h68t5hXid4SHESBHCWdRXK
p7rvhYdBiakhJuUm8SHqZ4Dac1tp8e6c9ZsThnaPPJvsJOs0rTMcs6d5PVyuZO3k
gVRIgV9C5yLtGlpMZkDk2P59XTedHq+8eImR1NBCHMajviaUoIWsO5XNQKD3YeGt
wQzEenpyKVfseW1ts5GtYjA/x503o9hZS+LX8obSytREMwuzdHCDA/cTCa/olNhZ
28MjC+56Yj9TsbJEjAlioYr0HYvZaHMIQ2BmgkM7zqBIYFpCkoudhFidhQg+BPG8
X5v9hc27ZOliHuOe04u6XxMI9LjyyV5YslNsp99MsK9GiyxHchC93kKHd6kjE5mR
kAOkW0CUquHQObfdClkQVzuW+o98nSy0OH3E8EnfSQMAIWSax2USmefEBayjOcKq
DK6S5vW8KYNg1Ca/BIIY7evaNKUJbOReTAB2M2UCPrzf6x6ktb+kcNfyP6HwhCLy
zOep1E3ajQGeHp2MIrNv3UBAQ/wAJxw/aEGTNW6uLSBfrDG8eC8/yJl/7OIxjOKA
m1sxKVoK1XSA8sUrmTbYF0oeJph0RNQLaeeqDOv7YPQdmHMToJbDuFph/0EI9kCO
bEpOKfoFq62OhlIIIPzTfpCpTLSVYyE5XsDr0KicoK3n3tX2DLCF2P3u2D5IpSId
ahC2+meSp53IAP6cATI+
=CF+9
-----END PGP SIGNATURE-----

--Signature=_Thu__26_May_2016_15_15_37_-0700_fBbNlIPPGblddV3z--
