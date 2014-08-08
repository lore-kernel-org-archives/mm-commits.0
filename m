From: akpm@linux-foundation.org
Subject: [folded-merged]
 mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v4-fix-fix.patch
 removed from -mm tree
Date: Fri, 08 Aug 2014 13:58:19 -0700
Message-ID: <53e539eb.iREBpDn68hCgbYNb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f201.google.com ([209.85.214.201]:56131 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933185AbaHHU6U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Aug 2014 16:58:20 -0400
Received: by mail-ob0-f201.google.com with SMTP id nu7so1099009obb.4
        for <mm-commits@vger.kernel.org>; Fri, 08 Aug 2014 13:58:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, fengguang.wu@intel.com, vkuznets@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v4-fix-fix
has been removed from the -mm tree.  Its filename was
     mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v4-fix-fix.patch

This patch was dropped because it was folded into mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v4-fix-fix

clean up layout

Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/proc/vmcore.c~mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v4-fix-fix fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v4-fix-fix
+++ a/fs/proc/vmcore.c
@@ -340,9 +340,9 @@ static inline char *alloc_elfnotes_buf(s
  *
  * Returns zero on success, -EAGAIN on failure.
  */
-static int remap_oldmem_pfn_checked(struct vm_area_struct *vma, unsigned long from,
-			     unsigned long pfn, unsigned long size,
-			     pgprot_t prot)
+static int remap_oldmem_pfn_checked(struct vm_area_struct *vma,
+				    unsigned long from, unsigned long pfn,
+				    unsigned long size, pgprot_t prot)
 {
 	size_t map_size;
 	unsigned long pos_start, pos_end, pos;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
rtc-add-pcf85063-support.patch
proc-remove-proc_tty_ldisc-variable.patch
mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors.patch
panic-add-taint_softlockup-fix.patch
kexec-implementation-of-new-syscall-kexec_file_load-checkpatch-fixes.patch
kexec-support-kexec-kdump-on-efi-systems-fix.patch

