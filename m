From: akpm@linux-foundation.org
Subject: + scripts-gdb-fix-typo-in-exception-name.patch added to -mm tree
Date: Fri, 22 May 2015 12:32:38 -0700
Message-ID: <555f8456.w4MsCIHiE9hrHmR+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47054 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756676AbbEVTcj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 May 2015 15:32:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: thiebaud@weksteen.fr, jan.kiszka@siemens.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: fix typo in exception name
has been added to the -mm tree.  Its filename is
     scripts-gdb-fix-typo-in-exception-name.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-gdb-fix-typo-in-ex=
ception-name.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-gdb-fix-typo-in-ex=
ception-name.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

scripts-gdb-add-command-to-check-list-consistency.patch
scripts-gdb-also-allow-list_head-pointer-as-lx-list-check-paramter.patc=
h
scripts-gdb-enable-completion-for-lx-list-check-parameter.patch
scripts-gdb-fix-typo-in-exception-name.patch
scripts-gdb-fix-pep8-compliance.patch
scripts-gdb-add-ps-command.patch
scripts-gdb-remove-useless-global-instruction.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
