From: akpm@linux-foundation.org
Subject: + maintainers-update-kernel-janitors-after-mismerge.patch added to -mm tree
Date: Thu, 24 Sep 2009 16:43:44 -0700
Message-ID: <200909242343.n8ONhikJ007370@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51542 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752585AbZIXXnm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 19:43:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com


The patch titled
     MAINTAINERS: update Kernel Janitors after mismerge
has been added to the -mm tree.  Its filename is
     maintainers-update-kernel-janitors-after-mismerge.patch

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
Subject: MAINTAINERS: update Kernel Janitors after mismerge
=46rom: Joe Perches <joe@perches.com>

=46ix the mismerge of the W: URL and the S: status fields.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~maintainers-update-kernel-janitors-after-mismerge=
 MAINTAINERS
--- a/MAINTAINERS~maintainers-update-kernel-janitors-after-mismerge
+++ a/MAINTAINERS
@@ -2980,8 +2980,8 @@ F:	scripts/Makefile.*
=20
 KERNEL JANITORS
 L:	kernel-janitors@vger.kernel.org
-W:	http://www.kerneljanitors.org/
-S:	Maintained
+W:	http://janitor.kernelnewbies.org/
+S:	Odd Fixes
=20
 KERNEL NFSD, SUNRPC, AND LOCKD SERVERS
 M:	"J. Bruce Fields" <bfields@fieldses.org>
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
maintainers-update-generic-uio-for-pci-devices.patch
maintainers-update-tracing-section.patch
maintainers-update-omap-tony-lindgren-email-name.patch
maintainers-change-atm-mailing-list-to-moderated.patch
maintainers-use-tab-not-spaces-after-field-types.patch
maintainers-update-kernel-janitors-after-mismerge.patch
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
