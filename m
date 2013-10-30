From: akpm@linux-foundation.org
Subject: [obsolete] seq_file-remove-%n-usage-from-seq_file-users-fix.patch removed from -mm tree
Date: Wed, 30 Oct 2013 16:07:04 -0700
Message-ID: <52719118.ccU5+48AT8cNSfdx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49860 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab3J3XHG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Oct 2013 19:07:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, penguin-kernel@I-love.SAKURA.ne.jp, akpm@linux-foundation.org

Subject: [obsolete] seq_file-remove-%n-usage-from-seq_file-users-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,penguin-kernel@I-love.SAKURA.ne.jp,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 30 Oct 2013 16:07:04 -0700


The patch titled
     Subject: seq_file-remove-%n-usage-from-seq_file-users-fix
has been removed from the -mm tree.  Its filename was
     seq_file-remove-%n-usage-from-seq_file-users-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: seq_file-remove-%n-usage-from-seq_file-users-fix

fix for linux-next changes

Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/task_mmu.c~seq_file-remove-%n-usage-from-seq_file-users-fix fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~seq_file-remove-%n-usage-from-seq_file-users-fix
+++ a/fs/proc/task_mmu.c
@@ -349,7 +349,7 @@ show_map_vma(struct seq_file *m, struct
 		}
 
 		if (vma_anon_name(vma)) {
-			pad_len_spaces(m, len);
+			seq_pad(m, ' ');
 			seq_print_vma_name(m, vma);
 		}
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
input-route-kbd-leds-through-the-generic-leds-layer-fix-fix.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
posix_acl-uninlining.patch
mm.patch
mm-thp-khugepaged-add-policy-for-finding-target-node-fix.patch
kernel-printk-printkc-convert-to-pr_foo.patch
maintainers-remove-richard-purdie-as-backlight-maintainer-fix.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
checkpatch-add-test-for-defines-of-arch_has_foo.patch
epoll-do-not-take-global-epmutex-for-simple-topologies-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
init-do_mounts_rdc-fix-null-pointer-dereference-while-loading-initramfs-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
kernel-modulec-use-pr_foo.patch
kernel-gcov-fsc-use-pr_warn.patch
linux-next.patch
linux-next-rejects.patch
x86-mem-hotplug-support-initialize-page-tables-in-bottom-up-next-fix.patch
net-netfilter-ipset-ip_set_hash_netnetc-fix-build-with-older-gcc.patch
net-netfilter-ipset-ip_set_hash_netportnetc-fix-build-with-older-gccs.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock-checkpatch-fixes.patch
x86-mm-enable-split-page-table-lock-for-pmd-level-checkpatch-fixes.patch
mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page-fix-fix.patch
tree-wide-use-reinit_completion-instead-of-init_completion-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

