From: akpm@linux-foundation.org
Subject: + maintainers-add-quotation-marks-around-names-with-commas.patch
 added to -mm tree
Date: Tue, 16 Jun 2015 15:05:45 -0700
Message-ID: <55809db9.Im7fKls1xucX5+51%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37574 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925AbbFPWFq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 16 Jun 2015 18:05:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: Add quotation marks around names with commas
has been added to the -mm tree.  Its filename is
     maintainers-add-quotation-marks-around-names-with-commas.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-add-quotation-marks-around-names-with-commas.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-add-quotation-marks-around-names-with-commas.patch

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
Subject: MAINTAINERS: Add quotation marks around names with commas

This makes it easier to copy/paste names with periods to email clients.

All the other names with commas already have quotation marks.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN MAINTAINERS~maintainers-add-quotation-marks-around-names-with-commas MAINTAINERS
--- a/MAINTAINERS~maintainers-add-quotation-marks-around-names-with-commas
+++ a/MAINTAINERS
@@ -2457,7 +2457,7 @@ F:	arch/powerpc/oprofile/*cell*
 F:	arch/powerpc/platforms/cell/
 
 CEPH DISTRIBUTED FILE SYSTEM CLIENT
-M:	Yan, Zheng <zyan@redhat.com>
+M:	"Yan, Zheng" <zyan@redhat.com>
 M:	Sage Weil <sage@redhat.com>
 L:	ceph-devel@vger.kernel.org
 W:	http://ceph.com/
@@ -9013,7 +9013,7 @@ F:	arch/arm/mach-davinci/
 F:	drivers/i2c/busses/i2c-davinci.c
 
 TI DAVINCI SERIES MEDIA DRIVER
-M:	Lad, Prabhakar <prabhakar.csengg@gmail.com>
+M:	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
 L:	linux-media@vger.kernel.org
 W:	http://linuxtv.org/
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
@@ -9023,7 +9023,7 @@ F:	drivers/media/platform/davinci/
 F:	include/media/davinci/
 
 TI AM437X VPFE DRIVER
-M:	Lad, Prabhakar <prabhakar.csengg@gmail.com>
+M:	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
 L:	linux-media@vger.kernel.org
 W:	http://linuxtv.org/
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
@@ -9032,7 +9032,7 @@ S:	Maintained
 F:	drivers/media/platform/am437x/
 
 OV2659 OMNIVISION SENSOR DRIVER
-M:	Lad, Prabhakar <prabhakar.csengg@gmail.com>
+M:	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
 L:	linux-media@vger.kernel.org
 W:	http://linuxtv.org/
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
_

Patches currently in -mm which might be from joe@perches.com are

ocfs2-reduce-object-size-of-mlog-uses.patch
ocfs2-reduce-object-size-of-mlog-uses-fix.patch
ocfs2-remove-__mlog_cpu_guess.patch
ocfs2-remove-__mlog_cpu_guess-fix.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
compiler-gcch-neatening.patch
compiler-gcc-integrate-the-various-compiler-gcch-files.patch
get_maintainerpl-add-get_maintainerignore-file-capability.patch
maintainers-alsa-devel-alsa-projectorg-is-moderated-for-non-subscribers.patch
maintainers-add-quotation-marks-around-names-with-periods.patch
maintainers-add-quotation-marks-around-names-with-commas.patch
lib-string-introduce-strreplace.patch
mm-utilc-add-kstrimdup.patch
checkpatch-check-for-uncommented-waitqueue_active.patch
checkpatch-add-strict-warning-for-c99-fixed-size-typedefs-intsize_t.patch
checkpatch-make-types-found-in-a-source-file-patch-local.patch
checkpatch-use-string-consistently.patch
checkpatch-categorize-some-long-line-length-checks.patch
checkpatch-improve-output-with-multiple-command-line-files.patch
checkpatch-colorize-output-to-terminal.patch
checkpatch-add-showfile-to-allow-input-via-pipe-to-show-filenames.patch
checkpatch-remove-local-from-codespell-path.patch
checkpatch-avoid-not_unified_diff-errors-on-cover-letterpatch-files.patch
checkpatch-suggest-using-ether_addr_equal.patch
checkpatch-fix-processing-of-memset-issues.patch
checkpatch-suggest-using-eth_zero_addr-and-eth_broadcast_addr.patch
checkpatch-add-multi-line-handling-for-prefer_ether_addr_copy.patch
checkpatch-validate-module_license-content.patch
checkpatch-emit-an-error-when-theres-a-diff-in-a-changelog.patch
linux-next.patch
printk-improve-the-description-of-dev-kmsg-line-format.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void.patch
maintainers-update-sound-soc-intel-patterns.patch
maintainers-update-brcm-dts-pattern.patch
maintainers-update-brcm-gpio-filename-pattern.patch
maintainers-remove-unused-nbdh-pattern.patch
maintainers-move-jens-osterkamp-to-credits.patch
maintainers-bcache-kent-overstreet-has-changed-email-address.patch

