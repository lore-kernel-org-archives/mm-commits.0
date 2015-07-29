From: akpm@linux-foundation.org
Subject: +
 maintainers-credits-mark-maxraid-as-orphan-move-anil-ravindranath-to-credits.patch added to -mm tree
Date: Wed, 29 Jul 2015 13:08:28 -0700
Message-ID: <55b932bc.gFBfhGi24ZxbLEdZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36212 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbbG2UI3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 Jul 2015 16:08:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, James.Bottomley@HansenPartnership.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS/CREDITS: mark MaxRAID as Orphan, move Anil Ravindranath to CREDITS
has been added to the -mm tree.  Its filename is
     maintainers-credits-mark-maxraid-as-orphan-move-anil-ravindranath-to-credits.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-credits-mark-maxraid-as-orphan-move-anil-ravindranath-to-credits.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-credits-mark-maxraid-as-orphan-move-anil-ravindranath-to-credits.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS/CREDITS: mark MaxRAID as Orphan, move Anil Ravindranath to CREDITS

Anil's email address bounces and he hasn't had a signoff
in over 5 years.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 CREDITS     |    4 ++++
 MAINTAINERS |    3 +--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff -puN CREDITS~maintainers-credits-mark-maxraid-as-orphan-move-anil-ravindranath-to-credits CREDITS
--- a/CREDITS~maintainers-credits-mark-maxraid-as-orphan-move-anil-ravindranath-to-credits
+++ a/CREDITS
@@ -2988,6 +2988,10 @@ S: 2200 Mission College Blvd
 S: Santa Clara, CA 95052
 S: USA
 
+N: Anil Ravindranath
+E: anil_ravindranath@pmc-sierra.com
+D: PMC-Sierra MaxRAID driver
+
 N: Eric S. Raymond
 E: esr@thyrsus.com
 W: http://www.tuxedo.org/~esr/
diff -puN MAINTAINERS~maintainers-credits-mark-maxraid-as-orphan-move-anil-ravindranath-to-credits MAINTAINERS
--- a/MAINTAINERS~maintainers-credits-mark-maxraid-as-orphan-move-anil-ravindranath-to-credits
+++ a/MAINTAINERS
@@ -8038,10 +8038,9 @@ F:	drivers/hwmon/pmbus/
 F:	include/linux/i2c/pmbus.h
 
 PMC SIERRA MaxRAID DRIVER
-M:	Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
 L:	linux-scsi@vger.kernel.org
 W:	http://www.pmc-sierra.com/
-S:	Supported
+S:	Orphan
 F:	drivers/scsi/pmcraid.*
 
 PMC SIERRA PM8001 DRIVER
_

Patches currently in -mm which might be from joe@perches.com are

lindent-handle-missing-indent-gracefully.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
mm-slab_common-allow-null-cache-pointer-in-kmem_cache_destroy.patch
mm-mempool-allow-null-pool-pointer-in-mempool_destroy.patch
mm-dmapool-allow-null-pool-pointer-in-dma_pool_destroy.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix-fix.patch
maintainers-credits-mark-maxraid-as-orphan-move-anil-ravindranath-to-credits.patch
parse_integer-add-checkpatchpl-notice.patch
mm-utilc-add-kstrimdup.patch
checkpatch-warn-on-bare-sha-1-commit-ids-in-commit-logs.patch
checkpatch-add-warning-on-bug-bug_on-use.patch
checkpatch-improve-suspect_code_indent-test.patch
checkpatch-allow-longer-declaration-macros.patch
checkpatch-add-some-foo_destroy-functions-to-needless_if-tests.patch
checkpatch-report-the-right-line-when-using-emacs-and-file.patch
checkpatch-always-check-block-comment-styles.patch
hfs-fix-b-tree-corruption-after-insertion-at-position-0.patch
seq_file-provide-an-analogue-of-print_hex_dump.patch
crypto-qat-use-seq_hex_dump-to-dump-buffers.patch
parisc-use-seq_hex_dump-to-dump-buffers.patch
zcrypt-use-seq_hex_dump-to-dump-buffers.patch
kmemleak-use-seq_hex_dump-to-dump-buffers.patch
wil6210-use-seq_hex_dump-to-dump-buffers.patch
linux-next.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix.patch

