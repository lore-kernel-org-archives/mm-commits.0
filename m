From: akpm@linux-foundation.org
Subject: [obsolete]
 fix-const-confusion-in-intel-mid-x86-platform-drivers.patch removed from
 -mm tree
Date: Tue, 09 Jan 2018 15:19:13 -0800
Message-ID: <5a554df1.cADnYOl9QzL84Gtt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57012 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753329AbeAIXTQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jan 2018 18:19:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, dvhart@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/x86/platform/intel-mid/device_libs/platform_bt.c: fix const confusion
has been removed from the -mm tree.  Its filename was
     fix-const-confusion-in-intel-mid-x86-platform-drivers.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: arch/x86/platform/intel-mid/device_libs/platform_bt.c: fix const confusion

const must be marked __initconst, not __initdata

Link: http://lkml.kernel.org/r/20171222001443.2067-1-andi@firstfloor.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Reviewed-by: Darren Hart (VMware) <dvhart@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/platform/intel-mid/device_libs/platform_bt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/platform/intel-mid/device_libs/platform_bt.c~fix-const-confusion-in-intel-mid-x86-platform-drivers arch/x86/platform/intel-mid/device_libs/platform_bt.c
--- a/arch/x86/platform/intel-mid/device_libs/platform_bt.c~fix-const-confusion-in-intel-mid-x86-platform-drivers
+++ a/arch/x86/platform/intel-mid/device_libs/platform_bt.c
@@ -60,7 +60,7 @@ static int __init tng_bt_sfi_setup(struc
 	return 0;
 }
 
-static const struct bt_sfi_data tng_bt_sfi_data __initdata = {
+static const struct bt_sfi_data tng_bt_sfi_data __initconst = {
 	.setup	= tng_bt_sfi_setup,
 };
 
_

Patches currently in -mm which might be from ak@linux.intel.com are

fix-const-confusion-in-certs-blacklist.patch
fix-read-buffer-overflow-in-delta-ipc.patch

