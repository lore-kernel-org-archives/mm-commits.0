From: akpm@linux-foundation.org
Subject: - fix-sysfs-build-breakage-if-config_sysfs.patch removed from -mm tree
Date: Thu, 01 Mar 2007 21:07:39 -0800
Message-ID: <200703020507.l2257d70000887@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42603 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422801AbXCBFK5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 00:10:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     Fix sysfs build breakage if !CONFIG_SYSFS
has been removed from the -mm tree.  Its filename was
     fix-sysfs-build-breakage-if-config_sysfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix sysfs build breakage if !CONFIG_SYSFS
From: Ralf Baechle <ralf@linux-mips.org>

B0rkage introduced by dfa87c824a9a5430008acd1ed2e8111ed164fcbe.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sysfs.h |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

diff -puN include/linux/sysfs.h~fix-sysfs-build-breakage-if-config_sysfs include/linux/sysfs.h
--- a/include/linux/sysfs.h~fix-sysfs-build-breakage-if-config_sysfs
+++ a/include/linux/sysfs.h
@@ -212,9 +212,8 @@ static inline int sysfs_add_file_to_grou
 }
 
 static inline void sysfs_remove_file_from_group(struct kobject *kobj,
-		const struct attribute *attr, const char *group);
+		const struct attribute *attr, const char *group)
 {
-	;
 }
 
 static inline void sysfs_notify(struct kobject * k, char *dir, char *attr)
_

Patches currently in -mm which might be from ralf@linux-mips.org are

origin.patch
serial-driver-pmc-msp71xx.patch
rm9000-serial-driver.patch
rm9000-serial-driver-tidy.patch
x86_64-fix-ia32_binfmtc-build-error.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
simplify-the-stacktrace-code.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
mips-convert-to-use-shared-apm-emulation-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-mips.patch
local_t-mips-extension.patch
local_t-mips-extension-fix.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix.patch
tgafb-turbochannel-support.patch
