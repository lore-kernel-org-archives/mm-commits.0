From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Thu, 25 Aug 2016 15:16:30 -0700
Message-ID: <20160825151630.adc0e3bfa39b5679178cbd42@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__25_Aug_2016_15_16_30_-0700_Iy9NPL_qT/VwO3sm"
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58997 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757415AbcHYWQh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 Aug 2016 18:16:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org

--Signature=_Thu__25_Aug_2016_15_16_30_-0700_Iy9NPL_qT/VwO3sm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

12 fixes, based on 61c04572de404e52a655a36752e696bbcb483cf5:

Subject: byteswap: don't use __builtin_bswap*() with sparse
Subject: get_maintainer: quiet noisy implicit -f vcs_file_exists checking
Subject: sysctl: handle error writing UINT_MAX to u32 fields
Subject: stackdepot: fix mempolicy use-after-free
Subject: soft_dirty: fix soft_dirty during THP split
Subject: printk: fix parsing of "brl=3D" option
Subject: treewide: replace config_enabled() with IS_ENABLED() (2nd round)
Subject: mm: clarify COMPACTION Kconfig text
Subject: mm: memcontrol: avoid unused function warning
Subject: fs/seq_file: fix out-of-bounds read
Subject: dax: fix device-dax region base
Subject: mm: silently skip readahead for DAX inodes




--Signature=_Thu__25_Aug_2016_15_16_30_-0700_Iy9NPL_qT/VwO3sm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJXv25EAAoJEJxZ78cCqAIHeLAP/3c4UmyE52pdBZEO/yYXiWoK
125PBEfNNN9VfEnlJ6S29QdSx7jrlHx6907NVTEF/LwJAlEQVSPcEpTd9W4Pm0tV
7HKFmIV/hVveV1GRc1sq58z3rznlAx46Z4CJQhpUykBJK6LB4/X4tmAqG+yZAKQY
dhv5GL5gXLvSk++QoMnDdMa9tZvL7LR3rq5YGfksw0egGIfBK7pzUJJJjB1Zbr8a
9HQYPXoiXfm47VIoINFVuXQkdDBTgtay1UOePR9Na9zlihsZHkVQ83W/Q5WIo4bY
CecuNKAj0Svnj68f805FJv2IVNRmdnPQttHPjRPm+bYMI60chuq1rqYDlN52M4ZQ
DRA2lBTWADWIcSc3HNh+cLCif5TqQnXaBK84IMevH3kteCu0Bn4IwQGIaIc+YkV7
hUeWRWnlYbigsW1Nphxo6iuV1nosb84pZ/OHb9GFWdHA4b3Jx1QyiWzH3AnjSvdr
YnwIPqkFQCmNeTSpLT7q33NKIrtCtZH+Gh+v7sPQVqOB0EJFMTDoKRP9MBQ9B5I9
bgWV29K+Q7xO22IqqHeBRuciQP3mGL537XqTAOpTVMaDliLP7akkF3TF3SWlGt83
Ej0riJC3Ql+5FPZTQ9WloRuiBGljuc0r8U8zi3M2EwncyNKtP+bD0O+bziUKdbwo
sRDzP8cm1l9Su+gPq/aX
=SxJr
-----END PGP SIGNATURE-----

--Signature=_Thu__25_Aug_2016_15_16_30_-0700_Iy9NPL_qT/VwO3sm--
