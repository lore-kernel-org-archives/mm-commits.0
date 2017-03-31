From: akpm@linux-foundation.org
Subject: + treewide-correct-diffrent-and-banlance-typos.patch added to -mm tree
Date: Fri, 31 Mar 2017 15:03:41 -0700
Message-ID: <58ded23d.Z3o5VBQO58vrrwB/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40358 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751282AbdCaWDm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 31 Mar 2017 18:03:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mchehab@s-opensource.com, mm-commits@vger.kernel.org


The patch titled
     Subject: treewide: spelling: correct diffrent[iate] and banlance typos
has been added to the -mm tree.  Its filename is
     treewide-correct-diffrent-and-banlance-typos.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/treewide-correct-diffrent-and-banlance-typos.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/treewide-correct-diffrent-and-banlance-typos.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: treewide: spelling: correct diffrent[iate] and banlance typos

Add these misspellings to scripts/spelling.txt too

Link: http://lkml.kernel.org/r/962aace119675e5fe87be2a88ddac1a5486f8e60.1490931810.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.h |    2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c      |    2 +-
 drivers/net/ethernet/hisilicon/hns/hns_enet.c       |    2 +-
 drivers/net/ethernet/qlogic/qed/qed_int.c           |    2 +-
 drivers/net/ethernet/qlogic/qed/qed_main.c          |    2 +-
 drivers/net/ethernet/qlogic/qed/qed_sriov.c         |    2 +-
 include/linux/mlx4/device.h                         |    2 +-
 scripts/spelling.txt                                |    3 +++
 8 files changed, 10 insertions(+), 7 deletions(-)

diff -puN drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.h~treewide-correct-diffrent-and-banlance-typos drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.h
--- a/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.h~treewide-correct-diffrent-and-banlance-typos
+++ a/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.h
@@ -70,7 +70,7 @@
 * (3) both long and short but short preferred and long only when necesarry
 *
 * These modes must be selected compile time via compile switches.
-* Compile switch settings for the diffrent modes:
+* Compile switch settings for the different modes:
 * (1) DRXDAPFASI_LONG_ADDR_ALLOWED=0, DRXDAPFASI_SHORT_ADDR_ALLOWED=1
 * (2) DRXDAPFASI_LONG_ADDR_ALLOWED=1, DRXDAPFASI_SHORT_ADDR_ALLOWED=0
 * (3) DRXDAPFASI_LONG_ADDR_ALLOWED=1, DRXDAPFASI_SHORT_ADDR_ALLOWED=1
diff -puN drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c~treewide-correct-diffrent-and-banlance-typos drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c~treewide-correct-diffrent-and-banlance-typos
+++ a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
@@ -1591,7 +1591,7 @@ static int __bnx2x_vlan_mac_execute_step
 	if (rc != 0) {
 		__bnx2x_vlan_mac_h_pend(bp, o, *ramrod_flags);
 
-		/* Calling function should not diffrentiate between this case
+		/* Calling function should not differentiate between this case
 		 * and the case in which there is already a pending ramrod
 		 */
 		rc = 1;
diff -puN drivers/net/ethernet/hisilicon/hns/hns_enet.c~treewide-correct-diffrent-and-banlance-typos drivers/net/ethernet/hisilicon/hns/hns_enet.c
--- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c~treewide-correct-diffrent-and-banlance-typos
+++ a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
@@ -1207,7 +1207,7 @@ static void hns_set_irq_affinity(struct
 	if (!alloc_cpumask_var(&mask, GFP_KERNEL))
 		return;
 
-	/*diffrent irq banlance for 16core and 32core*/
+	/* different irq balance for 16core and 32core */
 	if (h->q_num == num_possible_cpus()) {
 		for (i = 0; i < h->q_num * 2; i++) {
 			rd = &priv->ring_data[i];
diff -puN drivers/net/ethernet/qlogic/qed/qed_int.c~treewide-correct-diffrent-and-banlance-typos drivers/net/ethernet/qlogic/qed/qed_int.c
--- a/drivers/net/ethernet/qlogic/qed/qed_int.c~treewide-correct-diffrent-and-banlance-typos
+++ a/drivers/net/ethernet/qlogic/qed/qed_int.c
@@ -3057,7 +3057,7 @@ int qed_int_igu_read_cam(struct qed_hwfn
 
 	/* There's a possibility the igu_sb_cnt_iov doesn't properly reflect
 	 * the number of VF SBs [especially for first VF on engine, as we can't
-	 * diffrentiate between empty entries and its entries].
+	 * differentiate between empty entries and its entries].
 	 * Since we don't really support more SBs than VFs today, prevent any
 	 * such configuration by sanitizing the number of SBs to equal the
 	 * number of VFs.
diff -puN drivers/net/ethernet/qlogic/qed/qed_main.c~treewide-correct-diffrent-and-banlance-typos drivers/net/ethernet/qlogic/qed/qed_main.c
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c~treewide-correct-diffrent-and-banlance-typos
+++ a/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -951,7 +951,7 @@ static int qed_slowpath_start(struct qed
 		if (rc)
 			goto err2;
 
-		/* First Dword used to diffrentiate between various sources */
+		/* First Dword used to differentiate between various sources */
 		data = cdev->firmware->data + sizeof(u32);
 
 		qed_dbg_pf_init(cdev);
diff -puN drivers/net/ethernet/qlogic/qed/qed_sriov.c~treewide-correct-diffrent-and-banlance-typos drivers/net/ethernet/qlogic/qed/qed_sriov.c
--- a/drivers/net/ethernet/qlogic/qed/qed_sriov.c~treewide-correct-diffrent-and-banlance-typos
+++ a/drivers/net/ethernet/qlogic/qed/qed_sriov.c
@@ -625,7 +625,7 @@ int qed_iov_hw_info(struct qed_hwfn *p_h
 	 *  - If !ARI, VFs would start on next device.
 	 *    so offset - (256 - pf_id) would provide the number.
 	 * Utilize the fact that (256 - pf_id) is achieved only by later
-	 * to diffrentiate between the two.
+	 * to differentiate between the two.
 	 */
 
 	if (p_hwfn->cdev->p_iov_info->offset < (256 - p_hwfn->abs_pf_id)) {
diff -puN include/linux/mlx4/device.h~treewide-correct-diffrent-and-banlance-typos include/linux/mlx4/device.h
--- a/include/linux/mlx4/device.h~treewide-correct-diffrent-and-banlance-typos
+++ a/include/linux/mlx4/device.h
@@ -108,7 +108,7 @@ enum {
 	MLX4_MFUNC_EQE_MASK     = (MLX4_MFUNC_MAX_EQES - 1)
 };
 
-/* Driver supports 3 diffrent device methods to manage traffic steering:
+/* Driver supports 3 different device methods to manage traffic steering:
  *	-device managed - High level API for ib and eth flow steering. FW is
  *			  managing flow steering tables.
  *	- B0 steering mode - Common low level API for ib and (if supported) eth.
diff -puN scripts/spelling.txt~treewide-correct-diffrent-and-banlance-typos scripts/spelling.txt
--- a/scripts/spelling.txt~treewide-correct-diffrent-and-banlance-typos
+++ a/scripts/spelling.txt
@@ -174,6 +174,7 @@ bakup||backup
 baloon||balloon
 baloons||balloons
 bandwith||bandwidth
+banlance||balance
 batery||battery
 beacuse||because
 becasue||because
@@ -365,6 +366,8 @@ dictionnary||dictionary
 didnt||didn't
 diferent||different
 differrence||difference
+diffrent||different
+diffrentiate||differentiate
 difinition||definition
 diplay||display
 direectly||directly
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions.patch
checkpatch-improve-embedded_function_name-test.patch
checkpatch-allow-space-leading-blank-lines-in-email-headers.patch
treewide-correct-diffrent-and-banlance-typos.patch

