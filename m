From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Mon, 21 Sep 2015 11:23:57 -0700
Message-ID: <56004b3d.bS5V5ltF2k7dJyZ9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49917 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757161AbbIUSX6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Sep 2015 14:23:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/uapi/asm/unistd.h |    4 ----
 arch/s390/kernel/syscalls.S         |    3 ---
 2 files changed, 7 deletions(-)

diff -puN arch/s390/include/uapi/asm/unistd.h~linux-next-git-rejects arch/s390/include/uapi/asm/unistd.h
--- a/arch/s390/include/uapi/asm/unistd.h~linux-next-git-rejects
+++ a/arch/s390/include/uapi/asm/unistd.h
@@ -292,7 +292,6 @@
 #define __NR_execveat		354
 #define __NR_userfaultfd	355
 #define __NR_membarrier		356
-<<<<<<< HEAD
 #define __NR_recvmmsg		357
 #define __NR_sendmmsg		358
 #define __NR_socket		359
@@ -311,9 +310,6 @@
 #define __NR_recvmsg		372
 #define __NR_shutdown		373
 #define NR_syscalls 374
-=======
-#define NR_syscalls 357
->>>>>>> linux-next/akpm-base
 
 /* 
  * There are some system calls that are not present on 64 bit, some
diff -puN arch/s390/kernel/syscalls.S~linux-next-git-rejects arch/s390/kernel/syscalls.S
--- a/arch/s390/kernel/syscalls.S~linux-next-git-rejects
+++ a/arch/s390/kernel/syscalls.S
@@ -365,7 +365,6 @@ SYSCALL(sys_s390_pci_mmio_read,compat_sy
 SYSCALL(sys_execveat,compat_sys_execveat)
 SYSCALL(sys_userfaultfd,sys_userfaultfd)		/* 355 */
 SYSCALL(sys_membarrier,sys_membarrier)
-<<<<<<< HEAD
 SYSCALL(sys_recvmmsg,compat_sys_recvmmsg)
 SYSCALL(sys_sendmmsg,compat_sys_sendmmsg)
 SYSCALL(sys_socket,sys_socket)
@@ -383,5 +382,3 @@ SYSCALL(sys_sendmsg,compat_sys_sendmsg)
 SYSCALL(sys_recvfrom,compat_sys_recvfrom)
 SYSCALL(sys_recvmsg,compat_sys_recvmsg)
 SYSCALL(sys_shutdown,sys_shutdown)
-=======
->>>>>>> linux-next/akpm-base
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
mm-dax-vma-with-vm_ops-pfn_mkwrite-wants-to-be-write-notified-fix.patch
x86-efi-kasan-undef-memset-memcpy-memmove-per-arch-fix.patch
mm.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix-fix.patch
kasan-various-fixes-in-documentation-checkpatch-fixes.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
remove-abs64.patch
include-linux-compiler-gcch-improve-__visible-documentation.patch
linux-next-git-rejects.patch
net-ipv4-routec-prevent-oops.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

