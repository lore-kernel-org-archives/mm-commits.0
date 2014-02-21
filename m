From: akpm@linux-foundation.org
Subject: + fs-kernel-permit-disabling-the-uselib-syscall-v2.patch added to -mm tree
Date: Fri, 21 Feb 2014 13:06:04 -0800
Message-ID: <5307bfbc.xHW1AbGr2bAVdonK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58382 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456AbaBUVGF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Feb 2014 16:06:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, josh@joshtriplett.org

Subject: + fs-kernel-permit-disabling-the-uselib-syscall-v2.patch added to -mm tree
To: josh@joshtriplett.org
From: akpm@linux-foundation.org
Date: Fri, 21 Feb 2014 13:06:04 -0800


The patch titled
     Subject: fs-kernel-permit-disabling-the-uselib-syscall-v2
has been added to the -mm tree.  Its filename is
     fs-kernel-permit-disabling-the-uselib-syscall-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-kernel-permit-disabling-the-uselib-syscall-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-kernel-permit-disabling-the-uselib-syscall-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Josh Triplett <josh@joshtriplett.org>
Subject: fs-kernel-permit-disabling-the-uselib-syscall-v2

v2: Add "default y", unintentionally omitted from the first patch.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN init/Kconfig~fs-kernel-permit-disabling-the-uselib-syscall-v2 init/Kconfig
--- a/init/Kconfig~fs-kernel-permit-disabling-the-uselib-syscall-v2
+++ a/init/Kconfig
@@ -275,6 +275,7 @@ config FHANDLE
 
 config USELIB
 	bool "uselib syscall"
+	default y
 	help
 	  This option enables the uselib syscall, a system call used in the
 	  dynamic linker from libc5 and earlier.  glibc does not use this
_

Patches currently in -mm which might be from josh@joshtriplett.org are

mm-compactionc-mark-function-as-static.patch
mm-memoryc-mark-functions-as-static.patch
mm-mmapc-mark-function-as-static.patch
mm-process_vm_accessc-mark-function-as-static.patch
mm-page_cgroupc-mark-functions-as-static.patch
mm-nobootmemc-mark-function-as-static.patch
include-linux-mmh-remove-ifdef-condition.patch
include-linux-syscallsh-add-sys32_quotactl-prototype.patch
fs-kernel-permit-disabling-the-uselib-syscall.patch
fs-kernel-permit-disabling-the-uselib-syscall-v2.patch
fs-reiserfs-move-prototype-declaration-to-header-file.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch
linux-next.patch

