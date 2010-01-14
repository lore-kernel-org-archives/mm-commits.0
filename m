From: akpm@linux-foundation.org
Subject: + maintainers-remove-hayes-esp-serial-driver.patch added to -mm tree
Date: Thu, 14 Jan 2010 15:14:30 -0800
Message-ID: <201001142314.o0ENEUiQ005191@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40320 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756894Ab0ANXOv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Jan 2010 18:14:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com


The patch titled
     MAINTAINERS: remove HAYES ESP SERIAL DRIVER
has been added to the -mm tree.  Its filename is
     maintainers-remove-hayes-esp-serial-driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: remove HAYES ESP SERIAL DRIVER
From: Joe Perches <joe@perches.com>

Commit f53a2ade0bb9f2a81f473e6469155172a96b7c38 removed it

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    7 -------
 1 file changed, 7 deletions(-)

diff -puN MAINTAINERS~maintainers-remove-hayes-esp-serial-driver MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-hayes-esp-serial-driver
+++ a/MAINTAINERS
@@ -2486,13 +2486,6 @@ L:	linux-parisc@vger.kernel.org
 S:	Maintained
 F:	sound/parisc/harmony.*
 
-HAYES ESP SERIAL DRIVER
-M:	"Andrew J. Robinson" <arobinso@nyx.net>
-W:	http://www.nyx.net/~arobinso
-S:	Maintained
-F:	Documentation/serial/hayes-esp.txt
-F:	drivers/char/esp.c
-
 HEWLETT-PACKARD SMART2 RAID DRIVER
 M:	Chirag Kantharia <chirag.kantharia@hp.com>
 L:	iss_storagedev@hp.com
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
net-rds-remove-uses-of-nipquad-use-%pi4.patch
net-sunrpc-remove-uses-of-nipquad-use-%pi4.patch
fs-ocfs2-cluster-tcpc-remove-use-of-nipquad-use-%pi4.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-remove-uses-of-nipquad-use-%pi4.patch
drivers-firmware-iscsi_ibftc-remove-nipquad_fmt-use-%pi4.patch
drivers-staging-pohmelfs-inodec-remove-uses-of-nipquad-use-%pi4.patch
scripts-get_maintainerpl-add-file-emails-find-embedded-email-addresses.patch
scripts-get_maintainerpl-add-file-emails-find-embedded-email-addresses-v2.patch
scripts-get_maintainerpl-add-sections-print-entire-matched-subsystem.patch
maintainers-remove-amd-geode-f-arch-x86-kernel-geode_32c.patch
maintainers-remove-hayes-esp-serial-driver.patch
maintainers-update-performance-events-f-patterns.patch
maintainers-starmode-radio-ip-strip-moved-to-staging.patch
maintainers-wavelan-moved-to-staging.patch
scripts-checkpatchpl-add-warn-on-sizeof.patch
checkpatchpl-allow-80-char-lines-for-logging-functions-not-just-printk.patch

