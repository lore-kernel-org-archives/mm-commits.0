From: akpm@linux-foundation.org
Subject: + maintainers-update-score-architecture-name-style-and-add-file-pattern.patch added to -mm tree
Date: Thu, 24 Sep 2009 14:42:50 -0700
Message-ID: <200909242142.n8OLgoem026807@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40426 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750901AbZIXVxU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 17:53:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, lennox.wu@gmail.com, liqin.chen@sunplusct.com


The patch titled
     MAINTAINERS: update SCORE architecture name style and add file pat=
tern
has been added to the -mm tree.  Its filename is
     maintainers-update-score-architecture-name-style-and-add-file-patt=
ern.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: MAINTAINERS: update SCORE architecture name style and add file=
 pattern
=46rom: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN MAINTAINERS~maintainers-update-score-architecture-name-style-=
and-add-file-pattern MAINTAINERS
--- a/MAINTAINERS~maintainers-update-score-architecture-name-style-and-=
add-file-pattern
+++ a/MAINTAINERS
@@ -4495,12 +4495,11 @@ F:	kernel/sched*
 F:	include/linux/sched.h
=20
 SCORE ARCHITECTURE
-P:	Chen Liqin
-M:	liqin.chen@sunplusct.com
-P:	Lennox Wu
-M:	lennox.wu@gmail.com
+M:	Chen Liqin <liqin.chen@sunplusct.com>
+M:	Lennox Wu <lennox.wu@gmail.com>
 W:	http://www.sunplusct.com
 S:	Supported
+F:	arch/score/
=20
 SCSI CDROM DRIVER
 M:	Jens Axboe <axboe@kernel.dk>
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
maintainers-update-generic-uio-for-pci-devices.patch
maintainers-update-tracing-section.patch
maintainers-update-omap-tony-lindgren-email-name.patch
maintainers-change-atm-mailing-list-to-moderated.patch
maintainers-use-tab-not-spaces-after-field-types.patch
maintainers-janitors-status-set-to-odd-fixes.patch
maintainers-update-score-architecture-name-style-and-add-file-pattern.p=
atch
maintainers-simple-firmware-interface-update-email-style.patch
maintainers-winbond-cir-integrate-p-m-lines-fixup-david-h=E4rdemans-nam=
e.patch
maintainers-fix-up-peripheral-spelling.patch
maintainers-update-wolfson-microelectronics.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
