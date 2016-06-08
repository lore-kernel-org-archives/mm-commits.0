From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Wed, 8 Jun 2016 15:33:28 -0700
Message-ID: <20160608153328.a31cc7f2619aecc184beb9fc@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__8_Jun_2016_15_33_28_-0700_Fu_35Geqy3rKo9Gx"
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37678 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161279AbcFHWdh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Jun 2016 18:33:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org

--Signature=_Wed__8_Jun_2016_15_33_28_-0700_Fu_35Geqy3rKo9Gx
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

7 fixes, based on c8ae067f2635be0f8c7e5db1bb74b757d623e05b:

Subject: mm/hugetlb: fix huge page reserve accounting for private mappings
Subject: kasan: change memory hot-add error messages to info messages
Subject: revert "mm: memcontrol: fix possible css ref leak on oom"
Subject: mm: thp: broken page count after commit aa88b68c
Subject: kernel/relay.c: fix potential memory leak
Subject: mm: introduce dedicated WQ_MEM_RECLAIM workqueue to do lru_add_dra=
in_all
Subject: mm/fadvise.c: do not discard partial pages with POSIX_FADV_DONTNEED


--Signature=_Wed__8_Jun_2016_15_33_28_-0700_Fu_35Geqy3rKo9Gx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJXWJ0+AAoJEJxZ78cCqAIHIL8QAIdH4tosfdM3hNVvJiIxi6ah
EeHazidXDagAws3VhwkxuIhmXW2tNR4k/Z0YhUxToGMqw8HQYhnvscU/3zRj5hhy
BPb4XsTW7YNTNCyGCi1Zji8pc7BYklsbb/VRxaR/Eq9QkEejG7xyIqUImw/LtB4b
+KOWGoYt05KXt4B3U8U2IlJ7MU/v6x7FK34Rq4kqfIMkYfwE1CIAwvUWLJ4PM/Jm
zGwiHbt1FvxPLF0GMXbW8OXhyeQvZikVwqrG5aZwu6a3jPX5B+r0xFeCGRIjOQTA
0gBTT4UZp27F/TqKWg1XSfYAaBIgigfh5HUSH50x+VBOyHWlaZEz14YWzY2bR+p6
Y0fSMsQoylQZvPg07tWWN+p+IeHcsgb8CK8lY8fVAsMPt9pHwUFXLOrtF9LQjaJS
abhP8YQUZa3eVNNdIwetYFUxjpuPlYKubiWD0+JQBwBOHHhxgg6cJOSy+ADvT3x+
VKjgvItOQBTqRGPc0K7a73BTh01Rs0SaHAIvBPLtqCYUE0AnInhYhH7BgA0DvaSE
CPHp1w+G2Pi5USzpYzAdkgFS6jlWPDvBTQJHLvNKIRjuBsw49sjmBRjAdBmOR43U
FJY2x2H8LcSGthhCztuloYWUQEvWsoXrjJ02O64lWsrFfDxXS1xPtju8eA3S84/K
y5d091T7F4jvm67nX3t0
=Bdvt
-----END PGP SIGNATURE-----

--Signature=_Wed__8_Jun_2016_15_33_28_-0700_Fu_35Geqy3rKo9Gx--
