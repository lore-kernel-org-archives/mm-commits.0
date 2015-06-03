From: akpm@linux-foundation.org
Subject: [merged]
 maintainers-remove-section-broadcom-bcm33xx-mips-architecture.patch removed from -mm tree
Date: Wed, 03 Jun 2015 15:26:27 -0700
Message-ID: <556f7f13.jEvCe+ybu0jMCfMk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41795 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbbFCW02 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jun 2015 18:26:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, cernekee@gmail.com, f.fainelli@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: remove section BROADCOM BCM33XX MIPS ARCHITECTURE
has been removed from the -mm tree.  Its filename was
     maintainers-remove-section-broadcom-bcm33xx-mips-architecture.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: remove section BROADCOM BCM33XX MIPS ARCHITECTURE

commit 5f2d44591fb3 ("MIPS: bcm3384: Rename "bcm3384" target to "bmips"")
renamed the files and integrated them into an existing section.

Remove the section.

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Kevin Cernekee <cernekee@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    8 --------
 1 file changed, 8 deletions(-)

diff -puN MAINTAINERS~maintainers-remove-section-broadcom-bcm33xx-mips-architecture MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-section-broadcom-bcm33xx-mips-architecture
+++ a/MAINTAINERS
@@ -2153,14 +2153,6 @@ T:	git git://git.kernel.org/pub/scm/linu
 S:	Maintained
 N:	bcm2835
 
-BROADCOM BCM33XX MIPS ARCHITECTURE
-M:	Kevin Cernekee <cernekee@gmail.com>
-L:	linux-mips@linux-mips.org
-S:	Maintained
-F:	arch/mips/bcm3384/*
-F:	arch/mips/include/asm/mach-bcm3384/*
-F:	arch/mips/kernel/*bmips*
-
 BROADCOM BCM5301X ARM ARCHITECTURE
 M:	Hauke Mehrtens <hauke@hauke-m.de>
 L:	linux-arm-kernel@lists.infradead.org
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-fix-global_initialisers-test.patch
ocfs2-reduce-object-size-of-mlog-uses.patch
ocfs2-reduce-object-size-of-mlog-uses-fix.patch
ocfs2-remove-__mlog_cpu_guess.patch
ocfs2-remove-__mlog_cpu_guess-fix.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
compiler-gcch-neatening.patch
compiler-gcc-integrate-the-various-compiler-gcch-files.patch
get_maintainerpl-add-get_maintainerignore-file-capability.patch
mm-utilc-add-kstrimdup.patch
checkpatch-check-for-uncommented-waitqueue_active.patch
checkpatch-add-strict-warning-for-c99-fixed-size-typedefs-intsize_t.patch
checkpatch-make-types-found-in-a-source-file-patch-local.patch
checkpatch-use-string-consistently.patch
checkpatch-categorize-some-long-line-length-checks.patch
linux-next.patch
printk-improve-the-description-of-dev-kmsg-line-format.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void.patch
maintainers-update-sound-soc-intel-patterns.patch
maintainers-update-brcm-dts-pattern.patch
maintainers-update-brcm-gpio-filename-pattern.patch
maintainers-remove-unused-nbdh-pattern.patch
maintainers-move-jens-osterkamp-to-credits.patch
maintainers-bcache-kent-overstreet-has-changed-email-address.patch

