From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Thu, 11 Aug 2016 15:32:42 -0700
Message-ID: <20160811153242.7fd4c5c7147c5e99345b5aca@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__11_Aug_2016_15_32_42_-0700_iT1Svftrr6rqb+P_"
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53799 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbcHKWcs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Aug 2016 18:32:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org

--Signature=_Thu__11_Aug_2016_15_32_42_-0700_iT1Svftrr6rqb+P_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

7 fixes, based on 85e97be32c6242c98dbbc7a241b4a78c1b93327b:

Subject: mm/hugetlb: fix incorrect hugepages count during mem hotplug
Subject: proc, meminfo: use correct helpers for calculating LRU sizes in me=
minfo
Subject: mm: memcontrol: fix swap counter leak on swapout from offline cgro=
up
Subject: mm: memcontrol: fix memcg id ref counter on swap charge move
Subject: kasan: remove the unnecessary WARN_ONCE from quarantine.c
Subject: mm, oom: fix uninitialized ret in task_will_free_mem()
Subject: mm/memory_hotplug.c: initialize per_cpu_nodestats for hotadded pgd=
ats

--Signature=_Thu__11_Aug_2016_15_32_42_-0700_iT1Svftrr6rqb+P_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJXrP0PAAoJEJxZ78cCqAIH+V4P/3aBtSlzXji/LEpRLfTqUTji
FSWSQspAvrJbD6TlkIfLNWRmCQ5HymkoBMmNZaP1FTd8aN/eb5FN7h5SHC7hu9tt
iCLblvVHP+Vf4KUG1dbd4O5pgrrxpi+DQmmvjpV6NY5T0Z9By4Ev+uZDwN550HDh
vyWDTs0TJW5U6/xkdlh+stiQ5je2E6Fn/8E62bslgtaKQWfqjWD/RVTCdn2Wzer+
mgrRzjisJCeUBPCjI6e0iKPOb9SrubNSK+rDat7eltz0Yv27KWGDFOUkogUcy5fp
Itju79XV2pXHuIlCSRhk3oW4zX61MRccYjG0+MhZTBeWLbG12/pII3iNGdmnDcS0
rXhCED9Sax+14MaN6XEW+oVUalFmhBSpQESC36yH6G0WIIKITe/DGvFn+KiffQ7z
yx7xkswno9LdOGQyPYqFe6NZkQvdmvKI3J6yc1bTjjODjQNvbdkwZS+CPKRAq17N
m4WOCXAHfDDiURLzYRCZ+/9QlKSYFUN1Ih85CrtOaaVa72njWwAXqao3slhjiO7A
9uyLkD+3FEQnqtk+knFhp0I60B6fmTzLgRQerH0XiWVibtvfybWGZMzg4t0DNDau
qF1vtE1Nxey3FsunbT2abs4+9Z2LRJ+VmctrT5p3t/EEWo+pzkL0Dib6N0AfoLW9
8RZwMmW8saOlIr7T6lO8
=T3kY
-----END PGP SIGNATURE-----

--Signature=_Thu__11_Aug_2016_15_32_42_-0700_iT1Svftrr6rqb+P_--
