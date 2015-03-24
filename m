From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Tue, 24 Mar 2015 12:21:58 -0700
Message-ID: <5511b956.pB6jWkph9h5lXfqg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36086 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146AbbCXTV7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Mar 2015 15:21:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/netfilter/nf_tables_core.c |   37 -------------------------------
 1 file changed, 37 deletions(-)

diff -puN net/netfilter/nf_tables_core.c~linux-next-git-rejects net/netfilter/nf_tables_core.c
--- a/net/netfilter/nf_tables_core.c~linux-next-git-rejects
+++ a/net/netfilter/nf_tables_core.c
@@ -108,43 +108,6 @@ struct nft_jumpstack {
 	int			rulenum;
 };
 
-<<<<<<< HEAD
-enum nft_trace {
-	NFT_TRACE_RULE,
-	NFT_TRACE_RETURN,
-	NFT_TRACE_POLICY,
-};
-
-static const char *const comments[] = {
-	[NFT_TRACE_RULE]	= "rule",
-	[NFT_TRACE_RETURN]	= "return",
-	[NFT_TRACE_POLICY]	= "policy",
-};
-
-static struct nf_loginfo trace_loginfo = {
-	.type = NF_LOG_TYPE_LOG,
-	.u = {
-		.log = {
-			.level = 4,
-			.logflags = NF_LOG_MASK,
-	        },
-	},
-};
-
-static void nft_trace_packet(const struct nft_pktinfo *pkt,
-			     const struct nft_chain *chain,
-			     int rulenum, enum nft_trace type)
-{
-	struct net *net = dev_net(pkt->in ? pkt->in : pkt->out);
-
-	nf_log_trace(net, pkt->xt.family, pkt->ops->hooknum, pkt->skb, pkt->in,
-		     pkt->out, &trace_loginfo, "TRACE: %s:%s:%s:%u ",
-		     chain->table->name, chain->name, comments[type],
-		     rulenum);
-}
-
-=======
->>>>>>> linux-next/akpm-base
 unsigned int
 nft_do_chain(struct nft_pktinfo *pkt, const struct nf_hook_ops *ops)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
drivers-rtc-rtc-mrst-fix-suspend-resume-fix.patch
mm-fix-anon_vma-degree-underflow-in-anon_vma-endless-growing-prevention.patch
mm.patch
mm-cma-release-trigger-checkpatch-fixes.patch
mm-cma-allocation-trigger-fix.patch
mm-compaction-enhance-compaction-finish-condition-fix.patch
page_writeback-cleanup-mess-around-cancel_dirty_page-checkpatch-fixes.patch
mm-hide-per-cpu-lists-in-output-of-show_mem-fix.patch
mm-clarify-__gfp_nofail-deprecation-status-checkpatch-fixes.patch
mm-change-vunmap-to-tear-down-huge-kva-mappings-fix.patch
mm-mempool-do-not-allow-atomic-resizing-checkpatch-fixes.patch
hugetlbfs-add-minimum-size-tracking-fields-to-subpool-structure-fix.patch
hugetlbfs-add-minimum-size-accounting-to-subpools-fix.patch
mm-memory-failurec-define-page-types-for-action_result-in-one-place-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-memcg-sync-allocation-and-memcg-charge-gfp-flags-for-thp-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-support-madvisemadv_free-fix-2.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
zram-add-dynamic-device-add-remove-functionality-fix.patch
zram-introduce-automatic-device_id-generation-fix.patch
zsmalloc-support-compaction-fix.patch
kernel-conditionally-support-non-root-users-groups-and-capabilities-checkpatch-fixes.patch
lib-vsprintf-add-%pcnr-format-specifiers-for-clocks-fix.patch
lib-find__bit-reimplementation-fix.patch
checkpatch-match-more-world-writable-permissions-fix.patch
binfmt_misc-simplify-entry_status-fix.patch
rtc-add-abracon-abx80x-driver-fix.patch
rtc-driver-for-conexant-digicolor-cx92755-on-chip-rtc-fix.patch
fs-fat-remove-unnecessary-includes-fix.patch
affs-kstrdup-memory-handling-fix.patch
kconfig-use-macros-which-are-already-defined-fix.patch
linux-next.patch
linux-next-rejects.patch
lib-kconfig-fix-up-have_arch_bitreverse-help-text.patch
oprofile-reduce-mmap_sem-hold-for-mm-exe_file-fix.patch
tomoyo-reduce-mmap_sem-hold-for-mm-exe_file-checkpatch-fixes.patch
documentation-spi-spidev_testc-fix-warning.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

