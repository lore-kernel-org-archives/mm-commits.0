Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF402C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 25 Oct 2021 19:59:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9717D60C4B
	for <mm-commits@archiver.kernel.org>; Mon, 25 Oct 2021 19:59:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239136AbhJYUBj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Oct 2021 16:01:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:46640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236038AbhJYT7c (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 25 Oct 2021 15:59:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AAB9560E75;
        Mon, 25 Oct 2021 19:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635191829;
        bh=XTIFmcTrXxhdnqukHwIp8jXxYe64HW/ekenMQ7cP/ok=;
        h=Date:From:To:Subject:From;
        b=dj3sh7X7jYqEWQDKLZATHYQod/9Utlp83h3cmQ42k38+7FmAGQ98mRf9zOeAyaHMJ
         a/UNJ+1cHvbAiIyYdMDBBgVA/xWUuEAlmRFIcxzjBBOhdC9ZUkEZ82Un87vCjO9Njv
         sV60z7D7C4Q0WZPxpPZKLktleNCGCNyEOFEISUKw=
Date:   Mon, 25 Oct 2021 12:57:08 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Message-ID: <20211025195708.HkS8_Qd4E%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


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

 drivers/net/ethernet/intel/ice/ice_devids.h                     |    3 ---
 drivers/net/ethernet/intel/ice/ice_devlink.c                    |    5 -----
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c             |    5 -----
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c                 |    5 -----
 kernel/cred.c                                                   |    5 -----
 kernel/ucount.c                                                 |    8 --------
 net/netfilter/ipvs/ip_vs_ctl.c                                  |    3 ---
 tools/testing/selftests/net/forwarding/forwarding.config.sample |    3 ---
 8 files changed, 37 deletions(-)

--- a/drivers/net/ethernet/intel/ice/ice_devids.h~linux-next-git-rejects
+++ a/drivers/net/ethernet/intel/ice/ice_devids.h
@@ -21,11 +21,8 @@
 #define ICE_DEV_ID_E810C_QSFP		0x1592
 /* Intel(R) Ethernet Controller E810-C for SFP */
 #define ICE_DEV_ID_E810C_SFP		0x1593
-<<<<<<< HEAD
-=======
 #define ICE_SUBDEV_ID_E810T		0x000E
 #define ICE_SUBDEV_ID_E810T2		0x000F
->>>>>>> linux-next/akpm-base
 /* Intel(R) Ethernet Controller E810-XXV for backplane */
 #define ICE_DEV_ID_E810_XXV_BACKPLANE	0x1599
 /* Intel(R) Ethernet Controller E810-XXV for QSFP */
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c~linux-next-git-rejects
+++ a/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -62,11 +62,6 @@ static void ice_info_fw_api(struct ice_p
 
 	snprintf(ctx->buf, sizeof(ctx->buf), "%u.%u.%u", hw->api_maj_ver,
 		 hw->api_min_ver, hw->api_patch);
-<<<<<<< HEAD
-
-	return 0;
-=======
->>>>>>> linux-next/akpm-base
 }
 
 static void ice_info_fw_build(struct ice_pf *pf, struct ice_info_ctx *ctx)
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c~linux-next-git-rejects
+++ a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -68,13 +68,8 @@
 #include "lib/fs_chains.h"
 #include "diag/en_tc_tracepoint.h"
 #include <asm/div64.h>
-<<<<<<< HEAD
-#include "lag.h"
-#include "lag_mp.h"
-=======
 #include "lag/lag.h"
 #include "lag/mp.h"
->>>>>>> linux-next/akpm-base
 
 #define nic_chains(priv) ((priv)->fs.tc.chains)
 #define MLX5_MH_ACT_SZ MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto)
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c~linux-next-git-rejects
+++ a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -10,13 +10,8 @@
 #include "en_tc.h"
 #include "rep/tc.h"
 #include "rep/neigh.h"
-<<<<<<< HEAD
-#include "lag.h"
-#include "lag_mp.h"
-=======
 #include "lag/lag.h"
 #include "lag/mp.h"
->>>>>>> linux-next/akpm-base
 
 struct mlx5e_tc_tun_route_attr {
 	struct net_device *out_dev;
--- a/kernel/cred.c~linux-next-git-rejects
+++ a/kernel/cred.c
@@ -683,12 +683,7 @@ int set_cred_ucounts(struct cred *new)
 		return -EAGAIN;
 
 	new->ucounts = new_ucounts;
-<<<<<<< HEAD
-	if (old_ucounts)
-		put_ucounts(old_ucounts);
-=======
 	put_ucounts(old_ucounts);
->>>>>>> linux-next/akpm-base
 
 	return 0;
 }
--- a/kernel/ucount.c~linux-next-git-rejects
+++ a/kernel/ucount.c
@@ -295,11 +295,7 @@ static void do_dec_rlimit_put_ucounts(st
 {
 	struct ucounts *iter, *next;
 	for (iter = ucounts; iter != last; iter = next) {
-<<<<<<< HEAD
-		long dec = atomic_long_add_return(-1, &iter->ucount[type]);
-=======
 		long dec = atomic_long_sub_return(1, &iter->ucount[type]);
->>>>>>> linux-next/akpm-base
 		WARN_ON_ONCE(dec < 0);
 		next = iter->ns->ucounts;
 		if (dec == 0)
@@ -336,11 +332,7 @@ long inc_rlimit_get_ucounts(struct ucoun
 	}
 	return ret;
 dec_unwind:
-<<<<<<< HEAD
-	dec = atomic_long_add_return(-1, &iter->ucount[type]);
-=======
 	dec = atomic_long_sub_return(1, &iter->ucount[type]);
->>>>>>> linux-next/akpm-base
 	WARN_ON_ONCE(dec < 0);
 unwind:
 	do_dec_rlimit_put_ucounts(ucounts, iter, type);
--- a/net/netfilter/ipvs/ip_vs_ctl.c~linux-next-git-rejects
+++ a/net/netfilter/ipvs/ip_vs_ctl.c
@@ -4095,11 +4095,8 @@ static int __net_init ip_vs_control_net_
 	tbl[idx++].data = &ipvs->sysctl_conn_reuse_mode;
 	tbl[idx++].data = &ipvs->sysctl_schedule_icmp;
 	tbl[idx++].data = &ipvs->sysctl_ignore_tunneled;
-<<<<<<< HEAD
-=======
 	ipvs->sysctl_run_estimation = 1;
 	tbl[idx++].data = &ipvs->sysctl_run_estimation;
->>>>>>> linux-next/akpm-base
 #ifdef CONFIG_IP_VS_DEBUG
 	/* Global sysctls must be ro in non-init netns */
 	if (!net_eq(net, &init_net))
--- a/tools/testing/selftests/net/forwarding/forwarding.config.sample~linux-next-git-rejects
+++ a/tools/testing/selftests/net/forwarding/forwarding.config.sample
@@ -41,9 +41,6 @@ NETIF_CREATE=yes
 PING_TIMEOUT=5
 # IPv6 traceroute utility name.
 TROUTE6=traceroute6
-<<<<<<< HEAD
-=======
 # Flag for tc match, supposed to be skip_sw/skip_hw which means do not process
 # filter by software/hardware
 TC_FLAG=skip_hw
->>>>>>> linux-next/akpm-base
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kasan-test-use-underlying-string-helpers-checkpatch-fixes.patch
mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister-fix.patch
mm.patch
mm-page_ownerc-modify-the-type-of-argument-order-in-some-functions-fix.patch
memcg-kmem-further-deprecate-kmemlimit_in_bytes-checkpatch-fixes.patch
mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation-checkpatch-fixes.patch
mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation-fix.patch
mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation-fix-2.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
procfs-do-not-list-tid-0-in-proc-pid-task-fix.patch
ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files-fix.patch
revert-acct_reclaim_writeback-for-next.patch
linux-next-rejects.patch
restore-acct_reclaim_writeback-for-folio.patch
mm-filemap-check-if-thp-has-hwpoisoned-subpage-for-pmd-page-fault-vs-folios.patch
kernel-forkc-export-kernel_thread-to-modules.patch

