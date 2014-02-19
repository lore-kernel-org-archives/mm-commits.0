From: akpm@linux-foundation.org
Subject: + mmnuma-reorganize-change_pmd_range-fix.patch added to -mm tree
Date: Wed, 19 Feb 2014 11:27:47 -0800
Message-ID: <530505b3.p/j90++BNihTJlzK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60825 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755182AbaBST1t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Feb 2014 14:27:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, riel@redhat.com, akpm@linux-foundation.org

Subject: + mmnuma-reorganize-change_pmd_range-fix.patch added to -mm tree
To: akpm@linux-foundation.org,riel@redhat.com,rientjes@google.com
From: akpm@linux-foundation.org
Date: Wed, 19 Feb 2014 11:27:47 -0800


The patch titled
     Subject: mmnuma-reorganize-change_pmd_range-fix
has been added to the -mm tree.  Its filename is
     mmnuma-reorganize-change_pmd_range-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmnuma-reorganize-change_pmd_range-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmnuma-reorganize-change_pmd_range-fix.patch

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
Subject: mmnuma-reorganize-change_pmd_range-fix

fix indenting, per David

Cc: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mprotect.c~mmnuma-reorganize-change_pmd_range-fix mm/mprotect.c
--- a/mm/mprotect.c~mmnuma-reorganize-change_pmd_range-fix
+++ a/mm/mprotect.c
@@ -119,7 +119,7 @@ static inline unsigned long change_pmd_r
 
 		next = pmd_addr_end(addr, end);
 		if (!pmd_trans_huge(*pmd) && pmd_none_or_clear_bad(pmd))
-				continue;
+			continue;
 		if (pmd_trans_huge(*pmd)) {
 			if (next - addr != HPAGE_PMD_SIZE)
 				split_huge_page_pmd(vma, addr, pmd);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
jffs2-avoid-soft-lockup-in-jffs2_reserve_space_gc.patch
mm.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
mm-vmstat-fix-up-zone-state-accounting-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
drop_caches-add-some-documentation-and-info-message.patch
mmnuma-reorganize-change_pmd_range-fix.patch
include-linux-syscallsh-add-sys32_quotactl-prototype-fix.patch
sys_sysfs-add-config_sysfs_syscall-fix.patch
kernel-groupsc-remove-return-value-of-set_groups-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
hfsplus-fix-concurrent-acess-of-alloc_blocks-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch
kernel-panicc-display-reason-at-end-pr_emerg-fix.patch
initramfs-debug-detected-compression-method-fix.patch
linux-next.patch
linux-next-rejects.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

