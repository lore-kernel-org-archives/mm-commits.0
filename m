From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Thu, 12 May 2016 15:41:50 -0700
Message-ID: <20160512154150.9f1f6fb171163f02a9b4a74b@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__12_May_2016_15_41_50_-0700_wQDdu.NREz6+5aDf"
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39304 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637AbcELWmG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 May 2016 18:42:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org

--Signature=_Thu__12_May_2016_15_41_50_-0700_wQDdu.NREz6+5aDf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

4 fixes, based on 422ce5a97570cb8a37d016b6bc2021ae4dac5499:

Subject: ocfs2: revert using ocfs2_acl_chmod to avoid inode cluster lock ha=
ng
Subject: ocfs2: fix posix_acl_create deadlock
Subject: ksm: fix conflict between mmput and scan_get_next_rmap_item
Subject: mm: thp: calculate the mapcount correctly for THP pages during WP =
faults


--Signature=_Thu__12_May_2016_15_41_50_-0700_wQDdu.NREz6+5aDf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJXNQa8AAoJEJxZ78cCqAIHDpkP/ilfVHo3WROvYhOS/+TnoEfd
cQ2BYI97ds5FPbOyJcLNvaZ8AJ8Pfx1lhzmgaONO2HG0aIH6Rc3sLuVvDiIXAXnj
xykuDjgvj2qU/rYytB7nAy/T8UavNsQLLOxJcPIpPRPtfcXW8tXUlxmeFhPP0bLN
vqIBrnxeXBnTz288LYo/B43yEqtf+DQomcnjO9loVXmVKaglOIqWUVi0s0p5472v
QBu2DXvNG6xEOPoz8zD0D+L8jbq9jUeZNG0u8kGQPgY3eNw5iVILgvNC5yG5VIy+
IKghEsRrXloAZFNo5PIAvFx+/ztS1K3WZJ5v2YDxPFGr9dEmJUbtNUJ/0LcCJ8rE
yCTsO6kX0Sgkx4ozCRHtrBch12SJvzFAshRsxwvfbJO9gZHan9KFzo0+J3zsgziu
+BeFSAUrLz+0brspKwkEhLK+uOArAk9ndHKzXWBojnXz9MKegYBCHwLDIb7oHYgA
oI+d9ZV5NJFTR0JmR2Aq3/cnamoQ4DXVkgByDFLLKeUXcEgHtIaFga/7aunf5SLw
K2Qg91JUjEhmODbjVzRsLxywGtVpqmHd9xFTBGtxdf4l5Xx5/zU1EcNLY/z/9BJ+
SFzyrcuXRNDBkH1TgVMXJ8tASo54nxapColuDU1R9376u9Xq3SlSDoUHJ/ksh7oZ
nerAUxtwf/4bhGwG+iTw
=X1GL
-----END PGP SIGNATURE-----

--Signature=_Thu__12_May_2016_15_41_50_-0700_wQDdu.NREz6+5aDf--
