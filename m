From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-winbond-cir-pattern.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:40:06 -0700
Message-ID: <201103232043.p2NKhgjQ028981@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39567 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933468Ab1CWUoY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:44:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, david@hardeman.nu, mchehab@redhat.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: update WINBOND CIR pattern
has been removed from the -mm tree.  Its filename was
     maintainers-update-winbond-cir-pattern.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: MAINTAINERS: update WINBOND CIR pattern
=46rom: Joe Perches <joe@perches.com>

commit 5b2e303f6df ("[media] rc-core: convert winbond-cir") moved the
files, update the pattern.

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: David H=E4rdeman <david@hardeman.nu>
Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-update-winbond-cir-pattern MAINTAINER=
S
--- a/MAINTAINERS~maintainers-update-winbond-cir-pattern
+++ a/MAINTAINERS
@@ -6819,7 +6819,7 @@ F:	drivers/scsi/wd7000.c
 WINBOND CIR DRIVER
 M:	David H=C3=A4rdeman <david@hardeman.nu>
 S:	Maintained
-F:	drivers/input/misc/winbond-cir.c
+F:	drivers/media/rc/winbond-cir.c
=20
 WIMAX STACK
 M:	Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
