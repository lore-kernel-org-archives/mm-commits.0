From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-tracing-section.patch removed from -mm tree
Date: Fri, 30 Oct 2009 13:48:58 -0700
Message-ID: <200910302048.n9UKmwv2007084@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46997 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757492AbZJ3Ute (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Oct 2009 16:49:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mingo@elte.hu, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: update TRACING section
has been removed from the -mm tree.  Its filename was
     maintainers-update-tracing-section.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: update TRACING section
From: Joe Perches <joe@perches.com>

Move to alphabetic position
Use single line F: entries

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN MAINTAINERS~maintainers-update-tracing-section MAINTAINERS
--- a/MAINTAINERS~maintainers-update-tracing-section
+++ a/MAINTAINERS
@@ -2202,18 +2202,6 @@ F:	Documentation/filesystems/caching/
 F:	fs/fscache/
 F:	include/linux/fscache*.h
 
-TRACING
-M:	Steven Rostedt <rostedt@goodmis.org>
-M:	Frederic Weisbecker <fweisbec@gmail.com>
-M:	Ingo Molnar <mingo@redhat.com>
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing/core
-S:	Maintained
-F:	Documentation/trace/ftrace.txt
-F:	arch/*/*/*/ftrace.h
-F:	arch/*/kernel/ftrace.c
-F:	include/*/ftrace.h include/trace/ include/linux/trace*.h
-F:	kernel/trace/
-
 FUJITSU FR-V (FRV) PORT
 M:	David Howells <dhowells@redhat.com>
 S:	Maintained
@@ -5176,6 +5164,20 @@ L:	tpmdd-devel@lists.sourceforge.net (mo
 S:	Maintained
 F:	drivers/char/tpm/
 
+TRACING
+M:	Steven Rostedt <rostedt@goodmis.org>
+M:	Frederic Weisbecker <fweisbec@gmail.com>
+M:	Ingo Molnar <mingo@redhat.com>
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing/core
+S:	Maintained
+F:	Documentation/trace/ftrace.txt
+F:	arch/*/*/*/ftrace.h
+F:	arch/*/kernel/ftrace.c
+F:	include/*/ftrace.h
+F:	include/linux/trace*.h
+F:	include/trace/
+F:	kernel/trace/
+
 TRIVIAL PATCHES
 M:	Jiri Kosina <trivial@kernel.org>
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial.git
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
maintainers-asus-acpi-extras-remove-f-arch-x86-kernel-acpi-bootc.patch
maintainers-brocade-bfa-use-single-line-m-and-tabs.patch
maintainers-server-engines-10gbps-iscsi-use-single-line-m.patch
maintainers-vmware-vmxnet3-quote-name-with-comma-and-period-use-tabs.patch
get_maintainer-fix-usage-comment.patch
linux-next.patch
dynamic_debugh-kernelh-remove-kbuild_modname-from-dynamic_pr_debug.patch
kernelh-remove-initialization-of-bool-in-printk_once.patch
scripts-get_maintainerpl-add-roles-and-rolestats.patch
scripts-get_maintainerpl-fix-non-with-git-blame-and-cleanups.patch
lib-vsprintfc-add-%pu-to-print-uuid-guids.patch
fs-xfs-xfs_log_recoverc-use-%pu-to-print-uuids.patch
randomc-use-%pu-to-print-uuids.patch
drivers-firmware-dmi_scanc-use-%pub-to-print-uuids.patch
drivers-md-mdc-use-%pu-to-print-uuids.patch
fs-gfs2-sysc-use-%pub-to-print-uuids.patch
fs-ubifs-use-%pub-to-print-uuids.patch
efih-use-%pul-to-print-uuids.patch
drivers-media-video-uvc-use-%pul-to-print-uuids.patch
lib-unified-uuid-guid-definition.patch
gfs2-use-unified-uuid-guid-code.patch
scripts-checkpatchpl-add-warn-on-sizeof.patch
checkpatchpl-allow-80-char-lines-for-logging-functions-not-just-printk.patch
isicomc-use-pr_fmt-and-pr_level.patch

