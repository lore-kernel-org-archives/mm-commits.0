From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Mon, 9 May 2016 16:28:32 -0700
Message-ID: <20160509162832.d195b5946709f583e89a203e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__9_May_2016_16_28_32_-0700_+NG0L.ZntTJGdRH5"
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58100 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbcEIX2j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 May 2016 19:28:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org

--Signature=_Mon__9_May_2016_16_28_32_-0700_+NG0L.ZntTJGdRH5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

3 fixes, based on 44549e8f5eea4e0a41b487b63e616cb089922b99:

Subject: Revert "proc/base: make prompt shell start from new line after exe=
cuting "cat /proc/$pid/wchan""
Subject: zsmalloc: fix zs_can_compact() integer overflow
Subject: compiler-gcc: require gcc 4.8 for powerpc __builtin_bswap16()


--Signature=_Mon__9_May_2016_16_28_32_-0700_+NG0L.ZntTJGdRH5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJXMR0lAAoJEJxZ78cCqAIHcOAP/3RBRU+OfWh3Pka1II9jE/hq
vjMZhCjCg2qEH3SMGof4hbdcG1oLky9R9RzUY/Av4jp51XZKwQdoAMA2tynwbLMt
j9Bzy/bY/nv3AKdvVSyzmhrolo7D9mwg9hZPnsGFcJIHMxu/I3CHQUeyEP80kmHs
BNv/ss3y1RlXPnNAbuvmiAhJykQWik8nD+xH5YowRCRUDMUv/wN4elaZwszy+yBw
S05+TlQY6c6ZpjXmppizyvVIRrSn0MxVQn/VUzafiAU4G10yTSW0XIfQvsOn5qRY
0IApxtJn5QJQganUqgQbpH/7JR1Eedrxy2hNk4Fqz2id/ckq+VkrpD5RGCW+u2gC
Tt6XGVfhUNKD/W0Ptyo7hJCO5b1qNIQi6BB14+32y64I/g5bDCzWplxZR5hscxSk
7hRWR+JG19GXXGR9Wat0gHPnzHUOMxHwGbLTASwrg3PNf564QVZWh9WU1sPHqJcJ
fCyUSfn7tsGNy6FlxTMKum59y1X4eUJHHDh9lq25w1cVw15yp29coBYef7bKcUE9
soYhINY6cSrEoUPs4g/eiRkqSJ2iWqGfiiiWhAjIlyUCJoyXls4FVe9jmrQx+GdU
nnFo5hN4jK538ZJysrWFhNI1R/3pR+RIQY/GaZ+ecdt49pgQ64OvicvQBoAm736P
mAp8UX3+l3i0Q8/l5khN
=ogME
-----END PGP SIGNATURE-----

--Signature=_Mon__9_May_2016_16_28_32_-0700_+NG0L.ZntTJGdRH5--
