From: akpm@linux-foundation.org
Subject: [folded] alix2-supplement-driver-to-include-gpio-button-support-fix-2.patch removed from -mm tree
Date: Wed, 08 Feb 2012 12:40:13 -0800
Message-ID: <20120208204013.81969A03DE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:51815 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab2BHUkP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Feb 2012 15:40:15 -0500
Received: by eaaf13 with SMTP id f13so28780eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 08 Feb 2012 12:40:14 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: philipp@redfish-solutions.com, jkosina@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: alix2-supplement-driver-to-include-gpio-button-support-fix-2
has been removed from the -mm tree.  Its filename was
     alix2-supplement-driver-to-include-gpio-button-support-fix-2.patch

This patch was dropped because it was folded into alix2-supplement-driver-to-include-gpio-button-support.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: "Philip A. Prindeville" <philipp@redfish-solutions.com>
Subject: alix2-supplement-driver-to-include-gpio-button-support-fix-2

The pointers returned by dmi_get_system_info(), etc. are to invariant
strings, i.e. read-only.

Signed-off-by: Philip A. Prindeville <philipp@redfish-solutions.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/platform/geode/alix.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/platform/geode/alix.c~alix2-supplement-driver-to-include-gpio-button-support-fix-2 arch/x86/platform/geode/alix.c
--- a/arch/x86/platform/geode/alix.c~alix2-supplement-driver-to-include-gpio-button-support-fix-2
+++ a/arch/x86/platform/geode/alix.c
@@ -161,7 +161,7 @@ static bool __init alix_present(unsigned
 
 static bool __init alix_present_dmi(void)
 {
-	char *vendor, *product;
+	const char *vendor, *product;
 
 	vendor = dmi_get_system_info(DMI_SYS_VENDOR);
 	if (!vendor || strcmp(vendor, "PC Engines"))
_

Patches currently in -mm which might be from philipp@redfish-solutions.com are

geos-platform-driver-for-geos-and-geos2-single-board-computers.patch
alix2-supplement-driver-to-include-gpio-button-support.patch
net5501-platform-driver-for-soekris-engineering-net5501-single-board-computer.patch
net5501-platform-driver-for-soekris-engineering-net5501-single-board-computer-fix.patch

