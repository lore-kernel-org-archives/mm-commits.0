From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Date: Mon, 02 Mar 2020 10:59:42 -0800
Message-ID: <20200302185942.Tk5wRJhEr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726451AbgCBS7o (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 2 Mar 2020 13:59:44 -0500
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

 net/mptcp/protocol.c   |    3 ---
 net/smc/smc_core.h     |    4 ----
 net/wireless/nl80211.c |    3 ---
 3 files changed, 10 deletions(-)

--- a/net/mptcp/protocol.c~linux-next-git-rejects
+++ a/net/mptcp/protocol.c
@@ -671,8 +671,6 @@ static unsigned int mptcp_sync_mss(struc
 	return 0;
 }
 
-<<<<<<< HEAD
-=======
 static void mptcp_worker(struct work_struct *work)
 {
 	struct mptcp_sock *msk = container_of(work, struct mptcp_sock, work);
@@ -684,7 +682,6 @@ static void mptcp_worker(struct work_str
 	sock_put(sk);
 }
 
->>>>>>> linux-next/akpm-base
 static int __mptcp_init_sock(struct sock *sk)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
--- a/net/smc/smc_core.h~linux-next-git-rejects
+++ a/net/smc/smc_core.h
@@ -291,11 +291,7 @@ struct smc_clc_msg_local;
 
 void smc_lgr_forget(struct smc_link_group *lgr);
 void smc_lgr_cleanup_early(struct smc_connection *conn);
-<<<<<<< HEAD
-void smc_lgr_terminate(struct smc_link_group *lgr, bool soft);
-=======
 void smc_lgr_terminate_sched(struct smc_link_group *lgr);
->>>>>>> linux-next/akpm-base
 void smc_port_terminate(struct smc_ib_device *smcibdev, u8 ibport);
 void smc_smcd_terminate(struct smcd_dev *dev, u64 peer_gid,
 			unsigned short vlan);
--- a/net/wireless/nl80211.c~linux-next-git-rejects
+++ a/net/wireless/nl80211.c
@@ -4988,8 +4988,6 @@ static int nl80211_start_ap(struct sk_bu
 					info->attrs[NL80211_ATTR_HE_OBSS_PD],
 					&params.he_obss_pd);
 		goto out;
-<<<<<<< HEAD
-=======
 	}
 
 	if (info->attrs[NL80211_ATTR_HE_BSS_COLOR]) {
@@ -4998,7 +4996,6 @@ static int nl80211_start_ap(struct sk_bu
 					&params.he_bss_color);
 		if (err)
 			return err;
->>>>>>> linux-next/akpm-base
 	}
 
 	nl80211_calculate_ap_params(&params);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-numa-fix-bad-pmd-by-atomically-check-for-pmd_trans_huge-when-marking-page-tables-prot_numa-fix.patch
mm.patch
selftest-add-mremap_dontunmap-selftest-fix.patch
selftest-add-mremap_dontunmap-selftest-v7-checkpatch-fixes.patch
hugetlb_cgroup-add-reservation-accounting-for-private-mappings-fix.patch
hugetlb_cgroup-add-accounting-for-shared-mappings-fix.patch
mm-migratec-migrate-pg_readahead-flag-fix.patch
proc-faster-open-read-close-with-permanent-files-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-fix.patch
mm-add-vm_insert_pages-fix.patch
net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy-fix.patch
drivers-tty-serial-sh-scic-suppress-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
