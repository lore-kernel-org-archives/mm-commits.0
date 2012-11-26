From: akpm@linux-foundation.org
Subject: [obsolete] drivers-of-fdtc-re-use-kernels-kbasename-fix.patch removed from -mm tree
Date: Mon, 26 Nov 2012 14:19:17 -0800
Message-ID: <20121126221918.9F6B220004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:58190 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756712Ab2KZWTV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Nov 2012 17:19:21 -0500
Received: by mail-we0-f202.google.com with SMTP id t57so350573wey.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Nov 2012 14:19:20 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: grant.likely@secretlab.ca, andriy.shevchenko@linux.intel.com, rob.herring@calxeda.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers-of-fdtc-re-use-kernels-kbasename-fix
has been removed from the -mm tree.  Its filename was
     drivers-of-fdtc-re-use-kernels-kbasename-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Grant Likely <grant.likely@secretlab.ca>
Subject: drivers-of-fdtc-re-use-kernels-kbasename-fix

drivers/of/fdt.c: In function 'of_scan_flat_dt':
drivers/of/fdt.c:490:10: warning: assignment discards 'const' qualifier from pointer target type [enabled by default]

Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/of/fdt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/of/fdt.c~drivers-of-fdtc-re-use-kernels-kbasename-fix drivers/of/fdt.c
--- a/drivers/of/fdt.c~drivers-of-fdtc-re-use-kernels-kbasename-fix
+++ a/drivers/of/fdt.c
@@ -460,7 +460,7 @@ int __init of_scan_flat_dt(int (*it)(uns
 
 	do {
 		u32 tag = be32_to_cpup((__be32 *)p);
-		char *pathp;
+		const char *pathp;
 
 		p += 4;
 		if (tag == OF_DT_END_NODE) {
_

Patches currently in -mm which might be from grant.likely@secretlab.ca are

linux-next.patch
backlight-add-of_find_backlight_by_node-function.patch
backlight-add-of_find_backlight_by_node-function-fix-2.patch
drivers-of-fdtc-re-use-kernels-kbasename.patch
rtc-omap-kicker-mechanism-support.patch
arm-davinci-remove-rtc-kicker-release.patch
rtc-omap-dt-support.patch
rtc-omap-depend-on-am33xx.patch
rtc-omap-add-runtime-pm-support.patch
rtc-imxdi-support-for-imx53.patch
rtc-imxdi-add-devicetree-support.patch
arm-mach-imx-support-for-dryice-rtc-in-imx53.patch

