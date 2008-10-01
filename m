From: akpm@linux-foundation.org
Subject: - net-atm-lecc-drop-code-after-return.patch removed from -mm tree
Date: Wed, 01 Oct 2008 14:50:56 -0700
Message-ID: <200810012150.m91LouaN005880@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47164 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753788AbYJAVvG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2008 17:51:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, chas@cmf.nrl.navy.mil, richard.genoud@gmail.com, mm-commits@vger.kernel.org


The patch titled
     net/atm/lec.c: drop code after return
has been removed from the -mm tree.  Its filename was
     net-atm-lecc-drop-code-after-return.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: net/atm/lec.c: drop code after return
From: Julia Lawall <julia@diku.dk>

The break after the return serves no purpose.

Signed-off-by: Julia Lawall <julia@diku.dk>
Reviewed-by: Richard Genoud <richard.genoud@gmail.com>
Cc: Chas Williams <chas@cmf.nrl.navy.mil>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/atm/lec.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN net/atm/lec.c~net-atm-lecc-drop-code-after-return net/atm/lec.c
--- a/net/atm/lec.c~net-atm-lecc-drop-code-after-return
+++ a/net/atm/lec.c
@@ -1931,7 +1931,6 @@ static struct atm_vcc *lec_arp_resolve(s
 		switch (priv->lane_version) {
 		case 1:
 			return priv->mcast_vcc;
-			break;
 		case 2:	/* LANE2 wants arp for multicast addresses */
 			if (!compare_ether_addr(mac_to_find, bus_mac))
 				return priv->mcast_vcc;
_

Patches currently in -mm which might be from julia@diku.dk are

git-v4l-dvb.patch
git-infiniband.patch
git-ieee1394.patch
git-async_tx.patch
git-net.patch
git-mtd.patch
git-sound.patch
git-cpufreq.patch
git-gfs2.patch
git-ubifs.patch
git-block.patch
drivers-media-common-tuners-drop-code-after-return-or-goto.patch
drivers-scsi-use-div_round_up.patch
drivers-scsi-megaraid-use-div_round_up.patch
fs-namespacec-drop-code-after-return.patch
drivers-misc-use-div_round_up.patch
drivers-net-xen-netfrontc-use-div_round_up.patch
fs-reiserfs-use-an-is_err-test-rather-than-a-null-test.patch

