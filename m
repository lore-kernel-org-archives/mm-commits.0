From: akpm@linux-foundation.org
Subject: [merged] maintainers-remove-file-pattern-from-kernel-virtual-machine-kvm-for-amd-v.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:57:07 -0800
Message-ID: <200912152157.nBFLv7jp015694@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60247 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761315AbZLOWKv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 17:10:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, avi@redhat.com, joerg.roedel@amd.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: remove file pattern from KERNEL VIRTUAL MACHINE (KVM) FOR AMD-V
has been removed from the -mm tree.  Its filename was
     maintainers-remove-file-pattern-from-kernel-virtual-machine-kvm-for-amd-v.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -3127,7 +3127,6 @@ L:	kvm@vger.kernel.org
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
scripts-checkpatchpl-add-warn-on-sizeof.patch
checkpatchpl-allow-80-char-lines-for-logging-functions-not-just-printk.patch
isicomc-use-pr_fmt-and-pr_level.patch
parport_pcc-use-correct-length-in-strncmp.patch

