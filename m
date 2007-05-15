From: akpm@linux-foundation.org
Subject: - ppc-mcc2-missing-in-mpc8260-device_list.patch removed from -mm tree
Date: Tue, 15 May 2007 14:17:07 -0700
Message-ID: <200705152117.l4FLH7oo018242@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43734 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753729AbXEOVTe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 May 2007 17:19:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: morten.banzon@ericsson.com, galak@gate.crashing.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     ppc: MCC2 missing in MPC8260 device_list
has been removed from the -mm tree.  Its filename was
     ppc-mcc2-missing-in-mpc8260-device_list.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: ppc: MCC2 missing in MPC8260 device_list
From: Morten Banzon <morten.banzon@ericsson.com>

Adds the MCC2 device to the 8260 device_list.

Signed-off-by: Morten Banzon <morten.banzon@ericsson.com>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ppc/syslib/pq2_sys.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff -puN arch/ppc/syslib/pq2_sys.c~ppc-mcc2-missing-in-mpc8260-device_list arch/ppc/syslib/pq2_sys.c
--- a/arch/ppc/syslib/pq2_sys.c~ppc-mcc2-missing-in-mpc8260-device_list
+++ a/arch/ppc/syslib/pq2_sys.c
@@ -52,8 +52,9 @@ struct ppc_sys_spec ppc_sys_specs[] = {
 		{
 			MPC82xx_CPM_FCC1, MPC82xx_CPM_FCC2, MPC82xx_CPM_FCC3,
 			MPC82xx_CPM_SCC1, MPC82xx_CPM_SCC2, MPC82xx_CPM_SCC3,
-			MPC82xx_CPM_SCC4, MPC82xx_CPM_MCC1, MPC82xx_CPM_SMC1,
-			MPC82xx_CPM_SMC2, MPC82xx_CPM_SPI, MPC82xx_CPM_I2C,
+			MPC82xx_CPM_SCC4, MPC82xx_CPM_MCC1, MPC82xx_CPM_MCC2,
+			MPC82xx_CPM_SMC1, MPC82xx_CPM_SMC2, MPC82xx_CPM_SPI,
+			MPC82xx_CPM_I2C,
 		}
 	},
 	{
_

Patches currently in -mm which might be from morten.banzon@ericsson.com are

ppc-mcc2-missing-in-mpc8260-device_list.patch
