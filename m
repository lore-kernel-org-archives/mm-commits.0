From: akpm@linux-foundation.org
Subject: [merged] mailmap-add-rdunlap-email-auto-correction.patch removed
 from -mm tree
Date: Mon, 29 Jun 2015 13:47:07 -0700
Message-ID: <5591aecb.bxPiE7qsqocBHYKF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50767 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122AbbF2UrT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:47:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, joe@perches.com, rdunlap@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: add rdunlap email auto-correction
has been removed from the -mm tree.  Its filename was
     mailmap-add-rdunlap-email-auto-correction.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
=46rom: Kees Cook <keescook@chromium.org>
Subject: mailmap: add rdunlap email auto-correction

To avoid having xenotime bounce when things like get_maintainers gives
me addresses, add Randy's current address.

Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

diff -puN .mailmap~mailmap-add-rdunlap-email-auto-correction .mailmap
--- a/.mailmap~mailmap-add-rdunlap-email-auto-correction
+++ a/.mailmap
@@ -101,6 +101,7 @@ Praveen BP <praveenbp@ti.com>
 Rajesh Shah <rajesh.shah@intel.com>
 Ralf Baechle <ralf@linux-mips.org>
 Ralf Wildenhues <Ralf.Wildenhues@gmx.de>
+Randy Dunlap <rdunlap@infradead.org> <rdunlap@xenotime.net>
 R=C3=A9mi Denis-Courmont <rdenis@simphalempin.com>
 Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
 Rudolf Marek <R.Marek@sh.cvut.cz>
_

Patches currently in -mm which might be from keescook@chromium.org are

origin.patch
lib-vsprintf-add-%pt-format-specifier.patch
linux-next.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
