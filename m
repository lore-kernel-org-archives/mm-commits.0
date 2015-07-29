From: akpm@linux-foundation.org
Subject: [obsolete]
 mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-fix-2.patch
 removed from -mm tree
Date: Wed, 29 Jul 2015 11:13:35 -0700
Message-ID: <55b917cf.866CAYwiXJdgVgZo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59944 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbbG2SNg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 Jul 2015 14:13:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, emunson@akamai.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-fix-2
has been removed from the -mm tree.  Its filename was
     mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-fix-2.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-fix-2

can we just remove the s390 bits which cause the breakage?
I will wire up the syscalls as soon as the patch set gets merged.

Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Eric B Munson <emunson@akamai.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/syscalls.S |    3 ---
 1 file changed, 3 deletions(-)

diff -puN arch/s390/kernel/syscalls.S~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-fix-2 arch/s390/kernel/syscalls.S
--- a/arch/s390/kernel/syscalls.S~mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-fix-2
+++ a/arch/s390/kernel/syscalls.S
@@ -363,6 +363,3 @@ SYSCALL(sys_bpf,compat_sys_bpf)
 SYSCALL(sys_s390_pci_mmio_write,compat_sys_s390_pci_mmio_write)
 SYSCALL(sys_s390_pci_mmio_read,compat_sys_s390_pci_mmio_read)
 SYSCALL(sys_execveat,compat_sys_execveat)
-SYSCALL(sys_mlock2,compat_sys_mlock2)			/* 355 */
-SYSCALL(sys_munlock2,compat_sys_munlock2)
-SYSCALL(sys_munlockall2,compat_sys_munlockall2)
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

origin.patch
mm-mlock-add-new-mlock-system-call.patch
linux-next.patch

