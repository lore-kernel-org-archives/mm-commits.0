From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Wed, 28 Sep 2016 15:22:16 -0700
Message-ID: <20160928152216.e70b3f54873fc42b133f494b@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__28_Sep_2016_15_22_16_-0700_qAEqSfQXsXbHtCQq"
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45168 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933541AbcI1WWX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 28 Sep 2016 18:22:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org

--Signature=_Wed__28_Sep_2016_15_22_16_-0700_qAEqSfQXsXbHtCQq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

5 fixes, based on 8ab293e3a1376574e11f9059c09cc0db212546cb:

Subject: mm,ksm: fix endless looping in allocating memory when ksm enable
Subject: dma-mapping.h: preserve unmap info for CONFIG_DMA_API_DEBUG
Subject: scripts/recordmcount.c: account for .softirqentry.text
Subject: mem-hotplug: use nodes that contain memory as mask in new_node_pag=
e()
Subject: MAINTAINERS: Mark has moved


--Signature=_Wed__28_Sep_2016_15_22_16_-0700_qAEqSfQXsXbHtCQq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJX7EKeAAoJEJxZ78cCqAIHHQoP/2NlkL4AbwzwDblKbg6ntPpA
yDZhnJU+203jMG8uguj2Nb/PcyLFPYdfJXTy5nM+L6rdVDP9py7upe6KgG1o2CJc
SEgilrIVOj3H3zFshgElRr5hgg09tMnPawmV7GTNS1sWqj8wijbl0LEs5FnHuQWI
oeppAk7TnnPZRfNT9xmGmQd/vJF6VdMes0hB683y1Ts8RK7XYz9u7xbXbfUa21/h
7vrmnwpC89iyyiuC4W/R6RaNhraq9qn+5ynzHsrjDl4N6RxxtnKUl+Blcu7X9MVh
vgvIK6Xbob3qu6dj/UmVI6Ds+1qhh5odBVk6csV35tL7cMc1/xLReWcrWpc6zYHB
MDOyTEso+94SDmsBYQm9/8pb64oSPGa5+aSt20emqimTnnczIuwCF6cLoZarwKF2
0BJ5HwFF3n9NwxZ07lCZrlKZ7xUPQpuNczJPsqSyMBLaq0t0iH+Fxu8UsVJYupfW
o/7+feFrE4apqoWkBquGYEjAl3wpbghlArmybXgiVyMmzjm9GvLLfw1RDMMvWAeh
tRWfKbyF4B66gDHNXvkrAL8BjadHEdkbwu74+2fK/sxzMZBlj7gQko9MneAM9kPE
l22x8k6fFhhgjw5wf4CklPL7p6M3Do0Xzj50wczVubN3Al6rwlEfKixc1c7APl3i
3/G8Ht4X8LXr0pfh77w8
=XKp4
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Sep_2016_15_22_16_-0700_qAEqSfQXsXbHtCQq--
