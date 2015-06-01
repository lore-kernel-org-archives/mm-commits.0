From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-capabilities-pattern.patch removed
 from -mm tree
Date: Mon, 01 Jun 2015 12:15:54 -0700
Message-ID: <556caf6a.Vze6rjfeSRR2BjvC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47426 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013AbbFATPy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Jun 2015 15:15:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, casey@schaufler-ca.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update CAPABILITIES pattern
has been removed from the -mm tree.  Its filename was
     maintainers-update-capabilities-pattern.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: update CAPABILITIES pattern

commit 1ddd3b4e07a4 ("LSM: Remove unused capability.c") removed the file,
remove the file pattern.

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

diff -puN MAINTAINERS~maintainers-update-capabilities-pattern MAINTAINERS
--- a/MAINTAINERS~maintainers-update-capabilities-pattern
+++ a/MAINTAINERS
@@ -2427,7 +2427,6 @@ L:	linux-security-module@vger.kernel.org
 S:	Supported
 F:	include/linux/capability.h
 F:	include/uapi/linux/capability.h
-F:	security/capability.c
 F:	security/commoncap.c
 F:	kernel/capability.c
 
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
maintainers-update-sound-soc-intel-patterns.patch
maintainers-remove-section-broadcom-bcm33xx-mips-architecture.patch
maintainers-update-brcm-dts-pattern.patch
maintainers-update-brcm-gpio-filename-pattern.patch
maintainers-remove-unused-nbdh-pattern.patch
maintainers-move-jens-osterkamp-to-credits.patch
maintainers-bcache-kent-overstreet-has-changed-email-address.patch
mm-utilc-add-kstrimdup.patch
checkpatch-check-for-uncommented-waitqueue_active.patch
checkpatch-add-strict-warning-for-c99-fixed-size-typedefs-intsize_t.patch
checkpatch-make-types-found-in-a-source-file-patch-local.patch
checkpatch-use-string-consistently.patch
checkpatch-categorize-some-long-line-length-checks.patch
linux-next.patch
printk-improve-the-description-of-dev-kmsg-line-format.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void.patch

