From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Wed, 3 Aug 2016 13:45:09 -0700
Message-ID: <20160803134509.c28f5c0ac869d940ff641740@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__3_Aug_2016_13_45_09_-0700_budd15Ni4SSbKfCg"
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39688 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932662AbcHCUpS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 16:45:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org

--Signature=_Wed__3_Aug_2016_13_45_09_-0700_budd15Ni4SSbKfCg
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


- dma-mapping API cleanup

- a few cleanups and misc things

- use jump labels in dynamic-debug

18 patches, based on bf0f500bd0199aab613eb0ecb3412edd5472740d:

Subject: drivers/fpga/Kconfig: fix build failure
Subject: tree-wide: replace config_enabled() with IS_ENABLED()
Subject: include/linux/bitmap.h: cleanup
Subject: media: mtk-vcodec: remove unused dma_attrs
Subject: dma-mapping: use unsigned long for dma_attrs
Subject: samples/kprobe: convert the printk to pr_info/pr_err
Subject: samples/jprobe: convert the printk to pr_info/pr_err
Subject: samples/kretprobe: convert the printk to pr_info/pr_err
Subject: samples/kretprobe: fix the wrong type
Subject: block: remove BLK_DEV_DAX config option
Subject: MAINTAINERS: update email and list of Samsung HW driver maintainers
Subject: drivers/media/dvb-frontends/cxd2841er.c: avoid misleading gcc warn=
ing
Subject: powerpc: add explicit #include <asm/asm-compat.h> for jump label
Subject: sparc: support static_key usage in non-module __exit sections
Subject: tile: support static_key usage in non-module __exit sections
Subject: arm: jump label may reference text in __exit
Subject: jump_label: remove bug.h, atomic.h dependencies for HAVE_JUMP_LABEL
Subject: dynamic_debug: add jump label support




--Signature=_Wed__3_Aug_2016_13_45_09_-0700_budd15Ni4SSbKfCg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJXolfbAAoJEJxZ78cCqAIHJbUQALZurX4LhRIyhaA1XOZ88u7N
A6OtKv1HvhaS6Y3DX0x/UcQar2qhA9NVJmT7Yh24Xl4H097KTK0kPF898BaEWXuP
T0alTztQKDmF9QdxwUJGPOR1E2gOONeJxzod3VjHnzEaGLe+VGQnaoEc1KfQZ8Mp
srCi1s6oFGEELD6ES5UGzHVZm+N3uzJp7l1naNMWcT6Iqfc6Gw6N1ZcmR+aUYQ/W
SBlgWKTKJGMX2dFkLBiUP5Kv78xYXCDxhiBJ5aZTisKjF6BtTPCeGcr24GYr9pqq
K4cLo7mFBwaXyXF4ismXUQC3JhKG+vNCe2nLa+wErWisfED0j99d4TfSCoxmObvu
ToV/6Zhp/hD6yT7q1n1NhAhc17y2eOWRSa5WjzAHhrZSRWZUfAvlIqBZeEOccRm/
v51UJkwpFytQbh8wm84v8L2hh4SKEsMnnj8TvIvLXKah1T/+FZbacxe06NlutX3Q
/suz0GkYmc8QU2gLUEbC8hNDNkPXRSJX6hK7R1JoeDtTvGqkllKl994VnzzR2SOU
HzPAIYiV986k+ZbuwOaFm1SFCkv00XJm8beoF80rDaMR2NufyMsMJ4NHOhtR1cRA
iCBXj4APjC6ZPx7h0CZbwiv/CqBKA63ENrgB6FNPPXC3kaKYdm3/zC0vk127okWC
Bjp6/7i8IS/RUml27FAd
=U7I5
-----END PGP SIGNATURE-----

--Signature=_Wed__3_Aug_2016_13_45_09_-0700_budd15Ni4SSbKfCg--
