From: akpm@linux-foundation.org
Subject: [merged] scripts-gdb-fix-typo-in-exception-name.patch removed
 from -mm tree
Date: Mon, 06 Jul 2015 12:47:08 -0700
Message-ID: <559adb3c.fTnaSCsmGodJV6Ci%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59549 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755633AbbGFTrI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jul 2015 15:47:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: thiebaud@weksteen.fr, jan.kiszka@siemens.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: fix typo in exception name
has been removed from the -mm tree.  Its filename was
     scripts-gdb-fix-typo-in-exception-name.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
=46rom: Thi=E9baud Weksteen <thiebaud@weksteen.fr>
Subject: scripts/gdb: fix typo in exception name

Signed-off-by: Thi=E9baud Weksteen <thiebaud@weksteen.fr>
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/utils.py |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/gdb/linux/utils.py~scripts-gdb-fix-typo-in-exception-=
name scripts/gdb/linux/utils.py
--- a/scripts/gdb/linux/utils.py~scripts-gdb-fix-typo-in-exception-name
+++ a/scripts/gdb/linux/utils.py
@@ -83,7 +83,7 @@ def get_target_endianness():
         elif "big endian" in endian:
             target_endianness =3D BIG_ENDIAN
         else:
-            raise gdb.GdgError("unknown endianness '{0}'".format(str(e=
ndian)))
+            raise gdb.GdbError("unknown endianness '{0}'".format(str(e=
ndian)))
     return target_endianness
=20
=20
_

Patches currently in -mm which might be from thiebaud@weksteen.fr are


--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
