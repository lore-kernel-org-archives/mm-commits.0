From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Thu, 5 May 2016 16:21:28 -0700
Message-ID: <20160505162128.5957ffaee11f8b71feb6170e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__5_May_2016_16_21_28_-0700_SgK/9BzohfF4Ha=v"
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34572 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbcEEXVl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 May 2016 19:21:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org

--Signature=_Thu__5_May_2016_16_21_28_-0700_SgK/9BzohfF4Ha=v
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

14 fixes, based on c5e0666c5a3ccabdf16bb88451886cdf81849b66:

Subject: mm: thp: correct split_huge_pages file permission
Subject: mm: memcontrol: let v2 cgroups follow changes in system swappiness
Subject: rapidio/mport_cdev: fix uapi type definitions
Subject: huge pagecache: mmap_sem is unlocked when truncation splits pmd
Subject: mm: update min_free_kbytes from khugepaged after core initializati=
on
Subject: mm, cma: prevent nr_isolated_* counters from going negative
Subject: MAINTAINERS: fix Rajendra Nayak's address
Subject: mm: thp: kvm: fix memory corruption in KVM with THP enabled
Subject: mm/zswap: provide unique zpool name
Subject: proc: prevent accessing /proc/<PID>/environ until it's ready
Subject: modpost: fix module autoloading for OF devices with generic compat=
ible property
Subject: mm: fix kcompactd hang during memory offlining
Subject: lib/stackdepot: avoid to return 0 handle
Subject: byteswap: try to avoid __builtin_constant_p gcc bug





--Signature=_Thu__5_May_2016_16_21_28_-0700_SgK/9BzohfF4Ha=v
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJXK9WEAAoJEJxZ78cCqAIH5NYP/irSo28q/01xQ9oEP1NzVKrc
Bn4L8E5gYFeY5nccgtlViQpEX4/VE8VMEL2W8H6Yw9l5XDR/nO7oNlkMF5vT861Y
v7W2P3GhmRq9U7aGVSlQBv4smlyVi0cDb6LQ5ZeZApZtJITyrIWjks1mVpOascE4
mk2tFp2XTnDVxY2qisRJ4Ux/0tl2TawjWGmEu8WG9Nj9KVhdacwJMwo29cMMKPTU
MN1mvG7FRaFu51GG8Xh0oekQ9oM8hN4sUMWaof6zyWZ8L42mjEgOeayPmX2LcBc2
oZZdlMK/1oQJxcJkEJUp+ZGQ2jFLsaq8/dQgUqnK619rRVKi8vTZ5ZuTJsSnxaGT
oAa2Ta2pqYXS0ggl5lgLMiEAwVHhnf8/1MVL/qRjmd6c8q6GZSCp46QTVBpvwyOt
z9F98l3NvMDCMA+BpmidzIH0Ucyr3dVs8+oQSak6+RUuPYMxFeor7j/JOdZctd0I
Ts4gidfhQ03n5ewIsagkpuaT/fPGAmmLFI5HEdN+v/gzKEJWVTi7CnLVrmFCBNYt
05d2/sonL4f/7X+2KU8S0Io1OrL7wC5pjQ3YSENRhNKkjbun0qxxkM4wae94zfRg
HQvj4qb2TkiKE5CsC5fKFs6+QOWrAXgwkcT5vMnjOWK4TqJAWQht+szEi6N6T5gN
GJuWnEPxo7x3qznPMiie
=mvep
-----END PGP SIGNATURE-----

--Signature=_Thu__5_May_2016_16_21_28_-0700_SgK/9BzohfF4Ha=v--
