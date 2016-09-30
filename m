From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Fri, 30 Sep 2016 15:11:07 -0700
Message-ID: <20160930151107.dab2450c09a574c42ffe89a3@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__30_Sep_2016_15_11_07_-0700_zfxjzVU9q+.q_Jzd"
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43855 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751147AbcI3WLX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 30 Sep 2016 18:11:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org

--Signature=_Fri__30_Sep_2016_15_11_07_-0700_zfxjzVU9q+.q_Jzd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

4 fixes, based on e3b3656ca63e23b5755183718df36fb9ff518b02:

Subject: mm: workingset: fix crash in shadow node shrinker caused by replac=
e_page_cache_page()
Subject: ocfs2: fix deadlock on mmapped page in ocfs2_write_begin_nolock()
Subject: include/linux/property.h: fix typo/compile error
Subject: MAINTAINERS: Javi has moved




--Signature=_Fri__30_Sep_2016_15_11_07_-0700_zfxjzVU9q+.q_Jzd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJX7uMJAAoJEJxZ78cCqAIHryAP/34defacAtqte7aFZgS+QLNO
k2EAV9O52y5r2RQKQzxKnKzjclVRIXaF5kTmh6jKEmB09n2zpjMksl6KRxi+cWyI
OKbXaY9LsE4n7B0WBo/nHJ5vDyAenh8KNt3iuJA675UVsCKC2ffFAHlh0SwKvuzQ
b+IG4uaPeFwBh/rnh3zmBI/2wX4Q7QdsIzHvzLvgzH0h9ZCb4z2RWdynjAEeexmm
m5rfawNVc3XLdM5DQm/UV4CNY+6IDHj2UpdXYUXAnvYgsyMTUcOPvvtkG1P6JuKn
tFOOeawtMIUoJpLqbTNIRO0X5PyDxIxfeGcM4ey0QslsFKvQykGegNsgV65pGIY2
/5GBbj7NFO03ArnUtJcV1wc7UQd6VPpNNHLlRVhkdjhml+sfunn0LDewVn+0n0Tp
MCIYpFEc1qE2HkafQJVWRkUO+avbcVSt0t8Jh5tU16gk7UOzOoeVsKLCO1qyvd6F
cBvT8i4+G8r53lrZlDfjHFD0DCSnmJZm5ONxEjk5atVCBa4b00LA2cyTDpE7TQyq
7hscXvykOs6gnv0R4rJgQmcictp0gq0KoQXy0Hfnm13AF4QcU8Xp0nafNHeUsGno
A2GGH4Tci0/PKAroOJWZd4cOZz6thusVoYlD10DVoj2oPGTxmAbZuNMtn2eLY0lP
znsohuqAevbdAiDH4kSC
=7Rw0
-----END PGP SIGNATURE-----

--Signature=_Fri__30_Sep_2016_15_11_07_-0700_zfxjzVU9q+.q_Jzd--
