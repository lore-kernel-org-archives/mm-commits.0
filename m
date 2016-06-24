From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Fri, 24 Jun 2016 14:48:20 -0700
Message-ID: <20160624144820.7a7fe1ef11456cc9fd832f4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__24_Jun_2016_14_48_20_-0700_HRvDPg2C_e19q=gS"
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40847 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbcFXVs1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jun 2016 17:48:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org

--Signature=_Fri__24_Jun_2016_14_48_20_-0700_HRvDPg2C_e19q=gS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Two weeks worth of fixes here.

41 fixes, based on 63c04ee7d3b7c8d8e2726cb7c5f8a5f6fcc1e3b2:

Subject: mm,oom_reaper: don't call mmput_async() without atomic_inc_not_zer=
o()
Subject: oom_reaper: avoid pointless atomic_inc_not_zero usage.
Subject: selftests/vm/compaction_test: fix write to restore nr_hugepages
Subject: tmpfs: don't undo fallocate past its last page
Subject: tree wide: get rid of __GFP_REPEAT for order-0 allocations part I
Subject: x86: get rid of superfluous __GFP_REPEAT
Subject: x86/efi: get rid of superfluous __GFP_REPEAT
Subject: arm64: get rid of superfluous __GFP_REPEAT
Subject: arc: get rid of superfluous __GFP_REPEAT
Subject: mips: get rid of superfluous __GFP_REPEAT
Subject: nios2: get rid of superfluous __GFP_REPEAT
Subject: parisc: get rid of superfluous __GFP_REPEAT
Subject: score: get rid of superfluous __GFP_REPEAT
Subject: powerpc: get rid of superfluous __GFP_REPEAT
Subject: sparc: get rid of superfluous __GFP_REPEAT
Subject: s390: get rid of superfluous __GFP_REPEAT
Subject: sh: get rid of superfluous __GFP_REPEAT
Subject: tile: get rid of superfluous __GFP_REPEAT
Subject: unicore32: get rid of superfluous __GFP_REPEAT
Subject: jbd2: get rid of superfluous __GFP_REPEAT
Subject: MAINTAINERS: update Calgary IOMMU
Subject: mm: mempool: kasan: don't poot mempool objects in quarantine
Subject: mm, sl[au]b: add __GFP_ATOMIC to the GFP reclaim mask
Subject: mailmap: add Antoine Tenart's email
Subject: mailmap: add Boris Brezillon's email
Subject: Revert "mm: make faultaround produce old ptes"
Subject: Revert "mm: disable fault around on emulated access bit architectu=
re"
Subject: hugetlb: fix nr_pmds accounting with shared page tables
Subject: memcg: mem_cgroup_migrate() may be called with irq disabled
Subject: memcg: css_alloc should return an ERR_PTR value on error
Subject: mm/swap.c: flush lru pvecs on compound page arrival
Subject: mm/hugetlb: clear compound_mapcount when freeing gigantic pages
Subject: mm: prevent KASAN false positives in kmemleak
Subject: mm, compaction: abort free scanner if split fails
Subject: ocfs2: disable BUG assertions in reading blocks
Subject: oom, suspend: fix oom_reaper vs. oom_killer_disable race
Subject: fs/nilfs2: fix potential underflow in call to crc32_le
Subject: tools/vm/slabinfo: fix spelling mistake: "Ocurrences" -> "Occurren=
ces"
Subject: mm/page_owner: avoid null pointer dereference
Subject: autofs: don't get stuck in a loop if vfs_write() returns an error
Subject: init/main.c: fix initcall_blacklisted on ia64, ppc64 and parisc64





--Signature=_Fri__24_Jun_2016_14_48_20_-0700_HRvDPg2C_e19q=gS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJXbaqqAAoJEJxZ78cCqAIHdLkP/RgV6gEg1az+WRU1tmGsCYJr
kcrM2RBtvBWDmRrFOJqFNGlUfK0+bkhCmgL96QfiroQThyNRAFyh6yFj8sq6vi9b
2eo9artSYPqsjQsdIGKLesdRnh6SdEf88o1i49ZeoPLWXxA/l1Xl7BC3R6f8r41f
i3ZX/ZPxe9xJP85jdpgLvDOnibUavbt2uo2WHRggDPvYvtRiRJNR9iBVerXr+5IZ
uGvSk0mmu7A9+8/9T7/gmTvtvAHDzXSO6FkRv9upnGqi3p3KVLC2ybjvLNlIHmAr
6DLTspgzr0c3meLFSaCRXErgRbCX+v/7fQJ+3w3dqH4z+3ZyBjdjHwm7HEYWpCgq
nmYXlYOGoAxYuZJS+6AmYfWcfcSeDw+VE1H0F98KOZbV3o1bwKqTo8X7ryrjUr0Y
obhYH2oviAqzMSD3lFu5MS6giDsNJOsXNNaI4JeDunfnMKQnO1cVTGmzj8U/cugn
uUDjE/7DWjpxFXsiw1XLTTe7As2rUETGcqCG4mlOM1kwqpRgl+12wcWN6CUerdby
60xfp27j3J9RfvURHIQKSxtMmUwFairxjDrKVibH+TuPzEp6fcbgDIzi0Grc52Fh
YHy115W4BHjaBfRPeSu7FZ0iPF71j9yvcM3ssHEXjT5Z6DQr6uLkoy60z1C7N/V1
osE6GtI0JfWKql5g9ZXZ
=YOsC
-----END PGP SIGNATURE-----

--Signature=_Fri__24_Jun_2016_14_48_20_-0700_HRvDPg2C_e19q=gS--
