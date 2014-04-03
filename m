From: akpm@linux-foundation.org
Subject: [folded-merged]
 fs-kernel-permit-disabling-the-uselib-syscall-v2.patch removed from -mm
 tree
Date: Thu, 03 Apr 2014 14:10:18 -0700
Message-ID: <533dce3a.Zc/P+WNbUbGdA296%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60829 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686AbaDCVKT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Apr 2014 17:10:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, josh@joshtriplett.org

Subject: [folded-merged] fs-kernel-permit-disabling-the-uselib-syscall-v2.patch removed from -mm tree
To: josh@joshtriplett.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 03 Apr 2014 14:10:18 -0700


The patch titled
     Subject: fs-kernel-permit-disabling-the-uselib-syscall-v2
has been removed from the -mm tree.  Its filename was
     fs-kernel-permit-disabling-the-uselib-syscall-v2.patch

This patch was dropped because it was folded into fs-kernel-permit-disabling-the-uselib-syscall.patch

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

origin.patch
mm-compactionc-mark-function-as-static.patch
mm-memoryc-mark-functions-as-static.patch
mm-mmapc-mark-function-as-static.patch
mm-process_vm_accessc-mark-function-as-static.patch
mm-page_cgroupc-mark-functions-as-static.patch
mm-nobootmemc-mark-function-as-static.patch
include-linux-mmh-remove-ifdef-condition.patch
include-linux-syscallsh-add-sys32_quotactl-prototype.patch
fs-kernel-permit-disabling-the-uselib-syscall.patch
submittingpatches-add-style-recommendation-to-use-imperative-descriptions.patch
submittingpatches-add-recommendation-for-mailing-list-references.patch
submittingpatches-document-the-use-of-git.patch
lib-clz_ctzc-add-prototype-declarations-in-lib-clz_ctzc.patch
lib-decompress_inflatec-include-appropriate-header-file.patch
checkpatch-make-return-is-not-a-function-test-quieter.patch
fs-reiserfs-move-prototype-declaration-to-header-file.patch

