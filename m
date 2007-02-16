From: akpm@linux-foundation.org
Subject: + update-doc-oops-tracingtxt-for-taint_user-fix.patch added to -mm tree
Date: Fri, 16 Feb 2007 13:24:01 -0800
Message-ID: <200702162124.l1GLO1nq010230@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36676 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946260AbXBPVYJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Feb 2007 16:24:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, tytso@mit.edu


The patch titled
     update Doc/oops-tracing.txt for TAINT_USER (fix)
has been added to the -mm tree.  Its filename is
     update-doc-oops-tracingtxt-for-taint_user-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: update Doc/oops-tracing.txt for TAINT_USER (fix)
From: Randy Dunlap <randy.dunlap@oracle.com>

Add TAINT_USER description to Tainted flags in oops-tracing.txt.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/oops-tracing.txt |    3 +++
 1 files changed, 3 insertions(+)

diff -puN Documentation/oops-tracing.txt~update-doc-oops-tracingtxt-for-taint_user-fix Documentation/oops-tracing.txt
--- a/Documentation/oops-tracing.txt~update-doc-oops-tracingtxt-for-taint_user-fix
+++ a/Documentation/oops-tracing.txt
@@ -237,6 +237,9 @@ characters, each representing a particul
   7: 'U' if a user specifically requested that the Tainted flag be set,
      ' ' otherwise.
 
+  7: 'U' if a user or user application specifically requested that the
+     Tainted flag be set, ' ' otherwise.
+
 The primary reason for the 'Tainted: ' string is to tell kernel
 debuggers if this is a clean kernel or if anything unusual has
 occurred.  Tainting is permanent: even if an offending module is
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
irq-kernel-doc-fixes.patch
git-acpi.patch
build-errors-uevent-with-config_sysfs=n.patch
sata-use-null-for-ptrs.patch
git-mtd.patch
git-netdev-all.patch
phy-layer-add-kernel-doc-docbook.patch
parisc-fix-module_param-iommu-permission.patch
ueagle-atmc-needs-schedh.patch
kernel-doc-include-struct-short-description-in-title.patch
tty-use-null-for-ptrs.patch
cdrom-use-unsigned-bitfields.patch
update-doc-oops-tracingtxt-for-taint_user.patch
update-doc-oops-tracingtxt-for-taint_user-fix.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
reiser4-use-null-for-pointers.patch
profile_likely-export-do_check_likely.patch
