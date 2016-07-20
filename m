From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Wed, 20 Jul 2016 15:44:42 -0700
Message-ID: <20160720154442.92137c88969c86df96fb4b71@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__20_Jul_2016_15_44_42_-0700_BPg6lYBrA8cqMmE."
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53281 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932141AbcGTWot (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jul 2016 18:44:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org

--Signature=_Wed__20_Jul_2016_15_44_42_-0700_BPg6lYBrA8cqMmE.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

5 fixes, based on 47ef4ad2684d380dd6d596140fb79395115c3950:

Subject: mm: memcontrol: fix cgroup creation failure after many small jobs
Subject: radix-tree: fix radix_tree_iter_retry() for tagged iterators.
Subject: testing/radix-tree: fix a macro expansion bug
Subject: tools/vm/slabinfo: fix an unintentional printf
Subject: pps: do not crash when failed to register


--Signature=_Wed__20_Jul_2016_15_44_42_-0700_BPg6lYBrA8cqMmE.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJXj/7gAAoJEJxZ78cCqAIHR/wP/ig2+oeoHNC+TGENpr2DcBxU
wJ5f9pPFEOuv5dR8nioddJHctMyuwAkN7bVVfX0MtjPr7q5dH8uNWTdeCL7o71wA
LH5FpZGnvYAsRg8MIjnQAjDG3FYSWTMVo17hZYLM/d8UXv6OrMn5/k90MJGTzbEF
h36zZRBGzXW2a2M3l0XO/hbdktEM784Rsquhhs1ooIt/CKxTuF3NHoo3GL9wKJd+
sBTqtK9GGEDnTn2Ju06rpToYY+bEYPxq1eMhKp7uh9czEwfatLeOWoh90H7EGLii
a0R/p/vVbop/ejWbOLgWky41Ta4EtiRlLeVgSG2SzuxyZWUlFe4iHR9lcwgW4ZEL
MVUekouymQ7sCnbadjUWDT5EOulS0x8jw4dT2D7GHRgREn63+Qb7aAarFEiLTzky
fLrj0qvEW7JBzp7IQCL6Hi9wJmYfJvcC5h+UG1Lx0avPdwrPARKYzxNn862FyAFa
w/yjZsq+lHuMZuv29E509fDhOgMIibhe4CL41FeEGRwTxjd2NwQCeac8pJg4BseS
bEiQOn5AcCncMRx0JtOvWWmwQURhZEMFXdf7CQi4k37eirVshW99v+ieplV5yWMS
huWfIMgiNbCPCv4s8ZYttXonutthaww5Kp2DX1IceZivL/fbKIQyVNtUX2UuD+5k
1kWdQW8YMuc9rwWK+fmd
=fHXy
-----END PGP SIGNATURE-----

--Signature=_Wed__20_Jul_2016_15_44_42_-0700_BPg6lYBrA8cqMmE.--
