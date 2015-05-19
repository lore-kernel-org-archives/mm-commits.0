From: akpm@linux-foundation.org
Subject: + maintainers-update-capabilities-pattern.patch added to -mm tree
Date: Tue, 19 May 2015 16:21:57 -0700
Message-ID: <555bc595.sVedl8nGT657yGh6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52412 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbbESXV6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 May 2015 19:21:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, casey@schaufler-ca.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update CAPABILITIES pattern
has been added to the -mm tree.  Its filename is
     maintainers-update-capabilities-pattern.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-update-capabilities-pattern.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-update-capabilities-pattern.patch

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
@@ -2419,7 +2419,6 @@ L:	linux-security-module@vger.kernel.org
 S:	Supported
 F:	include/linux/capability.h
 F:	include/uapi/linux/capability.h
-F:	security/capability.c
 F:	security/commoncap.c
 F:	kernel/capability.c
 
_

Patches currently in -mm which might be from joe@perches.com are

maintainers-update-capabilities-pattern.patch
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
mm-utilc-add-kstrimdup.patch
checkpatch-check-for-uncommented-waitqueue_active.patch
checkpatch-add-strict-warning-for-c99-fixed-size-typedefs-intsize_t.patch
checkpatch-make-types-found-in-a-source-file-patch-local.patch
linux-next.patch
printk-improve-the-description-of-dev-kmsg-line-format.patch

