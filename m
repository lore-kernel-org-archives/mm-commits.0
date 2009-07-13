From: akpm@linux-foundation.org
Subject: + maintainers-remove-l-linux-kernel-vgerkernelorg.patch added to -mm tree
Date: Mon, 13 Jul 2009 14:57:09 -0700
Message-ID: <200907132157.n6DLv9Er018725@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57071 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757503AbZGMV5m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 13 Jul 2009 17:57:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com


The patch titled
     MAINTAINERS: Remove L: linux-kernel@vger.kernel.org
has been added to the -mm tree.  Its filename is
     maintainers-remove-l-linux-kernel-vgerkernelorg.patch

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
Subject: MAINTAINERS: Remove L: linux-kernel@vger.kernel.org
=46rom: Joe Perches <joe@perches.com>

from sections that should not have them.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    5 -----
 1 file changed, 5 deletions(-)

diff -puN MAINTAINERS~maintainers-remove-l-linux-kernel-vgerkernelorg M=
AINTAINERS
--- a/MAINTAINERS~maintainers-remove-l-linux-kernel-vgerkernelorg
+++ a/MAINTAINERS
@@ -2201,7 +2201,6 @@ F:	drivers/scsi/lpfc/
 ENE CB710 FLASH CARD READER DRIVER
 P:	Micha=C5=82 Miros=C5=82aw
 M:	mirq-linux@rere.qmqm.pl
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	drivers/misc/cb710/
 F:	drivers/mmc/host/cb710-mmc.*
@@ -3486,13 +3485,11 @@ P:	Vegard Nossum
 M:	vegardno@ifi.uio.no
 P	Pekka Enberg
 M:	penberg@cs.helsinki.fi
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
=20
 KMEMLEAK
 P:	Catalin Marinas
 M:	catalin.marinas@arm.com
-L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	Documentation/kmemleak.txt
 F:	include/linux/kmemleak.h
@@ -4311,7 +4308,6 @@ F:	drivers/video/omap/
 OMAP MMC SUPPORT
 P:	Jarkko Lavinen
 M:	jarkko.lavinen@nokia.com
-L:	linux-kernel@vger.kernel.org
 L:	linux-omap@vger.kernel.org
 S:	Maintained
 F:	drivers/mmc/host/*omap*
@@ -4593,7 +4589,6 @@ P:	Paul Mackerras
 M:	paulus@samba.org
 P:	Ingo Molnar
 M:	mingo@elte.hu
-L:	linux-kernel@vger.kernel.org
 S:	Supported
=20
 PERSONALITY HANDLING
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
mmc-msm_sdccc-driver-for-htc-dream.patch
msm_sdccc-convert-printkkern_level-to-pr_level.patch
msm_sdccc-stylistic-cleaning.patch
msm_sdccc-move-overly-indented-code-to-separate-function.patch
maintainers-ia64-pair-p-m-entries-properly.patch
maintainers-remove-ivtv-user-lists-add-cx18-url.patch
maintainers-qlge-10gb-ethernet-pair-p-m-entries-properly.patch
maintainers-use-tabs-in-acer-aspire-one.patch
maintainers-remove-l-linux-kernel-vgerkernelorg.patch
maintainers-move-arpd-to-credits.patch
maintainers-update-kernel-janitors.patch
maintainers-add-pps-patterns.patch
maintainers-usb-serial-digi-acceleport-use-separate-p-for-al-borchers.p=
atch
maintainers-input-add-dmitrys-name-to-his-email-address.patch
maintainers-remove-cs461x-sound-card-section.patch
maintainers-qlogic-qla2xxx-add-andrew-vasquez-email-address.patch
maintainers-qlogic-qla3xxx-add-ron-mercer-email-address.patch
maintainers-scott-murray-is-no-longer-with-somanetworks.patch
scripts-get_maintainerpl-add-f-directory-use.patch
get_maintainerpl-add-git-min-percent-option.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
