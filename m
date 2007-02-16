From: akpm@linux-foundation.org
Subject: + update-doc-oops-tracingtxt-for-taint_user.patch added to -mm tree
Date: Thu, 15 Feb 2007 17:31:39 -0800
Message-ID: <200702160131.l1G1VdOO015529@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42331 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932870AbXBPBbn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 20:31:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     update Doc/oops-tracing.txt for TAINT_USER
has been added to the -mm tree.  Its filename is
     update-doc-oops-tracingtxt-for-taint_user.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: update Doc/oops-tracing.txt for TAINT_USER
From: Randy Dunlap <randy.dunlap@oracle.com>

Add TAINT_USER description to Tainted flags in oops-tracing.txt.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/oops-tracing.txt |    3 +++
 1 files changed, 3 insertions(+)

diff -puN Documentation/oops-tracing.txt~update-doc-oops-tracingtxt-for-taint_user Documentation/oops-tracing.txt
--- a/Documentation/oops-tracing.txt~update-doc-oops-tracingtxt-for-taint_user
+++ a/Documentation/oops-tracing.txt
@@ -234,6 +234,9 @@ characters, each representing a particul
   6: 'B' if a page-release function has found a bad page reference or
      some unexpected page flags.
 
+  7: 'U' if a user specifically requested that the Tainted flag be set,
+     ' ' otherwise.
+
 The primary reason for the 'Tainted: ' string is to tell kernel
 debuggers if this is a clean kernel or if anything unusual has
 occurred.  Tainting is permanent: even if an offending module is
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
build-errors-uevent-with-config_sysfs=n.patch
git-acpi.patch
sata-use-null-for-ptrs.patch
git-mtd.patch
git-netdev-all.patch
phy-layer-add-kernel-doc-docbook.patch
parisc-fix-module_param-iommu-permission.patch
ueagle-atmc-needs-schedh.patch
x86-dont-probe-for-ddc-on-vbe12.patch
kernel-doc-include-struct-short-description-in-title.patch
tty-use-null-for-ptrs.patch
cdrom-use-unsigned-bitfields.patch
update-doc-oops-tracingtxt-for-taint_user.patch
irq-kernel-doc-fixes.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
reiser4-use-null-for-pointers.patch
profile_likely-export-do_check_likely.patch
