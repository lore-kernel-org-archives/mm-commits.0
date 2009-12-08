From: akpm@linux-foundation.org
Subject: + maintainers-remove-file-pattern-from-kernel-virtual-machine-kvm-for-amd-v.patch added to -mm tree
Date: Tue, 08 Dec 2009 15:25:18 -0800
Message-ID: <200912082325.nB8NPIx5004252@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43128 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935906AbZLHXZc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Dec 2009 18:25:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, avi@redhat.com, joerg.roedel@amd.com


The patch titled
     MAINTAINERS: remove file pattern from KERNEL VIRTUAL MACHINE (KVM) FOR AMD-V
has been added to the -mm tree.  Its filename is
     maintainers-remove-file-pattern-from-kernel-virtual-machine-kvm-for-amd-v.patch

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
Subject: MAINTAINERS: remove file pattern from KERNEL VIRTUAL MACHINE (KVM) FOR AMD-V
From: Joe Perches <joe@perches.com>

Commit 6c8166a77c98f473eb91e96a61c3cf78ac617278 ("KVM: SVM: Fold kvm_svm.h
info svm.c") folded this file away.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

diff -puN MAINTAINERS~maintainers-remove-file-pattern-from-kernel-virtual-machine-kvm-for-amd-v MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-file-pattern-from-kernel-virtual-machine-kvm-for-amd-v
+++ a/MAINTAINERS
@@ -3144,7 +3144,6 @@ L:	kvm@vger.kernel.org
 W:	http://kvm.qumranet.com
 S:	Supported
 F:	arch/x86/include/asm/svm.h
-F:	arch/x86/kvm/kvm_svm.h
 F:	arch/x86/kvm/svm.c
 
 KERNEL VIRTUAL MACHINE (KVM) FOR POWERPC
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
dynamic_debugh-kernelh-remove-kbuild_modname-from-dynamic_pr_debug.patch
kernelh-remove-initialization-of-bool-in-printk_once.patch
kernelh-add-printk_ratelimited-and-pr_level_rl.patch
kernelh-add-printk_ratelimited-and-pr_level_rl-checkpatch-fixes.patch
kernelh-add-printk_ratelimited-and-pr_level_rl-rename.patch
scripts-get_maintainerpl-add-roles-and-rolestats.patch
scripts-get_maintainerpl-fix-non-with-git-blame-and-cleanups.patch
scripts-get_maintainerpl-support-multiple-vcss-add-mercurial.patch
maintainers-rename-palm-treo-section-and-file-patterns.patch
maintainers-remove-file-pattern-from-kernel-virtual-machine-kvm-for-amd-v.patch
maintainers-update-file-patterns-for-wolfson-microelectronics-pmic-drivers.patch
lib-vsprintfc-add-%pu-to-print-uuid-guids.patch
fs-xfs-xfs_log_recoverc-use-%pu-to-print-uuids.patch
randomc-use-%pu-to-print-uuids.patch
drivers-firmware-dmi_scanc-use-%pub-to-print-uuids.patch
drivers-md-mdc-use-%pu-to-print-uuids.patch
fs-gfs2-sysc-use-%pub-to-print-uuids.patch
fs-ubifs-use-%pub-to-print-uuids.patch
efih-use-%pul-to-print-uuids.patch
scripts-checkpatchpl-add-warn-on-sizeof.patch
checkpatchpl-allow-80-char-lines-for-logging-functions-not-just-printk.patch
isicomc-use-pr_fmt-and-pr_level.patch
parport_pcc-use-correct-length-in-strncmp.patch

