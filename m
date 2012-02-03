From: akpm@linux-foundation.org
Subject: + alix2-supplement-driver-to-include-gpio-button-support-fix-2.patch added to -mm tree
Date: Fri, 03 Feb 2012 14:34:06 -0800
Message-ID: <20120203223406.96934A035C@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qy0-f202.google.com ([209.85.216.202]:50351 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664Ab2BCWeI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2012 17:34:08 -0500
Received: by qcsp5 with SMTP id p5so469707qcs.1
        for <mm-commits@vger.kernel.org>; Fri, 03 Feb 2012 14:34:07 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: philipp@redfish-solutions.com, jkosina@suse.cz


The patch titled
     Subject: alix2-supplement-driver-to-include-gpio-button-support-fix-2
has been added to the -mm tree.  Its filename is
     alix2-supplement-driver-to-include-gpio-button-support-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: alix2-supplement-driver-to-include-gpio-button-support-fix-2

Patches currently in -mm which might be from philipp@redfish-solutions.com are

geos-platform-driver-for-geos-and-geos2-single-board-computers.patch
alix2-supplement-driver-to-include-gpio-button-support.patch
alix2-supplement-driver-to-include-gpio-button-support-fix.patch
alix2-supplement-driver-to-include-gpio-button-support-fix-2.patch
net5501-platform-driver-for-soekris-engineering-net5501-single-board-computer.patch
net5501-platform-driver-for-soekris-engineering-net5501-single-board-computer-fix.patch

